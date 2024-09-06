#!/usr/bin/env bash

####################################
# OpenVPN Installation and Configuration Script
# Supports: Ubuntu/Debian, CentOS/RHEL, Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and configuration of
# OpenVPN on Debian, CentOS, and Arch-based servers.
#
# Author: KeepItTechie
# Version: 2.0
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

# Function to install OpenVPN and Easy-RSA based on distro
install_openvpn() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y openvpn easy-rsa
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y epel-release
            sudo dnf install -y openvpn easy-rsa
            ;;
        arch)
            sudo pacman -Sy --noconfirm openvpn easy-rsa
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Function to configure OpenVPN
configure_openvpn() {
    # Create the OpenVPN directory and set up Easy-RSA
    make-cadir ~/openvpn-ca
    cd ~/openvpn-ca
    source vars
    ./clean-all
    ./build-ca
    ./build-key-server server
    ./build-dh
    openvpn --genkey --secret keys/ta.key

    # Copy the necessary files to the OpenVPN directory
    cd keys
    sudo cp ca.crt ca.key server.crt server.key ta.key dh2048.pem /etc/openvpn

    # Enable OpenVPN service (systemd)
    sudo systemctl start openvpn@server
    sudo systemctl enable openvpn@server
}

# Main script execution
echo "OpenVPN Installation and Configuration for Ubuntu/Debian, CentOS/RHEL, and Arch"

# Detect the distro
detect_distro

# Install OpenVPN based on detected distro
install_openvpn

# Configure OpenVPN
configure_openvpn

echo "OpenVPN installed and configured successfully."
