#!/usr/bin/env bash

####################################
# System Benchmark Installation & Run Script for Debian, CentOS/RHEL, and Arch
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of a system benchmark tool (sysbench) 
# and runs a general CPU, memory, and I/O benchmark for Debian, CentOS/RHEL, 
# and Arch-based systems. If sysbench is already installed, it will skip 
# installation and run the benchmark.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, benchmark.sh.
#   2. Make the script executable:
#      chmod +x benchmark.sh
#   3. Run the script:
#      sudo ./benchmark.sh
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

# Function to install sysbench on Debian/Ubuntu
install_sysbench_debian() {
    sudo apt update
    sudo apt install -y sysbench
}

# Function to install sysbench on CentOS/RHEL
install_sysbench_centos() {
    sudo dnf install -y epel-release
    sudo dnf install -y sysbench
}

# Function to install sysbench on Arch
install_sysbench_arch() {
    sudo pacman -Sy --noconfirm sysbench
}

# Function to run benchmark
run_benchmark() {
    echo "Running CPU Benchmark..."
    sysbench cpu --cpu-max-prime=20000 run

    echo "Running Memory Benchmark..."
    sysbench memory run

    echo "Running Disk I/O Benchmark..."
    sysbench fileio --file-total-size=1G prepare
    sysbench fileio --file-total-size=1G --file-test-mode=rndrw run
    sysbench fileio --file-total-size=1G cleanup
}

# Function to check if sysbench is installed
check_sysbench_installed() {
    if command -v sysbench &> /dev/null; then
        echo "Sysbench is already installed."
        return 0
    else
        return 1
    fi
}

# Main script execution
echo "System Benchmark Installation & Run Script for Debian, CentOS/RHEL, and Arch"

# Detect the distro
detect_distro

# Install sysbench if it's not already installed
if check_sysbench_installed; then
    echo "Proceeding to run benchmark..."
else
    case "$DISTRO" in
        ubuntu|debian)
            echo "Installing sysbench on Debian/Ubuntu..."
            install_sysbench_debian
            ;;
        centos|rhel|rocky|alma)
            echo "Installing sysbench on CentOS/RHEL..."
            install_sysbench_centos
            ;;
        arch)
            echo "Installing sysbench on Arch..."
            install_sysbench_arch
            ;;
        *)
            echo "Unsupported distribution!"
            exit 1
            ;;
    esac
    echo "Sysbench installed successfully."
fi

# Run the benchmark
run_benchmark

echo "Benchmark completed."
