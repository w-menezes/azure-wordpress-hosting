#!/bin/bash
set -e

# Update system
apt update && apt upgrade -y

# Create unattended-upgrades
apt install -y unattended-upgrades

# Enable automatic security updates
dpkg-reconfigure -f noninteractive unattended-upgrades

# Disable root SSH login
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# Disable password auth
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Fail2ban
apt install -y fail2ban
systemctl enable fail2ban

# System tweaks
sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv4.conf.all.rp_filter=1

systemctl restart sshd
