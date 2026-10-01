#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

echo "Uninstalling fix-audio-alc245..."

# Stop and disable services
systemctl stop fix-audio-alc245.service || true
systemctl disable fix-audio-alc245.service || true
systemctl disable fix-audio-alc245-resume.service || true

# Remove service files
rm -f /etc/systemd/system/fix-audio-alc245.service
rm -f /etc/systemd/system/fix-audio-alc245-resume.service

# Remove script
rm -f /usr/local/bin/fix-audio-alc245.sh

# Reload systemd
systemctl daemon-reload

echo "Uninstallation complete."
