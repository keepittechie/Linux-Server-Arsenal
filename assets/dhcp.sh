#!/usr/bin/env bash

####################################
# DHCP Server Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and configuration of 
# a DHCP server on Debian, CentOS/RHEL, and Arch-based systems.
# The user is prompted to enter the network configuration details.
#
# Author: KeepItTechie
# Version: 2.0
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

# Function to install the DHCP server
install_dhcp_server() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y isc-dhcp-server
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y dhcp-server
            ;;
        arch)
            sudo pacman -Sy --noconfirm dhcp
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Function to configure the DHCP server
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

    # Configure /etc/default/isc-dhcp-server or equivalent file depending on distro
    case "$DISTRO" in
        ubuntu|debian)
            echo "INTERFACESv4=\"$INTERFACE\"" > /etc/default/isc-dhcp-server
            DHCPD_CONF_PATH="/etc/dhcp/dhcpd.conf"
            ;;
        centos|rhel|rocky|alma)
            echo "DHCPDARGS=\"$INTERFACE\";" > /etc/sysconfig/dhcpd
            DHCPD_CONF_PATH="/etc/dhcp/dhcpd.conf"
            ;;
        arch)
            echo "DHCPD4_ARGS=\"$INTERFACE\"" > /etc/conf.d/dhcpd
            DHCPD_CONF_PATH="/etc/dhcpd.conf"
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac

    # Configure the dhcpd.conf file
    cat <<EOF > $DHCPD_CONF_PATH
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

    # Restart and enable the DHCP service
    case "$DISTRO" in
        ubuntu|debian|centos|rhel|rocky|alma)
            sudo systemctl restart isc-dhcp-server || sudo systemctl restart dhcpd
            sudo systemctl enable isc-dhcp-server || sudo systemctl enable dhcpd
            ;;
        arch)
            sudo systemctl restart dhcpd4
            sudo systemctl enable dhcpd4
            ;;
    esac
}

# Main script execution
echo "DHCP Server Installation for Debian, CentOS/RHEL, and Arch"

detect_distro
install_dhcp_server
configure_dhcp_server

echo "DHCP Server installed and configured successfully."
