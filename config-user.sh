#!/usr/bin/env bash

####################################
# User Management Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script helps in managing users and groups on Ubuntu servers.
# It provides options to add, delete, and manage users and groups.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, config-users.sh.
#   2. Make the script executable:
#      chmod +x manage-users.sh
#   3. Run the script:
#      sudo ./manage-users.sh
#
# The script will prompt for the desired action and user/group details.
#
############################################################

# Function to display menu
display_menu() {
    echo "User Management Menu:"
    echo "1. Add User"
    echo "2. Delete User"
    echo "3. Add Group"
    echo "4. Delete Group"
    echo "5. Add User to Group"
    echo "6. Exit"
}

# Function to add a user
add_user() {
    read -p "Enter the username to add: " USERNAME
    adduser $USERNAME
}

# Function to delete a user
delete_user() {
    read -p "Enter the username to delete: " USERNAME
    deluser $USERNAME
}

# Function to add a group
add_group() {
    read -p "Enter the group name to add: " GROUPNAME
    addgroup $GROUPNAME
}

# Function to delete a group
delete_group() {
    read -p "Enter the group name to delete: " GROUPNAME
    delgroup $GROUPNAME
}

# Function to add a user to a group
add_user_to_group() {
    read -p "Enter the username: " USERNAME
    read -p "Enter the group name: " GROUPNAME
    adduser $USERNAME $GROUPNAME
}

# Main script execution
while true; do
    display_menu
    read -p "Choose an option [1-6]: " OPTION
    case $OPTION in
        1) add_user ;;
        2) delete_user ;;
        3) add_group ;;
        4) delete_group ;;
        5) add_user_to_group ;;
        6) break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done

echo "User management completed."
