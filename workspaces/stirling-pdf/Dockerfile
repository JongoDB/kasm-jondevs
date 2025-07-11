ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-jammy"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

USER root
ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########
# Copy Stirling PDF installation scripts
COPY ./workspaces/stirling-pdf/install/ $INST_SCRIPTS/stirling-pdf/
RUN bash $INST_SCRIPTS/stirling-pdf/install_stirling.sh && rm -rf $INST_SCRIPTS/stirling-pdf/

# Expose port 8080 for Stirling PDF
EXPOSE 8080

# Create desktop shortcut
RUN echo "[Desktop Entry]" > $HOME/Desktop/stirling-pdf.desktop && \
    echo "Version=1.0" >> $HOME/Desktop/stirling-pdf.desktop && \
    echo "Type=Application" >> $HOME/Desktop/stirling-pdf.desktop && \
    echo "Name=Stirling PDF" >> $HOME/Desktop/stirling-pdf.desktop && \
    echo "Comment=All-in-one PDF toolkit" >> $HOME/Desktop/stirling-pdf.desktop && \
    echo "Exec=/usr/local/bin/start-stirling-pdf" >> $HOME/Desktop/stirling-pdf.desktop && \
    echo "Icon=application-pdf" >> $HOME/Desktop/stirling-pdf.desktop && \
    echo "Terminal=false" >> $HOME/Desktop/stirling-pdf.desktop && \
    echo "Categories=Office;Graphics;" >> $HOME/Desktop/stirling-pdf.desktop && \
    chmod +x $HOME/Desktop/stirling-pdf.desktop && \
    chown 1000:1000 $HOME/Desktop/stirling-pdf.desktop

# Setup custom startup script
RUN echo '#!/bin/bash' > $STARTUPDIR/custom_startup.sh && \
    echo '/usr/bin/desktop_ready' >> $STARTUPDIR/custom_startup.sh && \
    echo '/usr/local/bin/start-stirling-pdf &' >> $STARTUPDIR/custom_startup.sh && \
    chmod +x $STARTUPDIR/custom_startup.sh
######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME
ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME
USER 1000
