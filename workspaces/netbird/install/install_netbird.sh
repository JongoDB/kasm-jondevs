#!/bin/bash
set -ex

# Update package list
apt-get update

# Install required dependencies (remove problematic packages)
apt-get install -y \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    iptables \
    iproute2 \
    wireguard-tools

# Skip resolvconf during build - it will be handled at runtime
# resolvconf \

# Install Netbird
curl -fsSL https://pkgs.netbird.io/debian/public.key | gpg --dearmor -o /usr/share/keyrings/netbird-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/netbird-archive-keyring.gpg] https://pkgs.netbird.io/debian stable main" | tee /etc/apt/sources.list.d/netbird.list

# Update package list again
apt-get update

# Install netbird with --no-install-recommends to avoid problematic dependencies
apt-get install -y --no-install-recommends netbird netbird-ui

# Create netbird group
groupadd -f netbird

# Create netbird config directory
mkdir -p /etc/netbird

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Netbird installation completed successfully!"
