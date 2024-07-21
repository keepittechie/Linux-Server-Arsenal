#!/usr/bin/env bash

####################################
# Redis Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Redis on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-redis.sh.
#   2. Make the script executable:
#      chmod +x auto-redis.sh
#   3. Run the script:
#      sudo ./auto-redis.sh
#
############################################################

# Function to install Redis
install_redis() {
    apt update
    apt install -y redis-server
    systemctl enable redis-server
    systemctl start redis-server
}

# Main script execution
echo "Redis Installation for Ubuntu Server"
install_redis

echo "Redis installed successfully."
