#!/usr/bin/env bash

####################################
# Jenkins Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Jenkins on Debian,
# CentOS/RHEL, and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-jenkins.sh.
#   2. Make the script executable:
#      chmod +x auto-jenkins.sh
#   3. Run the script:
#      sudo ./auto-jenkins.sh
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

# Function to install Jenkins on Debian/Ubuntu
install_jenkins_debian() {
    sudo apt update
    sudo apt install -y openjdk-11-jdk
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt update
    sudo apt install -y jenkins
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
}

# Function to install Jenkins on CentOS/RHEL
install_jenkins_centos() {
    sudo dnf install -y java-11-openjdk-devel
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo dnf install -y jenkins
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
}

# Function to install Jenkins on Arch Linux
install_jenkins_arch() {
    sudo pacman -Sy --noconfirm jdk11-openjdk
    sudo pacman -Sy --noconfirm jenkins
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
}

# Main script execution
echo "Jenkins Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install Jenkins based on the detected distribution
case "$DISTRO" in
    ubuntu|debian)
        echo "Installing Jenkins on Debian/Ubuntu..."
        install_jenkins_debian
        ;;
    centos|rhel|rocky|alma)
        echo "Installing Jenkins on CentOS/RHEL..."
        install_jenkins_centos
        ;;
    arch)
        echo "Installing Jenkins on Arch..."
        install_jenkins_arch
        ;;
    *)
        echo "Unsupported distribution!"
        exit 1
        ;;
esac

echo "Jenkins installed successfully."
