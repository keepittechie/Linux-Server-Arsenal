#!/usr/bin/env bash

####################################
# Jenkins Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Jenkins on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
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

# Function to install Jenkins
install_jenkins() {
    apt update
    apt install -y openjdk-11-jdk
    wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
    sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt update
    apt install -y jenkins
    systemctl enable jenkins
    systemctl start jenkins
}

# Main script execution
echo "Jenkins Installation for Ubuntu Server"
install_jenkins

echo "Jenkins installed successfully."
