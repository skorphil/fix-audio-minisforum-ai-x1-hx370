#!/bin/bash
# Installer for Minisforum AI X1 (HX370) Audio & GPU Stability Fixes

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

echo "=========================================================="
echo "   Minisforum AI X1 (HX370) Stability & Audio Fixer"
echo "=========================================================="
echo ""

# 1. Core Audio Codec Fix (Internal Speakers/Jack)
echo "[Step 1/3] Installing ALC245 Audio Codec Fix..."
cp fix-audio-alc245.sh /usr/local/bin/
cp fix-gpu-audio-hang.sh /usr/local/bin/
cp fix-gpu-grub-params.sh /usr/local/bin/
cp check-gpu-stability.sh /usr/local/bin/
chmod +x /usr/local/bin/fix-audio-alc245.sh
chmod +x /usr/local/bin/fix-gpu-audio-hang.sh
chmod +x /usr/local/bin/fix-gpu-grub-params.sh
chmod +x /usr/local/bin/check-gpu-stability.sh

cp fix-audio-alc245.service /etc/systemd/system/
cp fix-audio-alc245-resume.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable fix-audio-alc245.service
systemctl start fix-audio-alc245.service
systemctl enable fix-audio-alc245-resume.service
echo "✓ Audio codec services installed and enabled."
echo ""

# 2. Audio Power Management Fix
echo "[Step 2/3] Applying GPU Audio Hang Prevention..."
echo "This prevents display hangs triggered by Type-C/HDMI audio events."
read -p "Apply audio power management fix? [Y/n] " audio_resp
if [[ "$audio_resp" =~ ^[Yy]$ ]] || [[ -z "$audio_resp" ]]; then
    bash /usr/local/bin/fix-gpu-audio-hang.sh
fi
echo ""

# 3. Kernel Parameter Fixes
echo "[Step 3/3] Applying GPU Kernel Parameter Fixes..."
echo "This disables PSR and Scatter-Gather to prevent black screen lockups."
read -p "Apply GRUB/Kernel parameter fixes? [Y/n] " grub_resp
if [[ "$grub_resp" =~ ^[Yy]$ ]] || [[ -z "$grub_resp" ]]; then
    bash /usr/local/bin/fix-gpu-grub-params.sh
fi

echo ""
echo "=========================================================="
echo "               FINAL STEP: BIOS CONFIGURATION"
echo "=========================================================="
echo "To ensure 100% stability, you MUST manually adjust BIOS settings:"
echo ""
echo "1. Reboot and enter BIOS (Del/F7)"
echo "2. Navigate to: Advanced > Graphics Configuration"
echo "3. Change 'UMA Frame Buffer Size' from 'Auto' to '4GB' or '8GB'"
echo ""
echo "After rebooting, run 'check-gpu-stability.sh' to verify."
echo "=========================================================="
echo ""

read -p "Would you like to run the stability check now? [y/N] " check_resp
if [[ "$check_resp" =~ ^[Yy]$ ]]; then
    bash /usr/local/bin/check-gpu-stability.sh
fi

echo "Done."
