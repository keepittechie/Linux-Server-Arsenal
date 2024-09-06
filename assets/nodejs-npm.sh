#!/usr/bin/env bash

####################################
# Node.js and NPM Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Node.js and NPM
# on Debian, CentOS/RHEL, and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-nodejs.sh.
#   2. Make the script executable:
#      chmod +x auto-nodejs.sh
#   3. Run the script:
#      sudo ./auto-nodejs.sh
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

# Function to install Node.js and NPM
install_nodejs() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y curl
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
            sudo apt install -y nodejs
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y curl
            curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
            sudo dnf install -y nodejs
            ;;
        arch)
            sudo pacman -Sy --noconfirm nodejs npm
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Main script execution
echo "Node.js and NPM Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install Node.js and NPM
install_nodejs

echo "Node.js and NPM installed successfully."
