# ACEest Fitness DevOps Setup Script (PowerShell)
# Automates the entire setup process

param(
    [Parameter(Position=0)]
    [ValidateSet("full", "docker", "jenkins", "minikube", "deploy", "test", "help")]
    [string]$Mode = "help"
)

$ErrorActionPreference = "Stop"

function Show-Banner {
    Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║     ACEest Fitness & Gym - DevOps Setup Automation        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan
}

function Show-Help {
    Show-Banner
    Write-Host "Usage: .\setup-devops.ps1 [mode]`n"
    Write-Host "Modes:"
    Write-Host "  full      - Complete setup (Docker, Jenkins, Tests, Deploy)"
    Write-Host "  docker    - Build and test Docker image"
    Write-Host "  jenkins   - Start Jenkins container"
    Write-Host "  minikube  - Setup Minikube and deploy"
    Write-Host "  deploy    - Deploy to existing Kubernetes cluster"
    Write-Host "  test      - Run all tests"
    Write-Host "  help      - Show this message`n"
}

function Test-Prerequisites {
    Write-Host "✓ Checking prerequisites..." -ForegroundColor Yellow
    
    $requirements = @("docker", "git", "python")
    $missing = @()
    
    foreach ($req in $requirements) {
        if (-not (Get-Command $req -ErrorAction SilentlyContinue)) {
            $missing += $req
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Host "✗ Missing required tools: $($missing -join ', ')" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✓ All prerequisites found" -ForegroundColor Green
}

function Run-Tests {
    Write-Host "`n▶ Running unit tests..." -ForegroundColor Cyan
    
    python -m pytest tests/ -v
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ All tests passed" -ForegroundColor Green
    } else {
        Write-Host "✗ Tests failed" -ForegroundColor Red
        exit 1
    }
}

function Build-Docker {
    Write-Host "`n▶ Building Docker image..." -ForegroundColor Cyan
    
    docker build -t aceest-fitness:latest .
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Docker image built successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Docker build failed" -ForegroundColor Red
        exit 1
    }
}

function Test-Docker {
    Write-Host "`n▶ Testing Docker container..." -ForegroundColor Cyan
    
    # Remove old container if exists
    docker stop aceest-app -ErrorAction SilentlyContinue
    docker rm aceest-app -ErrorAction SilentlyContinue
    
    # Run container
    docker run -d -p 5000:5000 --name aceest-app aceest-fitness:latest
    Start-Sleep -Seconds 5
    
    # Test endpoint
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5000/version" -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ Docker container running and responding" -ForegroundColor Green
        }
    } catch {
        Write-Host "✗ Container test failed" -ForegroundColor Red
        exit 1
    }
    
    # Cleanup
    docker stop aceest-app
    docker rm aceest-app
}

function Start-Jenkins {
    Write-Host "`n▶ Starting Jenkins..." -ForegroundColor Cyan
    
    # Check if already running
    $jenkins = docker ps -f "name=jenkins" --format "{{.Names}}"
    
    if ($jenkins) {
        Write-Host "✓ Jenkins already running" -ForegroundColor Green
    } else {
        docker-compose up -d
        Write-Host "Waiting for Jenkins to start..." -ForegroundColor Yellow
        Start-Sleep -Seconds 15
        
        # Get admin password
        $password = docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
        Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "║             Jenkins is Running!                             ║" -ForegroundColor Green
        Write-Host "║  URL: http://localhost:8080                                 ║" -ForegroundColor Green
        Write-Host "║  Initial Admin Password: $password ║" -ForegroundColor Green
        Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green
    }
}

function Setup-Minikube {
    Write-Host "`n▶ Setting up Minikube..." -ForegroundColor Cyan
    
    # Check if Minikube is installed
    if (-not (Get-Command minikube -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Minikube..." -ForegroundColor Yellow
        choco install minikube -y
    }
    
    # Start Minikube
    minikube start
    
    # Get IP
    $minikubeIp = minikube ip
    Write-Host "✓ Minikube started at $minikubeIp" -ForegroundColor Green
    
    # Set up kubectl context
    kubectl config use-context minikube
}

function Deploy-ToKubernetes {
    Write-Host "`n▶ Deploying to Kubernetes..." -ForegroundColor Cyan
    
    # Apply rolling update deployment
    kubectl apply -f k8s-rolling-update.yaml
    
    # Wait for deployment
    Write-Host "Waiting for deployment to be ready..." -ForegroundColor Yellow
    kubectl rollout status deployment/aceest-fitness -t 300
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Deployment successful" -ForegroundColor Green
        
        # Display service info
        Write-Host "`n═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "Deployment Information:" -ForegroundColor Cyan
        kubectl get pods
        Write-Host ""
        kubectl get svc
        Write-Host "═══════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
    } else {
        Write-Host "✗ Deployment failed" -ForegroundColor Red
        exit 1
    }
}

function Full-Setup {
    Show-Banner
    Test-Prerequisites
    Run-Tests
    Build-Docker
    Test-Docker
    Start-Jenkins
    Setup-Minikube
    Deploy-ToKubernetes
    
    Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║           🎉 Setup Complete! 🎉                             ║" -ForegroundColor Green
    Write-Host "║                                                              ║" -ForegroundColor Green
    Write-Host "│ Jenkins: http://localhost:8080                             ║" -ForegroundColor Green
    Write-Host "│ App: kubectl port-forward svc/aceest-fitness-service :5000 ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green
}

# Main switch
switch ($Mode) {
    "full" { Full-Setup }
    "docker" { Test-Prerequisites; Run-Tests; Build-Docker; Test-Docker }
    "jenkins" { Start-Jenkins }
    "minikube" { Setup-Minikube; Deploy-ToKubernetes }
    "deploy" { Deploy-ToKubernetes }
    "test" { Run-Tests }
    "help" { Show-Help }
    default { Show-Help }
}