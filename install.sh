#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

echo "Installing fix-audio-alc245..."

# Install script
cp fix-audio-alc245.sh /usr/local/bin/
chmod +x /usr/local/bin/fix-audio-alc245.sh

# Install services
cp fix-audio-alc245.service /etc/systemd/system/
cp fix-audio-alc245-resume.service /etc/systemd/system/

# Reload systemd
systemctl daemon-reload

# Enable and start services
systemctl enable fix-audio-alc245.service
systemctl start fix-audio-alc245.service
systemctl enable fix-audio-alc245-resume.service

echo "Installation complete. Audio fix applied and persistent."
