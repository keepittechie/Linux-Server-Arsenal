#!/usr/bin/env bash

####################################
# System Monitoring Setup Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script helps in setting up system monitoring on Ubuntu
# servers. It installs and configures common monitoring tools
# like htop, netdata, and more.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, system-mon.sh.
#   2. Make the script executable:
#      chmod +x system-mon.sh
#   3. Run the script:
#      sudo ./system-mon.sh
#
############################################################

# Function to install monitoring tools
install_monitoring_tools() {
    apt update
    apt install -y htop netdata

    # Enable and start Netdata
    systemctl enable netdata
    systemctl start netdata
}

# Main script execution
echo "System Monitoring Setup for Ubuntu Server"
install_monitoring_tools

echo "System monitoring tools installed and configured successfully."
