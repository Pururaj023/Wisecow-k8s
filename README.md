# Cow Wisdom Web Server

A containerized web application that serves wise cow sayings, deployable on both Docker and Kubernetes (Minikube).

## Docker Deployment

### Build Docker Image

```bash
docker build -t wisecow .
```

### Run the Docker Container

```bash
docker run -d -p 4499:4499 --name wisecow-container wisecow
```

## Kubernetes Deployment (Minikube)

The `k8s/` folder contains all required YAML files for Minikube deployment.

### Prerequisites

1. **Start Minikube with Docker driver:**
   ```bash
   minikube start --memory=4096 --driver=docker
   ```

2. **Enable Ingress addon:**
   ```bash
   minikube addons enable ingress
   ```

### TLS Certificate Setup

Create and configure TLS certificates for secure HTTPS access:

```bash
# Generate TLS certificate using OpenSSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key \
  -out tls.crt \
  -subj "/CN=wisecow.local/O=wisecow"

# Create Kubernetes secret with TLS certificate
kubectl create secret tls wisecow-tls -n wisecow --key tls.key --cert tls.crt
```

### Build Image in Minikube

Since we're using Minikube, build the Docker image inside the Minikube environment:

```bash
# Configure Docker to use Minikube's Docker daemon
minikube docker-env

# For PowerShell users:
minikube -p minikube docker-env | Invoke-Expression

# Build the image
docker build -t wisecow:latest .
```

### Deploy Application

Deploy the application components in the following order:

```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy service
kubectl apply -f k8s/service.yaml

# Deploy application
kubectl apply -f k8s/deployment.yaml

# Configure ingress
kubectl apply -f k8s/ingress.yaml
```

### Configure Local Access

1. **Add Minikube IP to hosts file:**
   ```bash
   # Get Minikube IP
   minikube ip
   
   # Add to /etc/hosts (Linux/Mac) or C:\Windows\System32\drivers\etc\hosts (Windows)
   <minikube-ip> wisecow.local
   ```

2. **Enable network tunneling:**
   ```bash
   # Create tunnel to access services on localhost
   minikube tunnel
   ```

### Testing the Service

After completing the deployment steps, you can access the Cow Wisdom web server at:
- HTTP: `http://wisecow.local`
- HTTPS: `https://wisecow.local` (with TLS certificate)

## Project Structure

```
.
├── Dockerfile
├── README.md
└── k8s/
    ├── namespace.yaml
    ├── service.yaml
    ├── deployment.yaml
    └── ingress.yaml
```

## Notes

- The application runs on port 4499 by default
- TLS certificate is valid for 365 days
- Memory allocation for Minikube is set to 4GB for optimal performance
- The `minikube tunnel` command needs to remain running to maintain localhost access