#!/usr/bin/env bash

####################################
# Auto-Container Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Docker, Docker Compose,
# Podman, and LXC/LXD on Debian, CentOS/RHEL, and Arch-based systems.
# The user is prompted to select which tools they would like to install.
#
# Author: KeepItTechie
# Version: 2.0
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

# Function to install Docker
install_docker() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt update
            sudo apt install -y docker-ce
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io
            ;;
        arch)
            sudo pacman -Sy --noconfirm docker
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
    sudo systemctl enable docker
    sudo systemctl start docker
}

# Function to install Docker Compose
install_docker_compose() {
    sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '(?<=\"tag_name\": \")[^\"]*')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

# Function to install Podman
install_podman() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y podman
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y podman
            ;;
        arch)
            sudo pacman -Sy --noconfirm podman
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Function to install LXC/LXD
install_lxc_lxd() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y lxd lxd-client
            sudo lxd init --auto
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y lxc lxc-templates
            ;;
        arch)
            sudo pacman -Sy --noconfirm lxc lxd
            sudo lxd init --auto
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
}

# Main script execution
echo "Docker, Docker Compose, Podman, and LXC/LXD Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distro
detect_distro

# Prompt for Docker installation
read -p "Do you want to install Docker? (y/n): " INSTALL_DOCKER
if [ "$INSTALL_DOCKER" = "y" ]; then
    echo "Installing Docker..."
    install_docker
    echo "Docker installed successfully."
fi

# Prompt for Docker Compose installation
read -p "Do you want to install Docker Compose? (y/n): " INSTALL_DOCKER_COMPOSE
if [ "$INSTALL_DOCKER_COMPOSE" = "y" ]; then
    echo "Installing Docker Compose..."
    install_docker_compose
    echo "Docker Compose installed successfully."
fi

# Prompt for Podman installation
read -p "Do you want to install Podman? (y/n): " INSTALL_PODMAN
if [ "$INSTALL_PODMAN" = "y" ]; then
    echo "Installing Podman..."
    install_podman
    echo "Podman installed successfully."
fi

# Prompt for LXC/LXD installation
read -p "Do you want to install LXC/LXD? (y/n): " INSTALL_LXC_LXD
if [ "$INSTALL_LXC_LXD" = "y" ]; then
    echo "Installing LXC/LXD..."
    install_lxc_lxd
    echo "LXC/LXD installed successfully."
fi

echo "Installation script completed."
