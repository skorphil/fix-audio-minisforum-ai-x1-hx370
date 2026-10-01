#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

echo "Installing fix-audio-alc245..."

# Install scripts
cp fix-audio-alc245.sh /usr/local/bin/
cp fix-gpu-audio-hang.sh /usr/local/bin/
cp check-gpu-stability.sh /usr/local/bin/
chmod +x /usr/local/bin/fix-audio-alc245.sh
chmod +x /usr/local/bin/fix-gpu-audio-hang.sh
chmod +x /usr/local/bin/check-gpu-stability.sh

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
echo ""
echo "=== GPU Stability Check ==="
echo "Users of external Type-C/HDMI monitors are at risk of system hangs."
read -p "Would you like to apply the GPU audio hang prevention now? [Y/n] " response
if [[ "$response" =~ ^[Yy]$ ]] || [[ -z "$response" ]]; then
    bash /usr/local/bin/fix-gpu-audio-hang.sh
fi

echo ""
echo "Recommended: Run 'check-gpu-stability.sh' to verify your configuration."
