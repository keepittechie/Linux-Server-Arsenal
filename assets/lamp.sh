#!/usr/bin/env bash

####################################
# LAMP Stack Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of the LAMP stack
# (Linux, Apache, MySQL/MariaDB, PHP) on Debian, CentOS/RHEL,
# and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-lamp.sh.
#   2. Make the script executable:
#      chmod +x auto-lamp.sh
#   3. Run the script:
#      sudo ./auto-lamp.sh
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

# Function to install Apache
install_apache() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y apache2
            sudo systemctl enable apache2
            sudo systemctl start apache2
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y httpd
            sudo systemctl enable httpd
            sudo systemctl start httpd
            ;;
        arch)
            sudo pacman -Sy --noconfirm apache
            sudo systemctl enable httpd
            sudo systemctl start httpd
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Function to install MySQL/MariaDB
install_mysql() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt install -y mysql-server
            sudo systemctl enable mysql
            sudo systemctl start mysql
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y mariadb-server
            sudo systemctl enable mariadb
            sudo systemctl start mariadb
            ;;
        arch)
            sudo pacman -Sy --noconfirm mariadb
            sudo systemctl enable mariadb
            sudo systemctl start mariadb
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Function to install PHP
install_php() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt install -y php libapache2-mod-php php-mysql
            sudo systemctl restart apache2
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y php php-mysqlnd
            sudo systemctl restart httpd
            ;;
        arch)
            sudo pacman -Sy --noconfirm php php-apache mariadb-connector-c
            sudo systemctl restart httpd
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Main script execution
echo "LAMP Stack Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install the LAMP stack
install_apache
install_mysql
install_php

echo "LAMP stack installed successfully."
