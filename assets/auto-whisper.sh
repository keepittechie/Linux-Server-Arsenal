#!/usr/bin/env bash

####################################
# Whisper Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Open AI Whisper
# on Ubuntu servers for translation.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-whisper.sh.
#   2. Make the script executable:
#      chmod +x auto-whisper.sh
#   3. Run the script:
#      sudo ./auto-whisper.sh
#
############################################################

# Function to print an error message and exit
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Check if python3.12-venv is installed
if ! dpkg -l | grep -q python3.12-venv; then
    echo "python3.12-venv is not installed. Installing it now..."
    sudo apt update
    sudo apt install -y python3.12-venv || error_exit "Failed to install python3.12-venv. Exiting."
fi

# Ensure ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg could not be found. Installing ffmpeg..."
    sudo apt install -y ffmpeg || error_exit "Failed to install ffmpeg. Exiting."
fi

# Check available disk space in /opt
REQUIRED_SPACE_MB=500 # Example value, adjust as needed
AVAILABLE_SPACE_MB=$(df /opt | awk 'NR==2 {print $4 / 1024}')
if (( $(echo "$AVAILABLE_SPACE_MB < $REQUIRED_SPACE_MB" | bc -l) )); then
    error_exit "Insufficient disk space in /opt. At least $REQUIRED_SPACE_MB MB required. Exiting."
fi

# Define the installation directory
INSTALL_DIR="/opt/whisper"

# Create the directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating installation directory at $INSTALL_DIR..."
    sudo mkdir -p "$INSTALL_DIR" || error_exit "Failed to create directory $INSTALL_DIR. Exiting."
fi

# Check if the virtual environment directory exists
if [ ! -d "$INSTALL_DIR/venv" ]; then
    echo "Creating a virtual environment in $INSTALL_DIR/venv..."
    sudo python3.12 -m venv "$INSTALL_DIR/venv" || error_exit "Failed to create the virtual environment. Exiting."
fi

# Verify that the virtual environment was created successfully
if [ ! -f "$INSTALL_DIR/venv/bin/activate" ]; then
    error_exit "Virtual environment setup failed. The activate script was not found."
fi

# Activate the virtual environment
echo "Activating the virtual environment..."
source "$INSTALL_DIR/venv/bin/activate" || error_exit "Failed to activate the virtual environment. Exiting."

# Upgrade pip in the virtual environment
echo "Upgrading pip..."
"$INSTALL_DIR/venv/bin/pip" install --upgrade pip || error_exit "Failed to upgrade pip. Exiting."

# Install all dependencies at once
echo "Installing all dependencies..."
"$INSTALL_DIR/venv/bin/pip" install --upgrade setuptools-rust tqdm numpy regex torch torchvision torchaudio tiktoken openai-whisper || error_exit "Failed to install dependencies. Exiting."

# Verify the installation
echo "Verifying Whisper installation..."
"$INSTALL_DIR/venv/bin/whisper" --help
if [ $? -eq 0 ]; then
    echo "Whisper installed or updated successfully."
else
    echo "Whisper installation or update failed."
    exit 1
fi

# Set permissions for all users to use the Whisper installation
echo "Setting permissions for $INSTALL_DIR..."
sudo chmod -R a+rx "$INSTALL_DIR" || error_exit "Failed to set permissions for $INSTALL_DIR. Exiting."

# Clear pip cache to free up space
echo "Clearing pip cache..."
"$INSTALL_DIR/venv/bin/pip" cache purge || error_exit "Failed to clear pip cache. Exiting."

# Deactivate the virtual environment
deactivate || error_exit "Failed to deactivate the virtual environment. Exiting."

echo "Installation complete. Whisper is available at $INSTALL_DIR/venv/bin/whisper"
