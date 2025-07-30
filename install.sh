#!/bin/bash
# Installation script for Linux

echo "Installing Xray..."

# Copy binary
sudo cp xray /usr/local/bin/
sudo chmod +x /usr/local/bin/xray

# Create config directory
sudo mkdir -p /etc/xray

# Copy service file
sudo cp xray.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

echo "Installation complete!"
echo "To start Xray: sudo systemctl start xray"
echo "To enable at boot: sudo systemctl enable xray"
