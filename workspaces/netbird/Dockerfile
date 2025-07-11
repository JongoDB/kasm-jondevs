ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-jammy"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

USER root
ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR=/dockerstartup
ENV INST_SCRIPTS=$STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########
# Copy all install files at once
COPY ./workspaces/netbird/install/ $INST_SCRIPTS/netbird/

# Set permissions and move setup script
RUN chmod +x $INST_SCRIPTS/netbird/*.sh && \
    cp $INST_SCRIPTS/netbird/netbird_setup.sh $STARTUPDIR/netbird_setup.sh && \
    chmod +x $STARTUPDIR/netbird_setup.sh

# Run installation and cleanup
RUN bash $INST_SCRIPTS/netbird/install_netbird.sh && rm -rf $INST_SCRIPTS/netbird/

# Create desktop shortcut for Netbird management
RUN echo "[Desktop Entry]" > $HOME/Desktop/netbird.desktop && \
    echo "Version=1.0" >> $HOME/Desktop/netbird.desktop && \
    echo "Type=Application" >> $HOME/Desktop/netbird.desktop && \
    echo "Name=Netbird VPN" >> $HOME/Desktop/netbird.desktop && \
    echo "Comment=Netbird VPN Client" >> $HOME/Desktop/netbird.desktop && \
    echo "Exec=/usr/local/bin/netbird-gui" >> $HOME/Desktop/netbird.desktop && \
    echo "Icon=network-vpn" >> $HOME/Desktop/netbird.desktop && \
    echo "Terminal=false" >> $HOME/Desktop/netbird.desktop && \
    echo "Categories=Network;Security;" >> $HOME/Desktop/netbird.desktop && \
    chmod +x $HOME/Desktop/netbird.desktop && \
    chown 1000:1000 $HOME/Desktop/netbird.desktop

# Add terminal shortcut for Netbird CLI
RUN echo "[Desktop Entry]" > $HOME/Desktop/netbird-terminal.desktop && \
    echo "Version=1.0" >> $HOME/Desktop/netbird-terminal.desktop && \
    echo "Type=Application" >> $HOME/Desktop/netbird-terminal.desktop && \
    echo "Name=Netbird Terminal" >> $HOME/Desktop/netbird-terminal.desktop && \
    echo "Comment=Netbird CLI Terminal" >> $HOME/Desktop/netbird-terminal.desktop && \
    echo "Exec=xfce4-terminal -e 'bash -c \"echo Welcome to Netbird VPN!; echo; netbird status; echo; echo Commands:; echo  - netbird login; echo  - netbird status; echo  - netbird down; echo  - netbird up; echo; bash\"'" >> $HOME/Desktop/netbird-terminal.desktop && \
    echo "Icon=utilities-terminal" >> $HOME/Desktop/netbird-terminal.desktop && \
    echo "Terminal=false" >> $HOME/Desktop/netbird-terminal.desktop && \
    echo "Categories=Network;System;" >> $HOME/Desktop/netbird-terminal.desktop && \
    chmod +x $HOME/Desktop/netbird-terminal.desktop && \
    chown 1000:1000 $HOME/Desktop/netbird-terminal.desktop

# Create custom startup script that runs after desktop is ready
RUN echo '#!/bin/bash' > $STARTUPDIR/custom_startup.sh && \
    echo '/usr/bin/desktop_ready' >> $STARTUPDIR/custom_startup.sh && \
    echo '$STARTUPDIR/netbird_setup.sh &' >> $STARTUPDIR/custom_startup.sh && \
    chmod +x $STARTUPDIR/custom_startup.sh
######### End Customizations ##########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME
ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME
RUN usermod -a -G netbird kasm-user && chown -R kasm-user:netbird /etc/netbird
USER 1000
