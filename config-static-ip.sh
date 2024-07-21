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
# Version: 1.0
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
    read -p "Enter the DNS servers (e.g., 8.8.8.8, 8.8.4.4): " DNS_SERVERS
}

# Function to create the Netplan configuration file
create_netplan_config() {
    CONFIG_FILE="/etc/netplan/01-netcfg.yaml"

    echo "network:" > $CONFIG_FILE
    echo "  version: 2" >> $CONFIG_FILE
    echo "  ethernets:" >> $CONFIG_FILE
    echo "    $INTERFACE:" >> $CONFIG_FILE
    echo "      addresses:" >> $CONFIG_FILE
    echo "        - $IP_ADDRESS" >> $CONFIG_FILE
    echo "      gateway4: $GATEWAY" >> $CONFIG_FILE
    echo "      nameservers:" >> $CONFIG_FILE
    echo "        addresses:" >> $CONFIG_FILE
    echo "          - $(echo $DNS_SERVERS | sed 's/,/\n          - /g')" >> $CONFIG_FILE
}

# Function to apply the Netplan configuration
apply_netplan_config() {
    netplan apply
}

# Main script execution
echo "Static IP Configuration for Ubuntu Server using Netplan"
gather_input
create_netplan_config
apply_netplan_config

echo "Netplan configuration applied successfully."
