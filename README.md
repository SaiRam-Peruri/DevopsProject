# DevOps Study Planner – Full Stack & Cloud Deployment Guide

Welcome to the DevOps Study Planner! This project demonstrates a full-stack Go web application, containerized with Docker, deployable to Kubernetes (with Helm), and fully automatable on Google Cloud Platform (GCP) using Terraform.

---

## Table of Contents
- [Features](#features)
- [Local Development](#local-development)
- [Docker Usage](#docker-usage)
- [Kubernetes & Helm Deployment](#kubernetes--helm-deployment)
- [Terraform GCP Infrastructure](#terraform-gcp-infrastructure)
- [CI/CD](#cicd)
- [Project Structure](#project-structure)
- [Credits](#credits)

---

## Features
- Go web server serving static HTML pages
- Docker multi-stage build (distroless for production)
- Helm chart and raw Kubernetes manifests
- Terraform for GCP VPC, firewall, VM, API enabling, etc.
- Automated HTTPS with NGINX reverse proxy on VM
- GitHub Actions for CI/CD

---

## Local Development
1. **Build and run the Go app:**
   ```sh
   go build -o app main.go
   ./app
   # or on Windows:
   go build -o app.exe main.go
   app.exe
   ```
2. Visit [http://localhost:8080/home](http://localhost:8080/home) and other routes.

---

## Docker Usage
1. **Build the Docker image:**
   ```sh
   docker build -t go-web-app .
   ```
2. **Run the container:**
   ```sh
   docker run -p 8080:8080 go-web-app
   # or in detached mode:
   docker run -d -p 8080:8080 go-web-app
   ```
3. Access the app at [http://localhost:8080/home](http://localhost:8080/home).

---

## Kubernetes & Helm Deployment

### Using Raw Manifests
1. Build and push your Docker image to a registry (e.g., GCR):
   ```sh
   docker tag go-web-app gcr.io/<your-project-id>/go-web-app:latest
   docker push gcr.io/<your-project-id>/go-web-app:latest
   ```
2. Update the image in `k8s/manifests/deployment.yaml`.
3. Apply manifests:
   ```sh
   kubectl apply -f k8s/manifests/
   ```

### Using Helm
1. Update `image.repository` and `image.tag` in `helm/go-web-app-chart/values.yaml`.
2. Install the chart:
   ```sh
   helm install go-web-app ./helm/go-web-app-chart
   # or upgrade:
   helm upgrade --install go-web-app ./helm/go-web-app-chart
   ```

---

## Terraform GCP Infrastructure (with VM & Automated HTTPS Docker Deployment)

### Prerequisites
- [Terraform](https://www.terraform.io/downloads.html)
- GCP project and service account with IAM roles
- Service account key as `credentials.json` in the `Terraform/` directory

### What This Deploys
- **VPC and Subnet:** Custom network and subnet for your resources.
- **Firewall:** 
  - SSH (22) only from your IP (edit in `vpc.tf`)
  - HTTPS (443, 8443) open to all
- **Compute Engine VM:** 
  - Ubuntu VM with Docker installed
  - Your app repo is cloned and Docker image built on the VM
  - Self-signed SSL certs are generated
  - NGINX container runs as HTTPS reverse proxy (port 443)
  - Your Go app runs in a Docker container, proxied by NGINX
- **Outputs:** Public IP, instance name, VPC/subnet names, and SSH command

### Usage

1. **Edit variables in `variable.tf` as needed.**
2. **Enable required APIs in `enable-apis.tf`:**
   ```hcl
   resource "google_project_service" "compute" {
     project = var.project_id
     service = "compute.googleapis.com"
   }
   # Add more as needed
   ```
3. **Place your service account key as `credentials.json` in the `Terraform/` directory.**
4. **Initialize and apply:**
   ```sh
   cd Terraform
   terraform init
   terraform plan
   terraform apply
   ```
5. **After apply:**
   - Find your VM’s public IP in the Terraform output.
   - Access your app at: `https://<VM_PUBLIC_IP>/home`
   - SSH using the provided command in the output.

### Notes
- The VM will automatically install Docker, build your app image, and run both your app and NGINX for HTTPS (see `startup.sh`).
- The NGINX config redirects `/` to `/home` and proxies all traffic to your Go app.
- The firewall restricts SSH to your IP and allows HTTPS for everyone.
- You can customize the startup script in `startup.sh` for further automation.

---

## CI/CD
- See `.github/workflows/cicd.yaml` for GitHub Actions pipeline.
- Automate build, test, and deploy steps as needed.

---

## Project Structure
```
.
├── main.go, main_test.go, go.mod
├── static/ (HTML files)
├── Dockerfile
├── helm/go-web-app-chart/ (Helm chart)
├── k8s/manifests/ (Kubernetes YAMLs)
├── Terraform/ (all .tf files, credentials.json, startup.sh)
├── .github/workflows/cicd.yaml
└── README.md
```

---

## Credits
- Built with Go, Docker, Kubernetes, Helm, Terraform, and GCP.
- For more, see the official docs for each tool.

---

**Happy DevOps-ing!**