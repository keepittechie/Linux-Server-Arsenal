#!/usr/bin/env bash

####################################
# Nginx Reverse Proxy Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Nginx and configuration
# as a reverse proxy on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
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

# Function to install Nginx
install_nginx() {
    apt update
    apt install -y nginx
}

# Function to configure Nginx as a reverse proxy
configure_nginx() {
    read -p "Enter the domain name (e.g., example.com): " DOMAIN
    read -p "Enter the IP address of the server to proxy to (e.g., 192.168.1.100): " PROXY_IP

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
}" > /etc/nginx/sites-available/$DOMAIN

    ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
    nginx -t
    systemctl restart nginx
}

# Main script execution
echo "Nginx Reverse Proxy Installation for Ubuntu Server"
install_nginx
configure_nginx

echo "Nginx installed and configured as a reverse proxy successfully."
