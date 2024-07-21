#!/usr/bin/env bash

####################################
# DHCP Server Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and configuration of 
# a DHCP server on Ubuntu servers using isc-dhcp-server.
# The user is prompted to enter the network configuration details.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-dhcp.sh.
#   2. Make the script executable:
#      chmod +x auto-dhcp.sh
#   3. Run the script:
#      sudo ./auto-dhcp.sh
#
############################################################

# Function to install isc-dhcp-server
install_dhcp_server() {
    apt update
    apt install -y isc-dhcp-server
}

# Function to configure isc-dhcp-server
configure_dhcp_server() {
    echo "Enter the network interface for the DHCP server (e.g., eth0): "
    read INTERFACE
    echo "Enter the subnet (e.g., 192.168.1.0): "
    read SUBNET
    echo "Enter the netmask (e.g., 255.255.255.0): "
    read NETMASK
    echo "Enter the range of IP addresses to be assigned (e.g., 192.168.1.100 192.168.1.200): "
    read RANGE
    echo "Enter the default gateway (e.g., 192.168.1.1): "
    read GATEWAY
    echo "Enter the DNS server (e.g., 8.8.8.8): "
    read DNS_SERVER

    # Configure /etc/default/isc-dhcp-server
    echo "INTERFACESv4=\"$INTERFACE\"" > /etc/default/isc-dhcp-server

    # Configure /etc/dhcp/dhcpd.conf
    cat <<EOF > /etc/dhcp/dhcpd.conf
option domain-name "example.com";
option domain-name-servers $DNS_SERVER;

default-lease-time 600;
max-lease-time 7200;

subnet $SUBNET netmask $NETMASK {
    range $RANGE;
    option routers $GATEWAY;
    option subnet-mask $NETMASK;
    option broadcast-address $(echo $SUBNET | awk -F. '{print $1"."$2"."$3".255"}');
    option domain-name-servers $DNS_SERVER;
}
EOF

    systemctl restart isc-dhcp-server
    systemctl enable isc-dhcp-server
}

# Main script execution
echo "DHCP Server Installation for Ubuntu Server"

install_dhcp_server
configure_dhcp_server

echo "DHCP Server installed and configured successfully."
