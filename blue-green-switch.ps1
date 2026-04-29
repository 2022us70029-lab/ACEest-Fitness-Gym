# Blue-Green Deployment Switch Script (PowerShell)
# This script switches traffic from blue deployment to green deployment

param(
    [Parameter(Position=0)]
    [ValidateSet("to-blue", "to-green", "status", "help")]
    [string]$Command = "help"
)

function Show-Help {
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host "Blue-Green Deployment Switch" -ForegroundColor Cyan
    Write-Host "===================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage: .\blue-green-switch.ps1 [command]`n"
    Write-Host "Commands:"
    Write-Host "  to-blue      Switch traffic to blue deployment"
    Write-Host "  to-green     Switch traffic to green deployment"
    Write-Host "  status       Show current traffic target"
    Write-Host "  help         Show this help message"
}

function Switch-ToBlue {
    Write-Host "Switching traffic to BLUE deployment..." -ForegroundColor Yellow
    kubectl patch service aceest-fitness-service -p '{"spec":{"selector":{"version":"blue"}}}'
    Write-Host "✓ Traffic switched to BLUE" -ForegroundColor Green
    kubectl get svc aceest-fitness-service -o jsonpath='{.spec.selector}'
}

function Switch-ToGreen {
    Write-Host "Switching traffic to GREEN deployment..." -ForegroundColor Yellow
    kubectl patch service aceest-fitness-service -p '{"spec":{"selector":{"version":"green"}}}'
    Write-Host "✓ Traffic switched to GREEN" -ForegroundColor Green
    kubectl get svc aceest-fitness-service -o jsonpath='{.spec.selector}'
}

function Get-Status {
    Write-Host "Current traffic target:" -ForegroundColor Cyan
    kubectl get svc aceest-fitness-service -o jsonpath='{.spec.selector}' | ConvertFrom-Json
}

switch ($Command) {
    "to-blue" { Switch-ToBlue }
    "to-green" { Switch-ToGreen }
    "status" { Get-Status }
    "help" { Show-Help }
    default { Show-Help }
}