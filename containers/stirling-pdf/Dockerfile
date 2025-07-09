FROM kasmweb/core-ubuntu-focal:1.16.1-rolling-daily

USER root

# Install OpenJDK and Chromium (both required)
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    chromium-browser \
    unzip \
    wget \
 && rm -rf /var/lib/apt/lists/*

# Download and extract Stirling PDF separately for better error handling
RUN mkdir -p /opt/stirling-pdf \
 && wget https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/stirling-pdf.zip -O /opt/stirling-pdf/stirling-pdf.zip \
 && ls -lh /opt/stirling-pdf/ \
 && unzip /opt/stirling-pdf/stirling-pdf.zip -d /opt/stirling-pdf \
 && chmod +x /opt/stirling-pdf/StirlingPDF

# Configure Kasm default profile to launch Chromium to Stirling PDF
RUN echo '#!/bin/bash\n\
/opt/stirling-pdf/StirlingPDF &\n\
sleep 5\n\
chromium-browser --no-sandbox http://localhost:8080\n' > /usr/bin/start-stirling

RUN chmod +x /usr/bin/start-stirling

# Configure the profile to run our script
RUN echo '{ \
  "name": "Stirling PDF", \
  "description": "All-in-one PDF toolkit in a browser", \
  "command": "start-stirling", \
  "icon": "fa fa-file-pdf-o" \
}' > /usr/share/kasm_default_profile/profile.json

CMD ["/dockerstartup/kasm_default_profile.sh"]
