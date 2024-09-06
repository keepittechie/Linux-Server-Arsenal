#!/usr/bin/env bash

####################################
# Redis Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Redis on Debian,
# CentOS/RHEL, and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-redis.sh.
#   2. Make the script executable:
#      chmod +x auto-redis.sh
#   3. Run the script:
#      sudo ./auto-redis.sh
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

# Function to install Redis on Debian/Ubuntu
install_redis_debian() {
    sudo apt update
    sudo apt install -y redis-server
    sudo systemctl enable redis-server
    sudo systemctl start redis-server
}

# Function to install Redis on CentOS/RHEL
install_redis_centos() {
    sudo dnf install -y epel-release
    sudo dnf install -y redis
    sudo systemctl enable redis
    sudo systemctl start redis
}

# Function to install Redis on Arch Linux
install_redis_arch() {
    sudo pacman -Sy --noconfirm redis
    sudo systemctl enable redis
    sudo systemctl start redis
}

# Main script execution
echo "Redis Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install Redis based on the detected distribution
case "$DISTRO" in
    ubuntu|debian)
        install_redis_debian
        ;;
    centos|rhel|rocky|alma)
        install_redis_centos
        ;;
    arch)
        install_redis_arch
        ;;
    *)
        echo "Unsupported distribution!"
        exit 1
        ;;
esac

echo "Redis installed successfully."
