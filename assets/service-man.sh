#!/usr/bin/env bash

####################################
# Service Management Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script helps in managing system services on Ubuntu servers.
# It provides options to start, stop, restart, and check the status
# of services.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, service-man.sh.
#   2. Make the script executable:
#      chmod +x service-man.sh
#   3. Run the script:
#      sudo ./service-man.sh
#
############################################################

# Function to display menu
display_menu() {
    echo "Service Management Menu:"
    echo "1. Start Service"
    echo "2. Stop Service"
    echo "3. Restart Service"
    echo "4. Check Service Status"
    echo "5. Exit"
}

# Function to start a service
start_service() {
    read -p "Enter the service name to start: " SERVICE
    systemctl start $SERVICE
}

# Function to stop a service
stop_service() {
    read -p "Enter the service name to stop: " SERVICE
    systemctl stop $SERVICE
}

# Function to restart a service
restart_service() {
    read -p "Enter the service name to restart: " SERVICE
    systemctl restart $SERVICE
}

# Function to check the status of a service
check_service_status() {
    read -p "Enter the service name to check status: " SERVICE
    systemctl status $SERVICE
}

# Main script execution
while true; do
    display_menu
    read -p "Choose an option [1-5]: " OPTION
    case $OPTION in
        1) start_service ;;
        2) stop_service ;;
        3) restart_service ;;
        4) check_service_status ;;
        5) break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done

echo "Service management completed."
