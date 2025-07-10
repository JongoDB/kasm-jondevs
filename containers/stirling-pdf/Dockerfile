FROM ghcr.io/kasmtech/core-ubuntu-noble:1.17.0-rolling-daily
USER root

# Install Java, Google Chrome, and dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    wget \
    gnupg \
    curl \
    unzip \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Expose port 8080 for Stirling PDF
EXPOSE 8080

# Download and install Stirling PDF directly as JAR (more reliable than .deb)
RUN mkdir -p /opt/stirling-pdf \
    && wget -O /opt/stirling-pdf/Stirling-PDF.jar https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/Stirling-PDF.jar \
    && chmod +x /opt/stirling-pdf/Stirling-PDF.jar \
    && mkdir -p /opt/stirling-pdf/configs /opt/stirling-pdf/logs /opt/stirling-pdf/customFiles \
    && chown -R kasm-user:kasm-user /opt/stirling-pdf

# Create a simple startup script for Stirling PDF
RUN echo '#!/bin/bash\ncd /opt/stirling-pdf\njava -jar Stirling-PDF.jar' > /opt/stirling-pdf/start.sh \
    && chmod +x /opt/stirling-pdf/start.sh

# Create Chrome wrapper script with minimal, essential flags
RUN echo '#!/bin/bash\n\
mkdir -p /tmp/chrome-user-data\n\
google-chrome \\\n\
  --no-sandbox \\\n\
  --disable-dev-shm-usage \\\n\
  --disable-gpu \\\n\
  --no-first-run \\\n\
  --user-data-dir=/tmp/chrome-user-data \\\n\
  "$@"' > /usr/local/bin/chrome-wrapper \
  && chmod +x /usr/local/bin/chrome-wrapper

# Main launcher script
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Starting Stirling PDF..."\n\
cd /opt/stirling-pdf\n\
\n\
# Ensure directories exist with proper permissions\n\
mkdir -p /opt/stirling-pdf/logs /opt/stirling-pdf/configs /opt/stirling-pdf/customFiles\n\
\n\
# Start Stirling PDF in background\n\
echo "Running: java -jar Stirling-PDF.jar"\n\
java -jar Stirling-PDF.jar > /tmp/stirling.log 2>&1 &\n\
STIRLING_PID=$!\n\
echo "Stirling PDF started with PID: $STIRLING_PID"\n\
\n\
# Wait for Stirling PDF to be ready\n\
echo "Waiting for Stirling PDF to start..."\n\
for i in {1..10}; do\n\
    if curl -s http://localhost:8080 > /dev/null 2>&1; then\n\
        echo "Stirling PDF is ready!"\n\
        break\n\
    fi\n\
    echo "Waiting... ($i/10)"\n\
    if [ $i -eq 5 ]; then\n\
        echo "Stirling PDF log output:"\n\
        tail -20 /tmp/stirling.log\n\
        echo "Checking if process is still running..."\n\
        if ! kill -0 $STIRLING_PID 2>/dev/null; then\n\
            echo "ERROR: Stirling PDF process has died!"\n\
            exit 1\n\
        fi\n\
    fi\n\
    sleep 2\n\
done\n\
\n\
echo "Starting Google Chrome..."\n\
exec chrome-wrapper http://localhost:8080\n' > /usr/bin/start-stirling \
 && chmod +x /usr/bin/start-stirling

# Create Kasm default profile and ensure it auto-starts
RUN mkdir -p /usr/share/kasm_default_profile && \
    cat << 'EOF' > /usr/share/kasm_default_profile/profile.json
{
  "name": "Stirling PDF",
  "description": "All-in-one PDF toolkit in a browser",
  "command": "/usr/bin/start-stirling",
  "icon": "fa fa-file-pdf-o"
}
EOF

# Create the autostart directory and script
RUN mkdir -p /etc/xdg/autostart && \
    cat << 'EOF' > /etc/xdg/autostart/stirling-pdf.desktop
[Desktop Entry]
Type=Application
Name=Stirling PDF
Exec=/usr/bin/start-stirling
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

# Switch to kasm-user for runtime
USER kasm-user

CMD ["/dockerstartup/kasm_default_profile.sh"]
