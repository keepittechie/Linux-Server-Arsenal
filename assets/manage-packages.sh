#!/usr/bin/env bash

####################################
# Package Management Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script helps in automating the installation and update
# of essential packages on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, manage-packages.sh.
#   2. Make the script executable:
#      chmod +x manage-packages.sh
#   3. Run the script:
#      sudo ./manage-packages.sh
#
############################################################

# Function to install essential packages
install_packages() {
    apt update
    apt install -y vim git curl wget build-essential
}

# Function to upgrade all packages
upgrade_packages() {
    apt update
    apt upgrade -y
}

# Function to remove unnecessary packages
clean_packages() {
    apt autoremove -y
}

# Main script execution
echo "Package Management for Ubuntu Server"
install_packages
upgrade_packages
clean_packages

echo "Package installation, upgrade, and cleanup completed successfully."
