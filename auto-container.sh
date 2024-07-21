#!/usr/bin/env bash

####################################
# Auto-Container Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Docker, Docker Compose,
# Podman, and LXC/LXD on Ubuntu servers. The user is prompted to select
# which tools they would like to install.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-container.sh.
#   2. Make the script executable:
#      chmod +x auto-container.sh
#   3. Run the script:
#      sudo ./auto-container.sh
#
############################################################

# Function to install Docker
install_docker() {
    apt update
    apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt update
    apt install -y docker-ce
    systemctl enable docker
    systemctl start docker
}

# Function to install Docker Compose
install_docker_compose() {
    curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '(?<="tag_name": ")[^"]*')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

# Function to install Podman
install_podman() {
    apt update
    apt install -y podman
}

# Function to install LXC/LXD
install_lxc_lxd() {
    apt update
    apt install -y lxd lxd-client
    lxd init --auto
}

# Main script execution
echo "Docker, Docker Compose, Podman, and LXC/LXD Installation for Ubuntu Server"

read -p "Do you want to install Docker? (y/n): " INSTALL_DOCKER
if [ "$INSTALL_DOCKER" = "y" ]; then
    echo "Installing Docker..."
    install_docker
    echo "Docker installed successfully."
fi

read -p "Do you want to install Docker Compose? (y/n): " INSTALL_DOCKER_COMPOSE
if [ "$INSTALL_DOCKER_COMPOSE" = "y" ]; then
    echo "Installing Docker Compose..."
    install_docker_compose
    echo "Docker Compose installed successfully."
fi

read -p "Do you want to install Podman? (y/n): " INSTALL_PODMAN
if [ "$INSTALL_PODMAN" = "y" ]; then
    echo "Installing Podman..."
    install_podman
    echo "Podman installed successfully."
fi

read -p "Do you want to install LXC/LXD? (y/n): " INSTALL_LXC_LXD
if [ "$INSTALL_LXC_LXD" = "y" ]; then
    echo "Installing LXC/LXD..."
    install_lxc_lxd
    echo "LXC/LXD installed successfully."
fi

echo "Installation script completed."
