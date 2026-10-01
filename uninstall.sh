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

# Remove scripts
rm -f /usr/local/bin/fix-audio-alc245.sh
rm -f /usr/local/bin/fix-gpu-audio-hang.sh
rm -f /usr/local/bin/fix-gpu-grub-params.sh
rm -f /usr/local/bin/check-gpu-stability.sh

# Note: GRUB parameters in /etc/default/grub are NOT automatically reverted.
# Please remove them manually if desired.

# Remove persistent configs
rm -f /etc/modprobe.d/minisforum-hx370-audio.conf
if command -v update-initramfs >/dev/null; then
    update-initramfs -u
fi

# Reload systemd
systemctl daemon-reload

echo "Uninstallation complete."
