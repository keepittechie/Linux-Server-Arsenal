#!/usr/bin/env bash

####################################
# Nextcloud Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Nextcloud on Debian,
# CentOS/RHEL, and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-nextcloud.sh.
#   2. Make the script executable:
#      chmod +x auto-nextcloud.sh
#   3. Run the script:
#      sudo ./auto-nextcloud.sh
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

# Function to install Nextcloud on Debian/Ubuntu
install_nextcloud_debian() {
    sudo apt update
    sudo apt install -y apache2 mariadb-server libapache2-mod-php \
                       php-gd php-json php-mysql php-curl \
                       php-mbstring php-intl php-imagick php-xml \
                       php-zip unzip wget
    wget https://download.nextcloud.com/server/releases/nextcloud-20.0.4.zip
    sudo unzip nextcloud-20.0.4.zip -d /var/www/
    sudo chown -R www-data:www-data /var/www/nextcloud/
    sudo chmod -R 755 /var/www/nextcloud/
    configure_apache
}

# Function to install Nextcloud on CentOS/RHEL
install_nextcloud_centos() {
    sudo dnf install -y httpd mariadb-server php php-gd php-json php-mysqlnd php-curl \
                       php-mbstring php-intl php-pecl-imagick php-xml php-zip unzip wget
    wget https://download.nextcloud.com/server/releases/nextcloud-20.0.4.zip
    sudo unzip nextcloud-20.0.4.zip -d /var/www/
    sudo chown -R apache:apache /var/www/nextcloud/
    sudo chmod -R 755 /var/www/nextcloud/
    configure_httpd
}

# Function to install Nextcloud on Arch Linux
install_nextcloud_arch() {
    sudo pacman -Sy --noconfirm apache mariadb php php-gd php-json php-mysql \
                          php-curl php-mbstring php-intl imagemagick php-xml \
                          php-zip unzip wget
    wget https://download.nextcloud.com/server/releases/nextcloud-20.0.4.zip
    sudo unzip nextcloud-20.0.4.zip -d /var/www/
    sudo chown -R http:http /var/www/nextcloud/
    sudo chmod -R 755 /var/www/nextcloud/
    configure_httpd
}

# Function to configure Apache for Nextcloud on Debian/Ubuntu
configure_apache() {
    echo "<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/nextcloud/
    ServerName example.com

    <Directory /var/www/nextcloud/>
        Options +FollowSymlinks
        AllowOverride All

        <IfModule mod_dav.c>
            Dav off
        </IfModule>

        SetEnv HOME /var/www/nextcloud
        SetEnv HTTP_HOME /var/www/nextcloud

    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>" | sudo tee /etc/apache2/sites-available/nextcloud.conf

    sudo a2ensite nextcloud.conf
    sudo a2enmod rewrite headers env dir mime
    sudo systemctl restart apache2
}

# Function to configure Apache/HTTPD for CentOS/Arch
configure_httpd() {
    echo "<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/nextcloud/
    ServerName example.com

    <Directory /var/www/nextcloud/>
        Options +FollowSymlinks
        AllowOverride All

        <IfModule mod_dav.c>
            Dav off
        </IfModule>

        SetEnv HOME /var/www/nextcloud
        SetEnv HTTP_HOME /var/www/nextcloud

    </Directory>

    ErrorLog /var/log/httpd/error.log
    CustomLog /var/log/httpd/access.log combined

</VirtualHost>" | sudo tee /etc/httpd/conf.d/nextcloud.conf

    sudo systemctl enable httpd
    sudo systemctl restart httpd
}

# Main script execution
echo "Nextcloud Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install Nextcloud based on the detected distribution
case "$DISTRO" in
    ubuntu|debian)
        install_nextcloud_debian
        ;;
    centos|rhel|rocky|alma)
        install_nextcloud_centos
        ;;
    arch)
        install_nextcloud_arch
        ;;
    *)
        echo "Unsupported distribution!"
        exit 1
        ;;
esac

echo "Nextcloud installed successfully."
