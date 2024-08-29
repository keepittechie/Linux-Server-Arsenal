#!/usr/bin/env bash

####################################
# Librechat Installation Script for Ubuntu Server
# Created by: KeepItTechie
# YouTube Channel: https://youtube.com/@KeepItTechie
# Blog: https://docs.keepittechie.com/
####################################

############################################################
# Script to setup Libre Chat locally on Ubuntu 22.04 server
#
# Author: KeepItTechie
# Version: 1.0
# License: MIT
#
# Usage:
#   1. Save the script to a file, for example, auto-librechat.
#   2. Make the script executable:
#      chmod +x auto-librechat.sh
#   3. Run the script:
#      sudo ./auto-librechat
#
############################################################

# Variables
LIBRECHAT_DIR="/opt/librechat"
SERVICE_USER="librechat"
MONGO_VERSION="7.0.12"
MONGO_DB="librechatdb"
MONGO_USER="librechatuser"
MONGO_PASS=$(openssl rand -base64 12 | tr -d '=+/')
MONGO_URI="mongodb://$MONGO_USER:$MONGO_PASS@localhost:27017/$MONGO_DB"

# Update and install prerequisites
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y gnupg curl git wget openssl

# Import the MongoDB public GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Create a list file for MongoDB
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Reload the local package database
sudo apt-get update

# Install MongoDB packages explicitly
sudo apt-get install -y mongodb-org=$MONGO_VERSION mongodb-org-database=$MONGO_VERSION mongodb-org-server=$MONGO_VERSION mongodb-mongosh-shared-openssl3 mongodb-org-mongos=$MONGO_VERSION mongodb-org-tools=$MONGO_VERSION

# Pin the MongoDB packages to prevent unintended upgrades
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh-shared-openssl3 hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

# Start and enable MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod

# Wait a few seconds to ensure MongoDB is fully started
sleep 10

# Create MongoDB user and database, ensuring it is done correctly
mongosh <<EOF
use $MONGO_DB
db.dropUser("$MONGO_USER")
db.createUser({
  user: "$MONGO_USER",
  pwd: "$MONGO_PASS",
  roles: [{ role: "readWrite", db: "$MONGO_DB" }]
})
EOF

# Install Node.js 18.x (which includes npm)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node -v
npm -v

# Create service account for LibreChat
sudo adduser --system --home /home/librechat --group $SERVICE_USER
sudo mkdir -p /home/librechat
sudo chown -R $SERVICE_USER:$SERVICE_USER /home/librechat

# Clone LibreChat repository and move it to /opt/librechat
git clone https://github.com/danny-avila/LibreChat.git
sudo mv LibreChat $LIBRECHAT_DIR

# Set ownership of LibreChat directory
sudo chown -R $SERVICE_USER:$SERVICE_USER $LIBRECHAT_DIR

# Navigate to LibreChat directory
cd $LIBRECHAT_DIR

# Create .env file from .env.example
sudo -u $SERVICE_USER cp .env.example .env

# Update the .env file with the MongoDB URI
sudo -u $SERVICE_USER sed -i "s|MONGO_URI=.*|MONGO_URI=$MONGO_URI|" .env

# Replace localhost with the server's IP address in the .env file for HOST, DOMAIN_CLIENT, and DOMAIN_SERVER
SERVER_IP=$(hostname -I | awk '{print $1}')
sudo -u $SERVICE_USER sed -i "s|HOST=localhost|HOST=$SERVER_IP|" $LIBRECHAT_DIR/.env
sudo -u $SERVICE_USER sed -i "s|http://localhost|http://$SERVER_IP|g" $LIBRECHAT_DIR/.env

# Install dependencies using npm ci
sudo -u $SERVICE_USER HOME=/home/librechat npm ci

# Build the frontend
sudo -u $SERVICE_USER HOME=/home/librechat npm run frontend

# Optional: Create systemd service for LibreChat to start automatically
sudo tee /etc/systemd/system/librechat.service > /dev/null <<EOF
[Unit]
Description=LibreChat Service
After=network.target

[Service]
Type=simple
WorkingDirectory=$LIBRECHAT_DIR
ExecStart=/usr/bin/npm run backend
Restart=on-failure
RestartSec=10s
User=$SERVICE_USER
Group=$SERVICE_USER
Environment=PATH=/usr/bin:/usr/local/bin
Environment=NODE_ENV=production
Environment=HOME=/home/librechat

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to register the new service
sudo systemctl daemon-reload
sudo systemctl enable librechat.service

echo "LibreChat installation and setup complete!"
echo "Access LibreChat at http://$SERVER_IP:3080/"
echo "MongoDB User: $MONGO_USER"
echo "MongoDB Password: $MONGO_PASS"
echo "MongoDB URI: $MONGO_URI"
echo "To start the LibreChat service, run: sudo systemctl start librechat.service"
