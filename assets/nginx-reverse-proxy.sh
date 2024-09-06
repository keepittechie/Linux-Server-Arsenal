#!/usr/bin/env bash

####################################
# Nginx Reverse Proxy Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Nginx and configuration
# as a reverse proxy on Debian, CentOS/RHEL, and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-nginx-reverse-proxy.sh.
#   2. Make the script executable:
#      chmod +x auto-nginx-reverse-proxy.sh
#   3. Run the script:
#      sudo ./auto-nginx-reverse-proxy.sh
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

# Function to install Nginx
install_nginx() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y nginx
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y epel-release
            sudo dnf install -y nginx
            ;;
        arch)
            sudo pacman -Sy --noconfirm nginx
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Function to configure Nginx as a reverse proxy
configure_nginx() {
    read -p "Enter the domain name (e.g., example.com): " DOMAIN
    read -p "Enter the IP address of the server to proxy to (e.g., 192.168.1.100): " PROXY_IP

    # Create Nginx configuration for the domain
    echo "server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://$PROXY_IP;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}" | sudo tee /etc/nginx/sites-available/$DOMAIN

    # Enable the site (Debian/Ubuntu)
    if [[ "$DISTRO" == "ubuntu" || "$DISTRO" == "debian" ]]; then
        sudo ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
    else
        # For CentOS/RHEL/Arch, directly create the config in /etc/nginx/conf.d/
        sudo mv /etc/nginx/sites-available/$DOMAIN /etc/nginx/conf.d/$DOMAIN.conf
    fi

    # Test and reload Nginx configuration
    sudo nginx -t
    sudo systemctl restart nginx
}

# Main script execution
echo "Nginx Reverse Proxy Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install Nginx based on the detected distribution
install_nginx

# Configure Nginx as a reverse proxy
configure_nginx

echo "Nginx installed and configured as a reverse proxy successfully."
