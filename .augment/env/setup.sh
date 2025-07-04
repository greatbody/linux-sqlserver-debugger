#!/bin/bash

echo "=== Setting up git and pulling latest changes ==="
git config --global user.email "test@example.com" 2>/dev/null || true
git config --global user.name "Test User" 2>/dev/null || true
git pull

echo -e "\n=== Installing Docker and basic tools ==="
sudo apt-get update -qq
sudo apt-get install -y curl wget git build-essential

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

echo -e "\n=== Creating Dockerfile based on requirements ==="
cat > Dockerfile << 'EOF'
# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y

# Update package list and install basic tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    lsb-release

# Add Microsoft repository keys and sources
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

# Install Azure CLI repository
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Update package list and install required packages
RUN apt-get update && apt-get install -y \
    mssql-tools18 \
    unixodbc-dev \
    azure-cli

# Add mssql-tools to PATH
ENV PATH="$PATH:/opt/mssql-tools18/bin"

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Keep container running indefinitely for docker exec access
CMD ["sleep", "infinity"]
EOF

echo -e "\n=== Building Docker image ==="
docker build -t sql-server-connector .

echo -e "\n=== Starting Docker container ==="
# Stop and remove any existing container with the same name
docker stop sql-connector-test 2>/dev/null || true
docker rm sql-connector-test 2>/dev/null || true

# Start new container
docker run -d --name sql-connector-test sql-server-connector

echo -e "\n=== Verifying container accessibility ==="
echo "Container status:"
docker ps | grep sql-connector-test

echo -e "\nTesting docker exec access:"
docker exec sql-connector-test echo "Container is accessible via docker exec"

echo -e "\n=== Docker setup complete ==="