#!/usr/bin/env bash

####################################
# Prometheus and Grafana Installation Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Prometheus and Grafana
# on Debian, CentOS/RHEL, and Arch-based systems.
#
# Author: KeepItTechie
# Version: 2.0
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

    # Create systemd service file for Prometheus
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

# Function to install Grafana for Debian/Ubuntu
install_grafana_debian() {
    wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
    sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
    sudo apt update
    sudo apt install -y grafana
    sudo systemctl enable grafana-server
    sudo systemctl start grafana-server
}

# Function to install Grafana for CentOS/RHEL
install_grafana_centos() {
    sudo dnf install -y https://dl.grafana.com/oss/release/grafana-8.2.5-1.x86_64.rpm
    sudo systemctl enable grafana-server
    sudo systemctl start grafana-server
}

# Function to install Grafana for Arch
install_grafana_arch() {
    sudo pacman -Sy --noconfirm grafana
    sudo systemctl enable grafana
    sudo systemctl start grafana
}

# Main script execution
echo "Prometheus and Grafana Installation for Debian, CentOS/RHEL, and Arch"

# Detect the distribution
detect_distro

# Install Prometheus (same for all distributions)
install_prometheus

# Install Grafana based on the detected distribution
case "$DISTRO" in
    ubuntu|debian)
        install_grafana_debian
        ;;
    centos|rhel|rocky|alma)
        install_grafana_centos
        ;;
    arch)
        install_grafana_arch
        ;;
    *)
        echo "Unsupported distribution!"
        exit 1
        ;;
esac

echo "Prometheus and Grafana installed successfully."
