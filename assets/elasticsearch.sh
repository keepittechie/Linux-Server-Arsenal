#!/usr/bin/env bash

####################################
# Elasticsearch Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Elasticsearch on
# Debian, CentOS/RHEL, and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
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

# Function to install Elasticsearch on Debian/Ubuntu
install_elasticsearch_debian() {
    sudo apt update
    sudo apt install -y apt-transport-https openjdk-11-jdk
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
    sudo apt update
    sudo apt install -y elasticsearch
    sudo systemctl enable elasticsearch
    sudo systemctl start elasticsearch
}

# Function to install Elasticsearch on CentOS/RHEL
install_elasticsearch_centos() {
    sudo dnf install -y java-11-openjdk-devel
    sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
    sudo tee /etc/yum.repos.d/elasticsearch.repo <<EOF
[elasticsearch-7.x]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
    sudo dnf install -y elasticsearch
    sudo systemctl enable elasticsearch
    sudo systemctl start elasticsearch
}

# Function to install Elasticsearch on Arch Linux
install_elasticsearch_arch() {
    sudo pacman -Sy --noconfirm jdk11-openjdk
    sudo pacman -Sy --noconfirm elasticsearch
    sudo systemctl enable elasticsearch
    sudo systemctl start elasticsearch
}

# Main script execution
echo "Elasticsearch Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install Elasticsearch based on the detected distribution
case "$DISTRO" in
    ubuntu|debian)
        echo "Installing Elasticsearch on Debian/Ubuntu..."
        install_elasticsearch_debian
        ;;
    centos|rhel|rocky|alma)
        echo "Installing Elasticsearch on CentOS/RHEL..."
        install_elasticsearch_centos
        ;;
    arch)
        echo "Installing Elasticsearch on Arch..."
        install_elasticsearch_arch
        ;;
    *)
        echo "Unsupported distribution!"
        exit 1
        ;;
esac

echo "Elasticsearch installed successfully."
