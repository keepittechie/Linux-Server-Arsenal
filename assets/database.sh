#!/usr/bin/env bash

####################################
# Auto Database Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of MySQL, MariaDB,
# or PostgreSQL on Debian, CentOS/RHEL, and Arch-based systems.
# The user is prompted to select which database they would like to install.
#
# Author: KeepItTechie
# Version: 2.0
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
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y mysql-server
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y mysql-server
            ;;
        arch)
            sudo pacman -Sy --noconfirm mysql
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
    sudo systemctl enable mysqld
    sudo systemctl start mysqld
}

# Function to install MariaDB
install_mariadb() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y mariadb-server
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y mariadb-server
            ;;
        arch)
            sudo pacman -Sy --noconfirm mariadb
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
}

# Function to install PostgreSQL
install_postgresql() {
    case "$DISTRO" in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y postgresql postgresql-contrib
            ;;
        centos|rhel|rocky|alma)
            sudo dnf install -y postgresql postgresql-server
            sudo postgresql-setup --initdb
            ;;
        arch)
            sudo pacman -Sy --noconfirm postgresql
            sudo su - postgres -c "initdb --locale en_US.UTF-8 -D /var/lib/postgres/data"
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
}

# Main script execution
detect_distro
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
