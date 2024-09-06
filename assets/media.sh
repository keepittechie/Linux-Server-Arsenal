#!/usr/bin/env bash

####################################
# Auto-Media Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and basic configuration
# of Plex or Jellyfin on Debian, CentOS/RHEL, and Arch-based systems.
# The user is prompted to select which media server they would like to install.
#
# Author: KeepItTechie
# Version: 2.0
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

# Function to detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        echo "Unsupported distribution!"
        exit 1
    fi
}

# Function to install Plex
install_plex() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            wget https://downloads.plex.tv/plex-media-server-new/1.23.5.4862-cfa78858c/debian/plexmediaserver_1.23.5.4862-cfa78858c_amd64.deb
            sudo dpkg -i plexmediaserver_1.23.5.4862-cfa78858c_amd64.deb
            sudo systemctl enable plexmediaserver
            sudo systemctl start plexmediaserver
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y epel-release
            sudo dnf install -y plexmediaserver
            sudo systemctl enable plexmediaserver
            sudo systemctl start plexmediaserver
            ;;
        arch)
            sudo pacman -Sy --noconfirm plex-media-server
            sudo systemctl enable plexmediaserver
            sudo systemctl start plexmediaserver
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Function to install Jellyfin
install_jellyfin() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y apt-transport-https
            wget -O - https://repo.jellyfin.org/debian/jellyfin_team.gpg.key | sudo apt-key add -
            echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/debian buster main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
            sudo apt update
            sudo apt install -y jellyfin
            sudo systemctl enable jellyfin
            sudo systemctl start jellyfin
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y epel-release
            sudo dnf install -y jellyfin
            sudo systemctl enable jellyfin
            sudo systemctl start jellyfin
            ;;
        arch)
            sudo pacman -Sy --noconfirm jellyfin
            sudo systemctl enable jellyfin
            sudo systemctl start jellyfin
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Main script execution
echo "Plex or Jellyfin Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Prompt user to choose Plex or Jellyfin
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
