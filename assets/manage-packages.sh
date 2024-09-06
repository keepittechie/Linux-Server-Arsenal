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
# Version: 1.1
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
    echo "Installing essential packages..."
    sudo apt update
    sudo apt install -y vim git curl wget build-essential || {
        echo "Package installation failed"; exit 1;
    }
    echo "Packages installed successfully."
}

# Function to upgrade all packages
upgrade_packages() {
    echo "Upgrading all packages..."
    sudo apt update
    sudo apt upgrade -y || {
        echo "Package upgrade failed"; exit 1;
    }
    echo "Packages upgraded successfully."
}

# Function to remove unnecessary packages
clean_packages() {
    echo "Cleaning unnecessary packages..."
    sudo apt autoremove -y || {
        echo "Package cleanup failed"; exit 1;
    }
    echo "Unused packages removed successfully."
}

# Main script execution
echo "Package Management for Ubuntu Server"

# Ask user which action to perform
echo "Choose an action:"
echo "1. Install essential packages"
echo "2. Upgrade all packages"
echo "3. Clean unnecessary packages"
echo "4. Perform all actions (install, upgrade, clean)"
read -p "Enter your choice (1-4): " ACTION

case $ACTION in
    1)
        install_packages
        ;;
    2)
        upgrade_packages
        ;;
    3)
        clean_packages
        ;;
    4)
        install_packages
        upgrade_packages
        clean_packages
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Package management tasks completed successfully."
