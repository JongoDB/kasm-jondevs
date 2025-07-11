#!/bin/bash
set -ex

# Update package list
apt-get update

# Install Java 17, Chrome, and dependencies
apt-get install -y \
    openjdk-17-jre \
    wget \
    gnupg \
    curl \
    unzip \
    ca-certificates

# Install Google Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install -y google-chrome-stable

# Create Stirling PDF directory structure
mkdir -p /opt/stirling-pdf/{configs,logs,customFiles}

# Download latest Stirling PDF
STIRLING_VERSION=$(curl -s https://api.github.com/repos/Stirling-Tools/Stirling-PDF/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
wget -O /opt/stirling-pdf/Stirling-PDF.jar "https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/Stirling-PDF.jar"

# Set permissions
chown -R kasm-user:kasm-user /opt/stirling-pdf
chmod +x /opt/stirling-pdf/Stirling-PDF.jar

# Install Chrome wrapper
cp $INST_SCRIPTS/stirling-pdf/chrome_wrapper.sh /usr/local/bin/chrome-wrapper
chmod +x /usr/local/bin/chrome-wrapper

# Create main startup script
cat > /usr/local/bin/start-stirling-pdf << 'EOF'
#!/bin/bash
set -e

echo "Starting Stirling PDF..."
cd /opt/stirling-pdf

# Ensure directories exist
mkdir -p /opt/stirling-pdf/{logs,configs,customFiles}

# Start Stirling PDF in background
echo "Launching Stirling PDF..."
java -jar Stirling-PDF.jar > /tmp/stirling.log 2>&1 &
STIRLING_PID=$!

echo "Stirling PDF started with PID: $STIRLING_PID"

# Wait for service to be ready
echo "Waiting for Stirling PDF to start..."
for i in {1..30}; do
    if curl -s http://localhost:8080 > /dev/null 2>&1; then
        echo "✓ Stirling PDF is ready!"
        break
    fi
    
    if [ $i -eq 15 ]; then
        echo "Debug: Stirling PDF log output:"
        tail -10 /tmp/stirling.log
    fi
    
    if ! kill -0 $STIRLING_PID 2>/dev/null; then
        echo "ERROR: Stirling PDF process died!"
        cat /tmp/stirling.log
        exit 1
    fi
    
    echo "Waiting... ($i/30)"
    sleep 2
done

# Check if service is actually ready
if ! curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "ERROR: Stirling PDF failed to start properly"
    tail -20 /tmp/stirling.log
    exit 1
fi

echo "🚀 Opening Stirling PDF in browser..."
/usr/local/bin/chrome-wrapper http://localhost:8080
EOF

chmod +x /usr/local/bin/start-stirling-pdf

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Stirling PDF installation completed successfully!"
