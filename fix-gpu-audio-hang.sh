#!/bin/bash
# Prevents AMD GPU + audio power management conflicts on HX370
# This addresses the "Black Screen while PC stays on" issue.

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

echo "=== Applying GPU Audio Hang Prevention ==="

# 1. Immediate Runtime Fix
if [ -d /sys/module/snd_hda_intel/parameters ]; then
    echo 0 > /sys/module/snd_hda_intel/parameters/power_save
    echo "✓ Disabled HDA Intel power saving (runtime)"
else
    echo "✗ snd_hda_intel module not loaded?"
fi

# 2. Persistent Modprobe Configuration
MODPROBE_CONF="/etc/modprobe.d/minisforum-hx370-audio.conf"
echo "options snd_hda_intel power_save=0" > "$MODPROBE_CONF"
echo "✓ Created persistent modprobe config: $MODPROBE_CONF"

# 3. Update Initramfs
if command -v update-initramfs >/dev/null; then
    echo "Updating initramfs... (this may take a moment)"
    update-initramfs -u
    echo "✓ Initramfs updated."
else
    echo "⚠ 'update-initramfs' not found. Please update your initrd manually if necessary."
fi

echo ""
echo "Done. It is recommended to reboot to ensure all changes are active."
