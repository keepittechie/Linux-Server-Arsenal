#!/usr/bin/env bash

####################################
# LinservArsenal Main Script
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script serves as the main menu to manage and execute various
# server configuration scripts stored in the assets folder.
#
# Author: KeepItTechie
# Version: 2.3
# License: MIT
#
############################################################

# Global variable to store the chosen tool (dialog or whiptail)
MENU_TOOL=""

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

# Function to check if dialog or whiptail is installed, and install if missing
check_install_menu_tool() {
    if command -v dialog &> /dev/null; then
        MENU_TOOL="dialog"
    elif command -v whiptail &> /dev/null; then
        MENU_TOOL="whiptail"
    else
        echo "Neither dialog nor whiptail is installed. Installing..."
        case "$DISTRO" in
            ubuntu|debian)
                sudo apt update
                sudo apt install -y dialog || sudo apt install -y whiptail
                ;;
            centos|rhel|rocky|alma)
                sudo yum install -y dialog || sudo yum install -y whiptail
                ;;
            arch)
                sudo pacman -Sy --noconfirm dialog || sudo pacman -Sy --noconfirm whiptail
                ;;
            *)
                echo "Unsupported distribution!"
                exit 1
                ;;
        esac
        # Recheck after installation
        if command -v dialog &> /dev/null; then
            MENU_TOOL="dialog"
        elif command -v whiptail &> /dev/null; then
            MENU_TOOL="whiptail"
        else
            echo "Failed to install both dialog and whiptail. Exiting."
            exit 1
        fi
    fi
}

# Function to display the menu
display_menu() {
    OPTIONS=(
        1 "Install Apache Kafka"
        2 "Install Docker and Containers"
        3 "Install Databases"
        4 "Configure DHCP Server"
        5 "Configure DNS Server"
        6 "Install Elasticsearch"
        7 "Install Fail2Ban"
        8 "Install Jenkins"
        9 "Install LAMP Stack"
        10 "Install LEMP Stack"
        11 "Install LibreChat"
        12 "Log Management"
        13 "Manage Packages"
        14 "Install Media Server"
        15 "Install Nextcloud"
        16 "Configure Nginx Reverse Proxy"
        17 "Install Node.js and NPM"
        18 "Install OpenVPN"
        19 "Install Prometheus and Grafana"
        20 "Install RabbitMQ"
        21 "Install Redis"
        22 "Manage Services"
        23 "Configure Static IP"
        24 "System Monitoring"
        25 "Configure UFW Firewall"
        26 "Manage Users"
        27 "Exit"
    )

    # Use dialog or whiptail depending on availability
    if [[ "$MENU_TOOL" == "dialog" ]]; then
        CHOICE=$(dialog --clear \
            --backtitle "LinservArsenal Script Launcher" \
            --title "Main Menu" \
            --menu "Choose a script to execute:" 20 60 14 \
            "${OPTIONS[@]}" 2>&1 >/dev/tty)
    elif [[ "$MENU_TOOL" == "whiptail" ]]; then
        CHOICE=$(whiptail --clear \
            --backtitle "LinservArsenal Script Launcher" \
            --title "Main Menu" \
            --menu "Choose a script to execute:" 20 60 14 \
            "${OPTIONS[@]}" 3>&1 1>&2 2>&3)
    fi

    clear
    run_script $CHOICE
}

# Function to run the selected script
run_script() {
    case $1 in
        1) bash ./assets/apache-kafka.sh ;;
        2) bash ./assets/container.sh ;;
        3) bash ./assets/database.sh ;;
        4) bash ./assets/dhcp.sh ;;
        5) bash ./assets/dns.sh ;;
        6) bash ./assets/elasticsearch.sh ;;
        7) bash ./assets/fail2ban.sh ;;
        8) bash ./assets/jenkins.sh ;;
        9) bash ./assets/lamp.sh ;;
        10) bash ./assets/lemp.sh ;;
        11) bash ./assets/librechat.sh ;;
        12) bash ./assets/log-man.sh ;;
        13) bash ./assets/manage-packages.sh ;;
        14) bash ./assets/media.sh ;;
        15) bash ./assets/nextcloud.sh ;;
        16) bash ./assets/nginx-reverse-proxy.sh ;;
        17) bash ./assets/nodejs-npm.sh ;;
        18) bash ./assets/openvpn.sh ;;
        19) bash ./assets/prometheus-grafana.sh ;;
        20) bash ./assets/rabbitmq.sh ;;
        21) bash ./assets/redis.sh ;;
        22) bash ./assets/service-man.sh ;;
        23) bash ./assets/static-ip.sh ;;
        24) bash ./assets/system-mon.sh ;;
        25) bash ./assets/ufw.sh ;;
        26) bash ./assets/user.sh ;;
        27) exit 0 ;;
        *) echo "Invalid choice!" ;;
    esac
}

# Main script execution
detect_distro
check_install_menu_tool

while true; do
    display_menu
done
