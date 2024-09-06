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
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, config-ufw.sh.
#   2. Make the script executable:
#      chmod +x config-ufw.sh
#   3. Run the script:
#      sudo ./config-ufw.sh
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

    # Confirm input
    echo "You have entered the following details:"
    echo "Allowed Ports: $ALLOWED_PORTS"
    echo "Default Incoming Policy: $DEFAULT_IN_POLICY"
    echo "Default Outgoing Policy: $DEFAULT_OUT_POLICY"
    read -p "Is this information correct? (y/n): " CONFIRM

    if [[ "$CONFIRM" != "y" ]]; then
        echo "Exiting without applying firewall rules."
        exit 1
    fi
}

# Function to configure UFW
configure_ufw() {
    echo "Configuring UFW..."

    # Set default policies
    sudo ufw default "$DEFAULT_IN_POLICY" incoming
    sudo ufw default "$DEFAULT_OUT_POLICY" outgoing

    # Configure allowed ports
    IFS=',' read -ra PORTS <<< "$ALLOWED_PORTS"
    for PORT in "${PORTS[@]}"; do
        sudo ufw allow "$PORT"
        if [ $? -eq 0 ]; then
            echo "Port $PORT allowed successfully."
        else
            echo "Failed to allow port $PORT."
        fi
    done

    # Enable UFW
    sudo ufw enable
    if [ $? -eq 0 ]; then
        echo "UFW enabled successfully."
    else
        echo "Error enabling UFW. Please check the configuration."
        exit 1
    fi
}

# Main script execution
echo "Firewall Setup for Ubuntu Server using UFW"
gather_input
configure_ufw

echo "UFW configuration applied successfully."
