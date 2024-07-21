#!/usr/bin/env bash

####################################
# Nextcloud Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Nextcloud on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
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

# Function to install Nextcloud
install_nextcloud() {
    apt update
    apt install -y apache2 mariadb-server libapache2-mod-php7.4 \
                   php7.4-gd php7.4-json php7.4-mysql php7.4-curl \
                   php7.4-mbstring php7.4-intl php-imagick php7.4-xml \
                   php7.4-zip
    wget https://download.nextcloud.com/server/releases/nextcloud-20.0.4.zip
    unzip nextcloud-20.0.4.zip -d /var/www/
    chown -R www-data:www-data /var/www/nextcloud/
    chmod -R 755 /var/www/nextcloud/
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

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>" > /etc/apache2/sites-available/nextcloud.conf
    a2ensite nextcloud.conf
    a2enmod rewrite headers env dir mime
    systemctl restart apache2
}

# Main script execution
echo "Nextcloud Installation for Ubuntu Server"
install_nextcloud

echo "Nextcloud installed successfully."
