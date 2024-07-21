#!/usr/bin/env bash

####################################
# Log Management Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script helps in organizing and cleaning system logs on
# Ubuntu servers to maintain optimal performance.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, manage-logs.sh.
#   2. Make the script executable:
#      chmod +x manage-logs.sh
#   3. Run the script:
#      sudo ./manage-logs.sh
#
############################################################

# Function to clean system logs
clean_logs() {
    # Clear systemd journal logs
    journalctl --vacuum-time=2weeks

    # Clear old log files
    find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;

    # Remove rotated log files
    find /var/log -type f -name "*.gz" -delete
}

# Main script execution
echo "Log Management for Ubuntu Server"
clean_logs

echo "Log cleanup completed successfully."
