#!/usr/bin/env bash

####################################
# LEMP Stack Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of the LEMP stack
# (Linux, Nginx, MySQL/MariaDB, PHP) on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-lemp.sh.
#   2. Make the script executable:
#      chmod +x auto-lemp.sh
#   3. Run the script:
#      sudo ./auto-lemp.sh
#
############################################################

# Function to install Nginx
install_nginx() {
    apt update
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
}

# Function to install MySQL/MariaDB
install_mysql() {
    apt install -y mysql-server
    systemctl enable mysql
    systemctl start mysql
}

# Function to install PHP
install_php() {
    apt install -y php-fpm php-mysql
    systemctl restart nginx
}

# Main script execution
echo "LEMP Stack Installation for Ubuntu Server"
install_nginx
install_mysql
install_php

echo "LEMP stack installed successfully."
