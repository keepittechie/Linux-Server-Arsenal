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
# Version: 1.1
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, log-man.sh.
#   2. Make the script executable:
#      chmod +x log-man.sh
#   3. Run the script:
#      sudo ./log-man.sh
#
############################################################

# Function to clean system logs
clean_logs() {
    echo "Cleaning systemd journal logs older than $RETENTION_TIME..."
    journalctl --vacuum-time=$RETENTION_TIME || { echo "Failed to clean journal logs"; exit 1; }

    echo "Truncating log files in /var/log..."
    find /var/log -type f -name "*.log" -exec truncate -s 0 {} \; || { echo "Failed to truncate log files"; exit 1; }

    echo "Removing old rotated log files (.gz)..."
    find /var/log -type f -name "*.gz" -delete || { echo "Failed to remove rotated logs"; exit 1; }
}

# Main script execution
echo "Log Management for Ubuntu Server"

# Ask for confirmation
read -p "This will clean logs older than 2 weeks and remove rotated logs. Continue? (y/n): " CONFIRMATION
if [[ "$CONFIRMATION" == "y" || "$CONFIRMATION" == "Y" ]]; then
    # Prompt for retention period
    read -p "Enter log retention time (e.g., 2weeks, 1month, 10days): " RETENTION_TIME

    # Default retention time if not provided
    RETENTION_TIME=${RETENTION_TIME:-2weeks}

    clean_logs
    echo "Log cleanup completed successfully."
else
    echo "Operation canceled by the user."
    exit 0
fi
