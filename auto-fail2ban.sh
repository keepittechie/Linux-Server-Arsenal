#!/usr/bin/env bash

####################################
# Fail2ban Installation and Configuration Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and configuration of
# Fail2ban on Ubuntu servers, specifically for securing SSH.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, install-fail2ban.sh.
#   2. Make the script executable:
#      chmod +x install-fail2ban.sh
#   3. Run the script:
#      sudo ./install-fail2ban.sh
#
############################################################

# Function to install Fail2ban
install_fail2ban() {
    apt update
    apt install -y fail2ban
}

# Function to configure Fail2ban for SSH
configure_fail2ban() {
    echo "[sshd]" > /etc/fail2ban/jail.local
    echo "enabled = true" >> /etc/fail2ban/jail.local
    echo "port = ssh" >> /etc/fail2ban/jail.local
    echo "filter = sshd" >> /etc/fail2ban/jail.local
    echo "logpath = /var/log/auth.log" >> /etc/fail2ban/jail.local
    echo "maxretry = 5" >> /etc/fail2ban/jail.local

    systemctl enable fail2ban
    systemctl start fail2ban
}

# Main script execution
echo "Fail2ban Installation and Configuration for Ubuntu Server"
install_fail2ban
configure_fail2ban

echo "Fail2ban installed and configured successfully."
