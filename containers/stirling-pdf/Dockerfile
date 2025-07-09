FROM kasmweb/chromium:1.17.0-rolling

USER root

# Install Stirling PDF
RUN mkdir -p /stirling-pdf \
 && apt update \
 && apt install -y wget unzip \
 && wget -q https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/stirling-pdf.zip -O /stirling-pdf/stirling-pdf.zip \
 && unzip /stirling-pdf/stirling-pdf.zip -d /stirling-pdf \
 && chmod +x /stirling-pdf/StirlingPDF

# Launch Chromium to Stirling PDF
RUN echo '#!/bin/bash\n/stirling-pdf/StirlingPDF &\nsleep 5\nchromium --no-sandbox --disable-dev-shm-usage http://localhost:8080' > /usr/bin/start-chromium-stirling \
 && chmod +x /usr/bin/start-chromium-stirling

CMD ["start-chromium-stirling"]
