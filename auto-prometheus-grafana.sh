#!/usr/bin/env bash

####################################
# Prometheus and Grafana Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Prometheus and Grafana
# on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-prometheus-grafana.sh.
#   2. Make the script executable:
#      chmod +x auto-prometheus-grafana.sh
#   3. Run the script:
#      sudo ./auto-prometheus-grafana.sh
#
############################################################

# Function to install Prometheus
install_prometheus() {
    useradd --no-create-home --shell /bin/false prometheus
    mkdir /etc/prometheus
    mkdir /var/lib/prometheus
    wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
    tar -xvf prometheus-2.26.0.linux-amd64.tar.gz
    cp prometheus-2.26.0.linux-amd64/prometheus /usr/local/bin/
    cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
    cp -r prometheus-2.26.0.linux-amd64/consoles /etc/prometheus
    cp -r prometheus-2.26.0.linux-amd64/console_libraries /etc/prometheus
    cp prometheus-2.26.0.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml
    chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
    echo "[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus/

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/prometheus.service
    systemctl daemon-reload
    systemctl enable prometheus
    systemctl start prometheus
}

# Function to install Grafana
install_grafana() {
    wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
    add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
    apt update
    apt install -y grafana
    systemctl enable grafana-server
    systemctl start grafana-server
}

# Main script execution
echo "Prometheus and Grafana Installation for Ubuntu Server"
install_prometheus
install_grafana

echo "Prometheus and Grafana installed successfully."
