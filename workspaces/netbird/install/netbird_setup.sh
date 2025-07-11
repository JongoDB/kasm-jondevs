#!/bin/bash

# Netbird setup script that runs at container startup
# This script uses environment variables passed from Kasm workspace configuration

echo "Starting Netbird setup..."

# Default values
NETBIRD_SERVER_URL=${NETBIRD_SERVER_URL:-"https://api.netbird.io"}
NETBIRD_SETUP_KEY=${NETBIRD_SETUP_KEY:-""}
NETBIRD_AUTH_METHOD=${NETBIRD_AUTH_METHOD:-"device_auth"}
NETBIRD_AUTO_CONNECT=${NETBIRD_AUTO_CONNECT:-"false"}

# Create netbird config
mkdir -p ~/.netbird

# Configure server URL if provided
if [ -n "$NETBIRD_SERVER_URL" ] && [ "$NETBIRD_SERVER_URL" != "https://api.netbird.io" ]; then
    echo "Configuring custom Netbird server: $NETBIRD_SERVER_URL"
    netbird service install --config ~/.netbird/config.json
    # Configure custom server URL in config
    cat > ~/.netbird/config.json << EOF
{
  "ServerURL": "$NETBIRD_SERVER_URL",
  "PreSharedKey": "",
  "PrivateKey": "",
  "WgListenPort": 51820
}
EOF
fi

# Auto-connect if setup key is provided
if [ -n "$NETBIRD_SETUP_KEY" ] && [ "$NETBIRD_AUTO_CONNECT" = "true" ]; then
    echo "Auto-connecting with setup key..."
    netbird up --setup-key "$NETBIRD_SETUP_KEY" --daemon-addr "unix:///var/run/netbird/sock" &
elif [ "$NETBIRD_AUTO_CONNECT" = "true" ]; then
    echo "Auto-connecting with device authentication..."
    netbird up --daemon-addr "unix:///var/run/netbird/sock" &
fi

# Show connection status
sleep 2
netbird status 2>/dev/null || echo "Netbird not connected yet. Use desktop shortcuts to manage connection."

echo "Netbird setup completed!"
