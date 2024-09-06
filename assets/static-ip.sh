#!/usr/bin/env bash

####################################
# Static IP Configuration Script for Ubuntu Server using Netplan
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script helps in configuring a static IP address for
# Ubuntu servers using the Netplan utility. It prompts the 
# user for the necessary network details and generates the 
# appropriate Netplan configuration file.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, config-static-ip.sh.
#   2. Make the script executable:
#      chmod +x config-static-ip.sh
#   3. Run the script:
#      sudo ./config-static-ip.sh
#
# The script will prompt for:
#   - Network interface name (e.g., eth0)
#   - Static IP address (e.g., 192.168.1.100/24)
#   - Gateway (e.g., 192.168.1.1)
#   - DNS servers (e.g., 8.8.8.8, 8.8.4.4)
#
# The generated Netplan configuration file is saved as:
#   /etc/netplan/01-netcfg.yaml
#
# The script will then apply the Netplan configuration.
#
############################################################

# Function to gather input from the user
gather_input() {
    read -p "Enter the interface name (e.g., eth0): " INTERFACE
    read -p "Enter the static IP address (e.g., 192.168.1.100/24): " IP_ADDRESS
    read -p "Enter the gateway (e.g., 192.168.1.1): " GATEWAY
    read -p "Enter the DNS servers (comma-separated, e.g., 8.8.8.8, 8.8.4.4): " DNS_SERVERS

    # Confirm input
    echo "You have entered the following details:"
    echo "Interface: $INTERFACE"
    echo "Static IP Address: $IP_ADDRESS"
    echo "Gateway: $GATEWAY"
    echo "DNS Servers: $DNS_SERVERS"
    read -p "Is this information correct? (y/n): " CONFIRM

    if [[ "$CONFIRM" != "y" ]]; then
        echo "Exiting without making any changes."
        exit 1
    fi
}

# Function to create the Netplan configuration file
create_netplan_config() {
    CONFIG_FILE="/etc/netplan/01-netcfg.yaml"

    # Backup the existing config if it exists
    if [ -f $CONFIG_FILE ]; then
        sudo cp $CONFIG_FILE "${CONFIG_FILE}.bak_$(date +%F_%T)"
        echo "Backup of existing Netplan config created: ${CONFIG_FILE}.bak_$(date +%F_%T)"
    fi

    # Create the new configuration file
    echo "network:" | sudo tee $CONFIG_FILE
    echo "  version: 2" | sudo tee -a $CONFIG_FILE
    echo "  ethernets:" | sudo tee -a $CONFIG_FILE
    echo "    $INTERFACE:" | sudo tee -a $CONFIG_FILE
    echo "      addresses:" | sudo tee -a $CONFIG_FILE
    echo "        - $IP_ADDRESS" | sudo tee -a $CONFIG_FILE
    echo "      gateway4: $GATEWAY" | sudo tee -a $CONFIG_FILE
    echo "      nameservers:" | sudo tee -a $CONFIG_FILE
    echo "        addresses:" | sudo tee -a $CONFIG_FILE
    echo "          - $(echo $DNS_SERVERS | sed 's/,/\n          - /g')" | sudo tee -a $CONFIG_FILE

    echo "Netplan configuration created at $CONFIG_FILE"
}

# Function to apply the Netplan configuration
apply_netplan_config() {
    echo "Applying Netplan configuration..."
    sudo netplan apply

    if [ $? -eq 0 ]; then
        echo "Netplan configuration applied successfully."
    else
        echo "Error applying Netplan configuration. Please check the configuration file."
    fi
}

# Main script execution
echo "Static IP Configuration for Ubuntu Server using Netplan"
gather_input
create_netplan_config
apply_netplan_config

echo "Static IP configuration complete."
