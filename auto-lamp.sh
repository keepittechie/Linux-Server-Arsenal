#!/usr/bin/env bash

####################################
# LAMP Stack Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of the LAMP stack
# (Linux, Apache, MySQL/MariaDB, PHP) on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, install-lamp.sh.
#   2. Make the script executable:
#      chmod +x install-lamp.sh
#   3. Run the script:
#      sudo ./install-lamp.sh
#
############################################################

# Function to install Apache
install_apache() {
    apt update
    apt install -y apache2
    systemctl enable apache2
    systemctl start apache2
}

# Function to install MySQL/MariaDB
install_mysql() {
    apt install -y mysql-server
    systemctl enable mysql
    systemctl start mysql
}

# Function to install PHP
install_php() {
    apt install -y php libapache2-mod-php php-mysql
    systemctl restart apache2
}

# Main script execution
echo "LAMP Stack Installation for Ubuntu Server"
install_apache
install_mysql
install_php

echo "LAMP stack installed successfully."
