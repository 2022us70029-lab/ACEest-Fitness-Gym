pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'docker.io'
        IMAGE_NAME = '2022us70029/aceest-fitness-gym'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_HUB_REPO = '2022us70029/aceest-fitness-gym'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM', 
                        branches: [[name: '*/main']], 
                        userRemoteConfigs: [[url: 'https://github.com/2022us70029-lab/ACEest-Fitness-Gym.git']]
                    ])
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    bat 'pip install -r requirements.txt'
                }
            }
        }

        stage('Code Quality - Lint') {
            steps {
                script {
                    bat 'flake8 app.py --count --select=E9,F63,F7,F82 --show-source --statistics || exit 0'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    bat 'python -m pytest tests/ -v'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    bat "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                        bat "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                        bat "docker push ${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    bat 'kubectl apply -f k8s-deployment.yaml'
                    bat 'kubectl rollout status deployment/aceest-fitness-gym'
                }
            }
        }

        stage('Smoke Tests') {
            steps {
                script {
                    bat 'timeout /t 10'
                    bat 'powershell -Command "Invoke-WebRequest -Uri http://localhost:5000/version -ErrorAction Stop"'
                }
            }
        }
    }

    post {
        always {
            bat "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest || exit 0"
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded! Deployment complete.'
        }
        failure {
            echo 'Pipeline failed! Check logs above.'
        }
    }
}