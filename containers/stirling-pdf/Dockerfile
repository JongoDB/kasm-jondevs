FROM kasmweb/core-ubuntu-focal:1.16.1-rolling-daily
USER root

# Install Java, Google Chrome, and dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    wget \
    gnupg \
    curl \
    unzip \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Download and install Stirling PDF directly as JAR (more reliable than .deb)
RUN mkdir -p /opt/stirling-pdf \
    && wget -O /opt/stirling-pdf/Stirling-PDF.jar https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/Stirling-PDF.jar \
    && chmod +x /opt/stirling-pdf/Stirling-PDF.jar

# Create a simple startup script for Stirling PDF
RUN echo '#!/bin/bash\ncd /opt/stirling-pdf\njava -jar Stirling-PDF.jar' > /opt/stirling-pdf/start.sh \
    && chmod +x /opt/stirling-pdf/start.sh

# Create Chrome wrapper script with proper flags for container environment
RUN echo '#!/bin/bash\n\
google-chrome \\\n\
  --no-sandbox \\\n\
  --disable-dev-shm-usage \\\n\
  --disable-extensions \\\n\
  --disable-plugins \\\n\
  --disable-background-timer-throttling \\\n\
  --disable-backgrounding-occluded-windows \\\n\
  --disable-renderer-backgrounding \\\n\
  --disable-features=TranslateUI \\\n\
  --disable-default-apps \\\n\
  --disable-sync \\\n\
  --disable-gpu \\\n\
  --no-first-run \\\n\
  --no-default-browser-check \\\n\
  --disable-web-security \\\n\
  --user-data-dir=/tmp/chrome-user-data \\\n\
  "$@"' > /usr/local/bin/chrome-wrapper \
  && chmod +x /usr/local/bin/chrome-wrapper

# Main launcher script
RUN echo '#!/bin/bash\n\
echo "Starting Stirling PDF..."\n\
cd /opt/stirling-pdf\n\
java -jar Stirling-PDF.jar &\n\
STIRLING_PID=$!\n\
echo "Stirling PDF started with PID: $STIRLING_PID"\n\
\n\
# Wait for Stirling PDF to be ready\n\
echo "Waiting for Stirling PDF to start..."\n\
for i in {1..30}; do\n\
    if curl -s http://localhost:8080 > /dev/null 2>&1; then\n\
        echo "Stirling PDF is ready!"\n\
        break\n\
    fi\n\
    echo "Waiting... ($i/30)"\n\
    sleep 2\n\
done\n\
\n\
echo "Starting Google Chrome..."\n\
mkdir -p /tmp/chrome-user-data\n\
chrome-wrapper http://localhost:8080\n' > /usr/bin/start-stirling \
 && chmod +x /usr/bin/start-stirling

# Create Kasm default profile
RUN mkdir -p /usr/share/kasm_default_profile && \
    cat << 'EOF' > /usr/share/kasm_default_profile/profile.json
{
  "name": "Stirling PDF",
  "description": "All-in-one PDF toolkit in a browser",
  "command": "start-stirling",
  "icon": "fa fa-file-pdf-o"
}
EOF

CMD ["/dockerstartup/kasm_default_profile.sh"]
