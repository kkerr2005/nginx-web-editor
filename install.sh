#!/bin/bash

# Update package lists
sudo apt-get update

# Install Nginx
sudo apt-get install -y nginx

# Install PowerShell
sudo apt-get install -y wget apt-transport-https software-properties-common
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell

# Install Pode.Web
pwsh -Command "Install-Module -Name Pode.Web -Force -Scope AllUsers"

# Install other dependencies if any
# Add commands to install other dependencies here

echo "Installation complete. You can now run the Pode.Web application."