#!/bin/bash

# Update package list
sudo apt-get update -y && \

# Install necessary packages
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && \

# Add Docker's official GPG key and avoid deprecation warning
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \

# Set up the Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \

# Update package list again
sudo apt-get update -y && \

# Install Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io && \

# Add the ubuntu user to the docker group
sudo usermod -aG docker ubuntu
