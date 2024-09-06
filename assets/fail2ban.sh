#!/usr/bin/env bash

####################################
# Fail2ban Installation and Configuration Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and configuration of
# Fail2ban on Debian, CentOS/RHEL, and Arch-based systems,
# specifically for securing SSH.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-fail2ban.sh.
#   2. Make the script executable:
#      chmod +x auto-fail2ban.sh
#   3. Run the script:
#      sudo ./auto-fail2ban.sh
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

# Function to install Fail2ban
install_fail2ban() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y fail2ban
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y epel-release
            sudo dnf install -y fail2ban
            ;;
        arch)
            sudo pacman -Sy --noconfirm fail2ban
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Function to configure Fail2ban for SSH
configure_fail2ban() {
    echo "[sshd]" | sudo tee /etc/fail2ban/jail.local
    echo "enabled = true" | sudo tee -a /etc/fail2ban/jail.local
    echo "port = ssh" | sudo tee -a /etc/fail2ban/jail.local
    echo "filter = sshd" | sudo tee -a /etc/fail2ban/jail.local

    # Use appropriate log file depending on the distribution
    case "$DISTRO" in
        ubuntu|debian)
            echo "logpath = /var/log/auth.log" | sudo tee -a /etc/fail2ban/jail.local
            ;;
        centos|rhel|rocky|alma)
            echo "logpath = /var/log/secure" | sudo tee -a /etc/fail2ban/jail.local
            ;;
        arch)
            echo "logpath = /var/log/auth.log" | sudo tee -a /etc/fail2ban/jail.local
            ;;
    esac

    echo "maxretry = 5" | sudo tee -a /etc/fail2ban/jail.local

    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban
}

# Main script execution
echo "Fail2ban Installation and Configuration for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install Fail2ban
install_fail2ban

# Configure Fail2ban for SSH
configure_fail2ban

echo "Fail2ban installed and configured successfully."
