FROM kasmweb/ubuntu-chromium:1.17.0-rolling-weekly

USER root

# Install dependencies and Stirling PDF
RUN apt update \
 && apt install -y wget unzip \
 && mkdir -p /stirling-pdf \
 && wget -q https://github.com/Stirling-Tools/Stirling-PDF/releases/latest/download/stirling-pdf.zip -O /stirling-pdf/stirling-pdf.zip \
 && unzip /stirling-pdf/stirling-pdf.zip -d /stirling-pdf \
 && chmod +x /stirling-pdf/StirlingPDF

# Entry script to launch Stirling PDF and Chromium pointing to it
RUN echo '#!/bin/bash\n/stirling-pdf/StirlingPDF &\nsleep 5\nchromium --no-sandbox --disable-dev-shm-usage http://localhost:8080' > /usr/bin/start-chromium-stirling \
 && chmod +x /usr/bin/start-chromium-stirling

CMD ["start-chromium-stirling"]
