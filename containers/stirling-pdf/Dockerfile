FROM kasmweb/core-ubuntu-focal:1.16.1-rolling-daily

USER root

# Install Java, Chromium, and unzip
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    chromium-browser \
    wget \
 && rm -rf /var/lib/apt/lists/*

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
chromium-browser --no-sandbox http://localhost:8080\n' > /usr/bin/start-stirling \
 && chmod +x /usr/bin/start-stirling

# Register with Kasm default profile
RUN printf '%s\n' \
  '{' \
  '  "name": "Stirling PDF",' \
  '  "description": "All-in-one PDF toolkit in a browser",' \
  '  "command": "start-stirling",' \
  '  "icon": "fa fa-file-pdf-o"' \
  '}' \
  > /usr/share/kasm_default_profile/profile.json

CMD ["/dockerstartup/kasm_default_profile.sh"]
