#!/usr/bin/env bash

####################################
# LEMP Stack Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of the LEMP stack
# (Linux, Nginx, MySQL/MariaDB, PHP) on Debian, CentOS/RHEL,
# and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
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
            sudo systemctl enable nginx
            sudo systemctl start nginx
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y epel-release
            sudo dnf install -y nginx
            sudo systemctl enable nginx
            sudo systemctl start nginx
            ;;
        arch)
            sudo pacman -Sy --noconfirm nginx
            sudo systemctl enable nginx
            sudo systemctl start nginx
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
            sudo apt install -y php-fpm php-mysql
            sudo systemctl restart nginx
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y php php-fpm php-mysqlnd
            sudo systemctl restart nginx
            ;;
        arch)
            sudo pacman -Sy --noconfirm php php-fpm php-mariadb
            sudo systemctl restart nginx
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Main script execution
echo "LEMP Stack Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install the LEMP stack
install_nginx
install_mysql
install_php

echo "LEMP stack installed successfully."
