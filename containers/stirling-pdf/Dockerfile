FROM kasmweb/core-ubuntu-focal:1.16.1-rolling-daily

USER root

# Install Java, Chromium, and unzip
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    wget \
    gnupg \
    software-properties-common && \
    add-apt-repository ppa:canonical-chromium-builds/stage && \
    apt-get update && apt-get install -y chromium-browser && \
    rm -rf /var/lib/apt/lists/*


# Download and install Stirling PDF via .deb (with dependencies)
RUN wget -O /tmp/stirling.deb https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/stirling.deb \
 && dpkg -i /tmp/stirling.deb || true \
 && apt-get update \
 && apt-get install -f -y \
 && rm /tmp/stirling.deb

# Launcher script
RUN echo '#!/bin/bash\n\
/opt/stirling-pdf/StirlingPDF &\n\
sleep 5\n\
chromium --no-sandbox http://localhost:8080\n' > /usr/bin/start-stirling \
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
