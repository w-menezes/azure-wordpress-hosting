#!/bin/bash
set -e

# Install dependencies
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine & Compose plugin
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add admin user to docker group
usermod -aG docker $USER

# Enable Docker at boot
systemctl enable docker
systemctl start docker
