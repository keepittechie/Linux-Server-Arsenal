#!/usr/bin/env bash

####################################
# OpenVPN Installation and Configuration Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and configuration of
# OpenVPN on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-openvpn.sh.
#   2. Make the script executable:
#      chmod +x auto-openvpn.sh
#   3. Run the script:
#      sudo ./auto-openvpn.sh
#
############################################################

# Function to install OpenVPN
install_openvpn() {
    apt update
    apt install -y openvpn easy-rsa
}

# Function to configure OpenVPN
configure_openvpn() {
    make-cadir ~/openvpn-ca
    cd ~/openvpn-ca
    source vars
    ./clean-all
    ./build-ca
    ./build-key-server server
    ./build-dh
    openvpn --genkey --secret keys/ta.key
    cd keys
    cp ca.crt ca.key server.crt server.key ta.key dh2048.pem /etc/openvpn
}

# Main script execution
echo "OpenVPN Installation and Configuration for Ubuntu Server"
install_openvpn
configure_openvpn

echo "OpenVPN installed and configured successfully."
