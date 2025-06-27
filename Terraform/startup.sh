#!/bin/bash

# Update and install Docker
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release git
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group (requires re-login to take effect)
sudo usermod -aG docker $USER

# Clone your app
mkdir -p /opt/myapp && cd /opt/myapp
git clone https://github.com/SaiRam-Peruri/DevopsProject.git .

# Build your app Docker image
sudo docker build -t myapp-image .

# Create self-signed certs for HTTPS
mkdir -p /opt/myapp/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /opt/myapp/certs/selfsigned.key \
  -out /opt/myapp/certs/selfsigned.crt \
  -subj "/CN=localhost"

# Create NGINX reverse proxy config (with redirect from / to /home)
cat <<EOF > /opt/myapp/nginx.conf
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/nginx/certs/selfsigned.crt;
    ssl_certificate_key /etc/nginx/certs/selfsigned.key;

    # Redirect / to /home
    location = / {
        return 302 /home;
    }

    location / {
        proxy_pass http://myapp:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

# Create Docker network
sudo docker network create myapp-net

# Run your Go app container
sudo docker run -d --name myapp --network myapp-net myapp-image

# Run NGINX container for HTTPS reverse proxy
sudo docker run -d \
  --name nginx-ssl \
  --network myapp-net \
  -p 443:443 \
  -v /opt/myapp/nginx.conf:/etc/nginx/conf.d/default.conf \
  -v /opt/myapp/certs:/etc/nginx/certs \
  nginx:alpine

# Log deployment
echo "App deployed with HTTPS on port 443" >> /var/log/myapp-startup.log
