#!/usr/bin/env bash

####################################
# Apache Kafka Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Apache Kafka on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-apache-kafka.sh.
#   2. Make the script executable:
#      chmod +x auto-apache-kafka.sh
#   3. Run the script:
#      sudo ./auto-apache-kafka.sh
#
############################################################

# Function to install Apache Kafka
install_kafka() {
    apt update
    apt install -y default-jdk zookeeperd
    wget https://downloads.apache.org/kafka/2.8.0/kafka_2.13-2.8.0.tgz
    tar -xzf kafka_2.13-2.8.0.tgz
    mv kafka_2.13-2.8.0 /usr/local/kafka
    echo "export PATH=$PATH:/usr/local/kafka/bin" >> ~/.bashrc
    source ~/.bashrc
}

# Main script execution
echo "Apache Kafka Installation for Ubuntu Server"
install_kafka

echo "Apache Kafka installed successfully."
