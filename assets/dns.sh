#!/usr/bin/env bash

####################################
# DNS Server Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and configuration of
# a DNS caching server (dnsmasq) or a DNS server (bind9) on
# Debian, CentOS/RHEL, and Arch-based systems. The user is prompted
# to select which server they would like to install.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-dns.sh.
#   2. Make the script executable:
#      chmod +x auto-dns.sh
#   3. Run the script:
#      sudo ./auto-dns.sh
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

# Function to install and configure dnsmasq as DNS caching server
install_dns_caching() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y dnsmasq
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y dnsmasq
            ;;
        arch)
            sudo pacman -Sy --noconfirm dnsmasq
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac

    echo "Enter the upstream DNS server (e.g., 8.8.8.8): "
    read UPSTREAM_DNS

    echo "server=$UPSTREAM_DNS" >> /etc/dnsmasq.conf
    sudo systemctl restart dnsmasq
    sudo systemctl enable dnsmasq
}

# Function to install and configure bind9 as DNS server
install_dns_server() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y bind9 bind9utils bind9-doc
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y bind bind-utils
            ;;
        arch)
            sudo pacman -Sy --noconfirm bind
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac

    echo "Enter your domain name (e.g., example.com): "
    read DOMAIN_NAME

    echo "Enter the IP address of your DNS server (e.g., 192.168.1.100): "
    read DNS_SERVER_IP

    # Configure the named.conf.local file
    cat <<EOF > /etc/bind/named.conf.local
zone "$DOMAIN_NAME" {
    type master;
    file "/etc/bind/zones/db.$DOMAIN_NAME";
};

zone "0.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.0";
};
EOF

    sudo mkdir -p /etc/bind/zones

    # Configure forward zone
    cat <<EOF > /etc/bind/zones/db.$DOMAIN_NAME
;
; BIND data file for $DOMAIN_NAME
;
\$TTL    604800
@       IN      SOA     ns1.$DOMAIN_NAME. admin.$DOMAIN_NAME. (
                        1         ; Serial
                        604800    ; Refresh
                        86400     ; Retry
                        2419200   ; Expire
                        604800 )  ; Negative Cache TTL
;
@       IN      NS      ns1.$DOMAIN_NAME.
@       IN      A       $DNS_SERVER_IP
ns1     IN      A       $DNS_SERVER_IP
EOF

    # Configure reverse zone
    cat <<EOF > /etc/bind/zones/db.192.168.0
;
; BIND reverse data file for 192.168.0. network
;
\$TTL    604800
@       IN      SOA     ns1.$DOMAIN_NAME. admin.$DOMAIN_NAME. (
                        1         ; Serial
                        604800    ; Refresh
                        86400     ; Retry
                        2419200   ; Expire
                        604800 )  ; Negative Cache TTL
;
@       IN      NS      ns1.$DOMAIN_NAME.
$DNS_SERVER_IP.in-addr.arpa. IN PTR ns1.$DOMAIN_NAME.
EOF

    sudo systemctl restart named || sudo systemctl restart bind9
    sudo systemctl enable named || sudo systemctl enable bind9
}

# Main script execution
echo "DNS Caching Server or DNS Server Installation for Debian, CentOS/RHEL, and Arch"

detect_distro

echo "Choose the type of DNS server to install:"
echo "1. DNS Caching Server (dnsmasq)"
echo "2. DNS Server (bind9)"
read -p "Enter your choice (1 or 2): " SERVER_CHOICE

case $SERVER_CHOICE in
    1)
        echo "Installing DNS Caching Server (dnsmasq)..."
        install_dns_caching
        echo "DNS Caching Server installed and configured successfully."
        ;;
    2)
        echo "Installing DNS Server (bind9)..."
        install_dns_server
        echo "DNS Server installed and configured successfully."
        ;;
    *)
        echo "Invalid choice. Please run the script again and select either 1 or 2."
        exit 1
        ;;
esac

echo "Installation script completed."
