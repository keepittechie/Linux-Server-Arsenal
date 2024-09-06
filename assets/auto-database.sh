#!/usr/bin/env bash

####################################
# Auto Database Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of MySQL, MariaDB,
# or PostgreSQL on Ubuntu servers. The user is prompted to 
# select which database they would like to install.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-database.sh.
#   2. Make the script executable:
#      chmod +x auto-database.sh
#   3. Run the script:
#      sudo ./auto-database.sh
#
############################################################

# Function to prompt user for selection
select_database() {
    echo "Select the database to install:"
    echo "1. MySQL"
    echo "2. MariaDB"
    echo "3. PostgreSQL"
    read -p "Enter the number of your choice [1-3]: " DB_CHOICE
}

# Function to install MySQL
install_mysql() {
    apt update
    apt install -y mysql-server
    systemctl enable mysql
    systemctl start mysql
}

# Function to install MariaDB
install_mariadb() {
    apt update
    apt install -y mariadb-server
    systemctl enable mariadb
    systemctl start mariadb
}

# Function to install PostgreSQL
install_postgresql() {
    apt update
    apt install -y postgresql postgresql-contrib
    systemctl enable postgresql
    systemctl start postgresql
}

# Main script execution
select_database

case $DB_CHOICE in
    1)
        echo "Installing MySQL..."
        install_mysql
        echo "MySQL installed successfully."
        ;;
    2)
        echo "Installing MariaDB..."
        install_mariadb
        echo "MariaDB installed successfully."
        ;;
    3)
        echo "Installing PostgreSQL..."
        install_postgresql
        echo "PostgreSQL installed successfully."
        ;;
    *)
        echo "Invalid choice. Please run the script again and select 1, 2, or 3."
        exit 1
        ;;
esac
