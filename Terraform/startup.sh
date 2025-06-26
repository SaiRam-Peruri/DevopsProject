#!/bin/bash

# Update packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Allow current user to run docker
sudo usermod -aG docker $USER

# Build Docker image from a given Dockerfile (assume it's cloned or copied here)
cd /opt/myapp || mkdir -p /opt/myapp && cd /opt/myapp

# Placeholder: fetch your code and Dockerfile (via git or file copy)
git clone https://github.com/your-org/your-repo.git .
# OR copy it from storage bucket
# gsutil cp gs://your-bucket/app/* .

# Build image (change 'myapp-image' to your tag)
sudo docker build -t myapp-image .

# Run container on HTTPS (port 443)
# Assuming Dockerfile exposes HTTPS (you must map certs if needed)
sudo docker run -d -p 443:443 --name myapp-container myapp-image

# Optional: write logs
echo "App started on port 443" >> /var/log/myapp-startup.log
