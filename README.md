
# 🏋️ ACEest Fitness & Gym - DevOps CI/CD Pipeline

## 📌 Project Overview

This project demonstrates a complete DevOps pipeline for a Flask-based fitness management application. It includes version control, automated testing, containerization, and CI/CD pipelines using GitHub Actions and Jenkins.

---

## 🚀 Features

* Flask Web Application
* REST API (`/members`)
* Unit Testing using Pytest
* Docker Containerization
* GitHub Actions CI Pipeline
* Jenkins Build Integration

---

## 🛠️ Tech Stack

* Python 3.14.3
* Flask
* Pytest
* Docker
* GitHub Actions
* Jenkins

---

## 📂 Project Structure

```
├── app.py
├── requirements.txt
├── Dockerfile
└── tests/
    └── test_app.py
├── .gitignore
└── .github/
    └── workflows/
        └── main.yml
```

---

## ⚙️ Local Setup

### Prerequisites
- Python 3.11+
- Docker Desktop
- Jenkins (installed locally or on a server)
- Minikube or Kubernetes cluster
- SonarQube (optional for code quality)

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/2022us70029-lab/ACEest-Fitness-Gym.git
   cd ACEest-Fitness-Gym
   ```

2. **Install Python Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run Tests**
   ```bash
   python -m pytest tests/
   ```

4. **Build Docker Image**
   ```bash
   docker build -t 2022us70029/aceest-fitness-gym:latest .
   ```

5. **Run Locally**
   ```bash
   python app.py
   # or with Docker
   docker run -p 5000:5000 aceest-fitness:latest
   ```

### Jenkins Setup
1. Install Jenkins from https://www.jenkins.io/download/
2. Start Jenkins and access at http://localhost:8080
3. Install required plugins: Docker, Kubernetes, etc.
4. Create a new pipeline job and point to the Jenkinsfile in the repo.

### Kubernetes Deployment
1. Install Minikube: https://minikube.sigs.k8s.io/docs/start/
2. Start Minikube: `minikube start`
3. Deploy: `kubectl apply -f k8s-deployment.yaml`

### SonarQube Integration
1. Install SonarQube locally or use cloud version
2. Add sonar-project.properties file
3. Integrate into Jenkins pipeline

---

```bash
git clone https://github.com/2022us70029-lab/ACEest-Fitness-Gym.git
```

###  Create Virtual Environment

```bash
python -m venv venv
venv\Scripts\activate   # Windows
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

###  Run Application

```bash
python app.py
```

App will run at:

```

###  Access Application

* http://127.0.0.1:5000
* http://127.0.0.1:5000/members

```

---

## 🧪 Run Tests Manually

```bash
pytest
```

---

## 🐳 Docker Setup

### Build Image

```bash
docker build -t aceest-fitness-app .
```

### Run Container

```bash
docker run -p 5000:5000 aceest-fitness-app
```

---

## 🔄 GitHub Actions CI Pipeline

Pipeline runs on every:

* Push
* Pull Request

### Steps:

1. Install dependencies
2. Run lint (flake8)
3. Execute tests (pytest)
4. Build Docker image
5. Run tests inside container

---

## ⚙️ Jenkins Integration

Jenkins is used as a secondary build validation tool.

### Steps:

1. Run Jenkins using Docker
2. Create Pipeline Job
3. Connect GitHub Repository
   * Add Webhook in GitHub
        - Go to repo → Settings → Webhooks
        - Add: http://your-ip:8080/github-webhook/
        - Now Jenkins runs automatically on push
4. Execute:

   * Clone repo
   * Install dependencies
   * Run tests
   * Build Docker image

---

## ✅ Outcome

* Automated CI/CD pipeline
* Consistent build environment using Docker
* Code quality ensured via lint + testing
* Dual validation via GitHub Actions + Jenkins

---

## 📌 Author

Sunil Kumar
