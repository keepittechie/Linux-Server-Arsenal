#!/usr/bin/env bash

####################################
# Elasticsearch Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Elasticsearch on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-elasticsearch.sh.
#   2. Make the script executable:
#      chmod +x auto-elasticsearch.sh
#   3. Run the script:
#      sudo ./auto-elasticsearch.sh
#
############################################################

# Function to install Elasticsearch
install_elasticsearch() {
    apt update
    apt install -y apt-transport-https openjdk-11-jdk
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
    apt update
    apt install -y elasticsearch
    systemctl enable elasticsearch
    systemctl start elasticsearch
}

# Main script execution
echo "Elasticsearch Installation for Ubuntu Server"
install_elasticsearch

echo "Elasticsearch installed successfully."
