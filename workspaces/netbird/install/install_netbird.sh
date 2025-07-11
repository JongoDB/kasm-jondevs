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

# Create netbird user and group if they don't exist
groupadd -f netbird
usermod -a -G netbird kasm-user || true

# Set up permissions for TUN device
chmod 666 /dev/net/tun || true

# Create netbird config directory
mkdir -p /etc/netbird
chown -R kasm-user:netbird /etc/netbird

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Netbird installation completed successfully!"
