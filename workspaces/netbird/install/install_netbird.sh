#!/bin/bash
set -ex

# Update package list
apt-get update

# Install required dependencies
apt-get install -y \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    iptables \
    iproute2 \
    resolvconf \
    wireguard-tools

# Install Netbird
curl -fsSL https://pkgs.netbird.io/debian/public.key | gpg --dearmor -o /usr/share/keyrings/netbird-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/netbird-archive-keyring.gpg] https://pkgs.netbird.io/debian stable main" | tee /etc/apt/sources.list.d/netbird.list
apt-get update
apt-get install -y netbird netbird-ui

# Create netbird group
groupadd -f netbird

# Create netbird config directory (don't worry about ownership during build)
mkdir -p /etc/netbird

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Netbird installation completed successfully!"
