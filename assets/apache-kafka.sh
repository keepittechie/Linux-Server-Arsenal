#!/usr/bin/env bash

####################################
# Apache Kafka Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Apache Kafka
# on Debian, CentOS, and Arch-based servers.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-apache-kafka.sh.
#   2. Make the script executable:
#      chmod +x auto-apache-kafka.sh
#   3. Run the script:
#      sudo ./auto-apache-kafka.sh
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

# Function to install dependencies based on distro
install_dependencies() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y default-jdk zookeeperd wget tar
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y java-1.8.0-openjdk zookeeper wget tar
            ;;
        arch)
            sudo pacman -Sy --noconfirm jre-openjdk zookeeper wget tar
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Function to install Apache Kafka
install_kafka() {
    wget https://downloads.apache.org/kafka/2.8.0/kafka_2.13-2.8.0.tgz
    tar -xzf kafka_2.13-2.8.0.tgz
    sudo mv kafka_2.13-2.8.0 /usr/local/kafka

    # Add Kafka to PATH
    echo "export PATH=\$PATH:/usr/local/kafka/bin" >> ~/.bashrc
    source ~/.bashrc
}

# Main script execution
echo "Apache Kafka Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distro
detect_distro

# Install required dependencies
install_dependencies

# Install Apache Kafka
install_kafka

echo "Apache Kafka installed successfully."
