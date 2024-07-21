#!/usr/bin/env bash

####################################
# Node.js and NPM Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Node.js and NPM
# on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, install-nodejs.sh.
#   2. Make the script executable:
#      chmod +x install-nodejs.sh
#   3. Run the script:
#      sudo ./install-nodejs.sh
#
############################################################

# Function to install Node.js and NPM
install_nodejs() {
    apt update
    apt install -y nodejs npm
}

# Main script execution
echo "Node.js and NPM Installation for Ubuntu Server"
install_nodejs

echo "Node.js and NPM installed successfully."
