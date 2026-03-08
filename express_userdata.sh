#!/bin/bash

# Update
apt update -y
apt upgrade -y

# Install dependencies
apt install -y curl git docker.io

# Enable Docker
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# Install Docker Compose (latest)
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

cd /home/ubuntu

# Clone repo
git clone https://github.com/coder-ocean/flask-express-2ec2-app.git

cd flask-express-2ec2-app

# Run containers
docker-compose up -d