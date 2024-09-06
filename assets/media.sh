#!/usr/bin/env bash

####################################
# Auto-Media Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and basic configuration
# of Plex or Jellyfin on Ubuntu servers. The user is prompted to
# select which media server they would like to install.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-media.sh.
#   2. Make the script executable:
#      chmod +x auto-media.sh
#   3. Run the script:
#      sudo ./auto-media.sh
#
############################################################

# Function to install Plex
install_plex() {
    apt update
    wget https://downloads.plex.tv/plex-media-server-new/1.23.5.4862-cfa78858c/debian/plexmediaserver_1.23.5.4862-cfa78858c_amd64.deb
    dpkg -i plexmediaserver_1.23.5.4862-cfa78858c_amd64.deb
    systemctl enable plexmediaserver
    systemctl start plexmediaserver
}

# Function to install Jellyfin
install_jellyfin() {
    apt update
    apt install -y apt-transport-https
    wget -O - https://repo.jellyfin.org/debian/jellyfin_team.gpg.key | apt-key add -
    echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/debian buster main" | tee /etc/apt/sources.list.d/jellyfin.list
    apt update
    apt install -y jellyfin
    systemctl enable jellyfin
    systemctl start jellyfin
}

# Main script execution
echo "Plex or Jellyfin Installation for Ubuntu Server"

read -p "Do you want to install Plex (1) or Jellyfin (2)? Enter 1 or 2: " MEDIA_CHOICE

case $MEDIA_CHOICE in
    1)
        echo "Installing Plex..."
        install_plex
        echo "Plex installed successfully."
        ;;
    2)
        echo "Installing Jellyfin..."
        install_jellyfin
        echo "Jellyfin installed successfully."
        ;;
    *)
        echo "Invalid choice. Please run the script again and select either 1 or 2."
        exit 1
        ;;
esac

echo "Installation script completed."
