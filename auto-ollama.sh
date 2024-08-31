#!/usr/bin/env bash

####################################
# Docker, Ollama, and Open WebUI Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# This script automates the installation of Node.js and NPM
# on Ubuntu servers.
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-ollama.sh.
#   2. Make the script executable:
#      chmod +x auto-ollama.sh
#   3. Run the script:
#      sudo ./auto-ollama.sh
#
############################################################

set -eu

status() { echo ">>> $*" >&2; }
error() { echo "ERROR $*"; exit 1; }

# Ensure necessary tools are available
NEEDS="curl awk grep sed tee xargs"
MISSING_TOOLS=""

for TOOL in $NEEDS; do
    if ! command -v "$TOOL" > /dev/null 2>&1; then
        MISSING_TOOLS="$MISSING_TOOLS $TOOL"
    fi
done

if [ -n "$MISSING_TOOLS" ]; then
    status "ERROR: The following tools are required but missing:"
    for TOOL in $MISSING_TOOLS; do
        echo "  - $TOOL"
    done
    exit 1
fi

# Install Docker on Ubuntu 24.04
status "Installing Docker..."

# Set up Docker's apt repository
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify Docker installation
sudo docker run hello-world

status "Docker installation complete."

# Install Ollama
status "Installing Ollama..."
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) error "Unsupported architecture: $ARCH" ;;
esac

for BINDIR in /usr/local/bin /usr/bin /bin; do
    echo "$PATH" | grep -q "$BINDIR" && break || continue
done
OLLAMA_INSTALL_DIR=$(dirname ${BINDIR})

sudo install -o0 -g0 -m755 -d $BINDIR
sudo install -o0 -g0 -m755 -d "$OLLAMA_INSTALL_DIR"
if curl -I --silent --fail --location "https://ollama.com/download/ollama-linux-${ARCH}.tgz" >/dev/null ; then
    status "Downloading Linux ${ARCH} bundle"
    curl --fail --show-error --location --progress-bar \
        "https://ollama.com/download/ollama-linux-${ARCH}.tgz" | \
        sudo tar -xzf - -C "$OLLAMA_INSTALL_DIR"
    if [ "$OLLAMA_INSTALL_DIR/bin/ollama" != "$BINDIR/ollama" ] ; then
        status "Making Ollama accessible in the PATH in $BINDIR"
        sudo ln -sf "$OLLAMA_INSTALL_DIR/ollama" "$BINDIR/ollama"
    fi
else
    error "Failed to download Ollama. Please check the URL or your network connection."
fi

status 'The Ollama API is now available at 127.0.0.1:11434.'
status 'Ollama installation complete. Run "ollama" from the command line.'

# Run Open WebUI with Docker and bundled Ollama support
status "Setting up Open WebUI with Docker and bundled Ollama support..."

# Choose the appropriate command based on your hardware (CPU-only or GPU support)
# For GPU support, uncomment the following line:
# docker run -d -p 3000:8080 --gpus=all -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama

# For CPU-only, use this command:
docker run -d -p 3000:8080 -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama

status "Open WebUI is now running on http://<your-server-ip>:3000."
status "Combined installation complete."
