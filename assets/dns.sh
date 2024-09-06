#!/usr/bin/env bash

####################################
# DNS Server Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation and configuration of
# a DNS caching server or a DNS server on Ubuntu servers. The 
# user is prompted to select which server they would like to install.
#
# Author: KeepItTechie
# Version: 1.0
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

# Function to install and configure dnsmasq as DNS caching server
install_dns_caching() {
    apt update
    apt install -y dnsmasq

    echo "Enter the upstream DNS server (e.g., 8.8.8.8): "
    read UPSTREAM_DNS

    echo "server=$UPSTREAM_DNS" >> /etc/dnsmasq.conf
    systemctl restart dnsmasq
    systemctl enable dnsmasq
}

# Function to install and configure bind9 as DNS server
install_dns_server() {
    apt update
    apt install -y bind9 bind9utils bind9-doc

    echo "Enter your domain name (e.g., example.com): "
    read DOMAIN_NAME

    echo "Enter the IP address of your DNS server (e.g., 192.168.1.100): "
    read DNS_SERVER_IP

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

    mkdir -p /etc/bind/zones

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

    systemctl restart bind9
    systemctl enable bind9
}

# Main script execution
echo "DNS Caching Server or DNS Server Installation for Ubuntu Server"

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
