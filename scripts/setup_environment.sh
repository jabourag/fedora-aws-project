#!/bin/bash
# Description: Automated deployment script for Fedora Lane Hardened Image tools

echo "Installing Web Console, Session Recording, and Container Management..."
sudo dnf install -y cockpit cockpit-session-recording tlog podman cockpit-podman

echo "Enabling Web Console Service..."
sudo systemctl enable --now cockpit.socket

echo "Configuring SSH for Port 2222..."
sudo sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
sudo semanage port -a -t ssh_port_t -p tcp 2222
sudo systemctl restart sshd

echo "Deployment complete. Web console available locally at port 9090."
