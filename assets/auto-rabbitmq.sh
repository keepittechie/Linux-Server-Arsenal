#!/usr/bin/env bash

####################################
# RabbitMQ Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of RabbitMQ on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-rabbitmq.sh.
#   2. Make the script executable:
#      chmod +x auto-rabbitmq.sh
#   3. Run the script:
#      sudo ./auto-rabbitmq.sh
#
############################################################

# Function to install RabbitMQ
install_rabbitmq() {
    apt update
    apt install -y erlang
    wget -O- https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey | sudo apt-key add -
    echo "deb https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
    apt update
    apt install -y rabbitmq-server
    systemctl enable rabbitmq-server
    systemctl start rabbitmq-server
}

# Main script execution
echo "RabbitMQ Installation for Ubuntu Server"
install_rabbitmq

echo "RabbitMQ installed successfully."
