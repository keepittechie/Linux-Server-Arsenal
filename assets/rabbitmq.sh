#!/usr/bin/env bash

####################################
# RabbitMQ Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of RabbitMQ on Debian,
# CentOS/RHEL, and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
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

# Function to install RabbitMQ on Debian/Ubuntu
install_rabbitmq_debian() {
    sudo apt update
    sudo apt install -y erlang
    wget -O- https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey | sudo apt-key add -
    echo "deb https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list
    sudo apt update
    sudo apt install -y rabbitmq-server
    sudo systemctl enable rabbitmq-server
    sudo systemctl start rabbitmq-server
}

# Function to install RabbitMQ on CentOS/RHEL
install_rabbitmq_centos() {
    sudo dnf install -y epel-release
    sudo dnf install -y erlang
    sudo dnf install -y https://packagecloud.io/rabbitmq/rabbitmq-server/packages/el/8/rabbitmq-server-3.9.13-1.el8.noarch.rpm
    sudo systemctl enable rabbitmq-server
    sudo systemctl start rabbitmq-server
}

# Function to install RabbitMQ on Arch Linux
install_rabbitmq_arch() {
    sudo pacman -Sy --noconfirm erlang rabbitmq
    sudo systemctl enable rabbitmq
    sudo systemctl start rabbitmq
}

# Main script execution
echo "RabbitMQ Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install RabbitMQ based on the detected distribution
case "$DISTRO" in
    ubuntu|debian)
        install_rabbitmq_debian
        ;;
    centos|rhel|rocky|alma)
        install_rabbitmq_centos
        ;;
    arch)
        install_rabbitmq_arch
        ;;
    *)
        echo "Unsupported distribution!"
        exit 1
        ;;
esac

echo "RabbitMQ installed successfully."
