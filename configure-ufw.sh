#!/usr/bin/env bash

####################################
# Firewall Setup Script for Ubuntu Server using UFW
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script helps in configuring the Uncomplicated Firewall
# (UFW) on Ubuntu servers with predefined rules.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, setup-firewall.sh.
#   2. Make the script executable:
#      chmod +x setup-firewall.sh
#   3. Run the script:
#      sudo ./setup-firewall.sh
#
# The script will prompt for:
#   - Allowed ports (e.g., 22, 80, 443)
#   - Default incoming policy (allow/deny/reject)
#   - Default outgoing policy (allow/deny/reject)
#
# The script will then configure UFW with the provided rules.
#
############################################################

# Function to gather input from the user
gather_input() {
    read -p "Enter allowed ports (comma-separated, e.g., 22,80,443): " ALLOWED_PORTS
    read -p "Enter default incoming policy (allow/deny/reject): " DEFAULT_IN_POLICY
    read -p "Enter default outgoing policy (allow/deny/reject): " DEFAULT_OUT_POLICY
}

# Function to configure UFW
configure_ufw() {
    ufw default $DEFAULT_IN_POLICY incoming
    ufw default $DEFAULT_OUT_POLICY outgoing

    IFS=',' read -ra PORTS <<< "$ALLOWED_PORTS"
    for PORT in "${PORTS[@]}"; do
        ufw allow $PORT
    done

    ufw enable
}

# Main script execution
echo "Firewall Setup for Ubuntu Server using UFW"
gather_input
configure_ufw

echo "UFW configuration applied successfully."
