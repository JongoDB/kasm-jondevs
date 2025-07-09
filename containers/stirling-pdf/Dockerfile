FROM kasmweb/core-ubuntu-focal:1.14.0

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
  wget unzip openjdk-17-jre chromium-browser \
  && rm -rf /var/lib/apt/lists/*

# Install Stirling PDF
RUN mkdir -p /stirling-pdf \
  && wget -q https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/stirling-pdf.zip -O /stirling-pdf/stirling-pdf.zip \
  && unzip /stirling-pdf/stirling-pdf.zip -d /stirling-pdf \
  && chmod +x /stirling-pdf/StirlingPDF

# Launch script
RUN echo '#!/bin/bash\n/stirling-pdf/StirlingPDF &\nsleep 5\nchromium-browser --no-sandbox http://localhost:8080' > /usr/bin/start-stirling \
  && chmod +x /usr/bin/start-stirling

CMD ["start-stirling"]
