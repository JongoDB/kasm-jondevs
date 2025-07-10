FROM kasmweb/core-ubuntu-focal:1.16.1-rolling-daily
USER root

# Install Java, Google Chrome, and dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    wget \
    gnupg \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Download and install Stirling PDF via .deb (with dependencies)
RUN wget -O /tmp/stirling.deb https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/stirling.deb \
 && dpkg -i /tmp/stirling.deb || true \
 && apt-get update \
 && apt-get install -f -y \
 && rm /tmp/stirling.deb

# Find and create symlink for Stirling PDF executable
RUN echo "Finding Stirling PDF installation..." \
 && find / -name "*Stirling*" -type f 2>/dev/null | head -10 \
 && dpkg -L stirling-pdf | grep -E "(jar|Stirling)" | head -10 \
 && STIRLING_JAR=$(find /usr -name "*.jar" -path "*/stirling*" 2>/dev/null | head -1) \
 && if [ -n "$STIRLING_JAR" ]; then \
      echo "Found Stirling PDF JAR: $STIRLING_JAR" \
      && ln -sf "$STIRLING_JAR" /usr/local/bin/stirling-pdf.jar; \
    else \
      echo "Stirling PDF JAR not found after installation"; \
    fi

# Launcher script with proper error handling
RUN echo '#!/bin/bash\n\
echo "Starting Stirling PDF..."\n\
# Try different ways to start Stirling PDF\n\
if [ -f /opt/stirling-pdf/StirlingPDF ]; then\n\
    echo "Found StirlingPDF at /opt/stirling-pdf/StirlingPDF"\n\
    /opt/stirling-pdf/StirlingPDF &\n\
elif [ -f /usr/local/bin/stirling-pdf.jar ]; then\n\
    echo "Found Stirling PDF JAR, starting with java..."\n\
    java -jar /usr/local/bin/stirling-pdf.jar &\n\
elif [ -f /usr/share/java/stirling-pdf*.jar ]; then\n\
    echo "Found Stirling PDF in /usr/share/java/"\n\
    java -jar /usr/share/java/stirling-pdf*.jar &\n\
else\n\
    echo "Searching for Stirling PDF..."\n\
    STIRLING_JAR=$(find /usr -name "*.jar" -path "*stirling*" 2>/dev/null | head -1)\n\
    if [ -n "$STIRLING_JAR" ]; then\n\
        echo "Found JAR: $STIRLING_JAR"\n\
        java -jar "$STIRLING_JAR" &\n\
    else\n\
        echo "ERROR: Stirling PDF not found anywhere!"\n\
        exit 1\n\
    fi\n\
fi\n\
echo "Waiting for Stirling PDF to start..."\n\
sleep 10\n\
echo "Starting Google Chrome..."\n\
google-chrome --no-sandbox --disable-dev-shm-usage --disable-extensions --disable-plugins --disable-background-timer-throttling --disable-backgrounding-occluded-windows --disable-renderer-backgrounding http://localhost:8080\n' > /usr/bin/start-stirling \
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
