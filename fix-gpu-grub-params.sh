#!/bin/bash
# Safely adds GPU stability parameters to /etc/default/grub
# This prevents black screen hangs on Ryzen AI 9 HX370 (DCN 3.5)

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

GRUB_FILE="/etc/default/grub"
PARAMS=("amdgpu.dcdebugmask=0x10" "amdgpu.sg_display=0" "amdgpu.gpu_recovery=1")

echo "=== Applying GPU Kernel Parameter Fixes ==="

# Backup original file
cp "$GRUB_FILE" "${GRUB_FILE}.bak_$(date +%Y%m%d_%H%M%S)"

# Load current line
CURRENT_CMDLINE=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" "$GRUB_FILE" | cut -d'"' -f2)
NEW_CMDLINE="$CURRENT_CMDLINE"

MODIFIED=false
for PARAM in "${PARAMS[@]}"; do
    if [[ $CURRENT_CMDLINE != *"$PARAM"* ]]; then
        NEW_CMDLINE="$NEW_CMDLINE $PARAM"
        echo "✓ Adding parameter: $PARAM"
        MODIFIED=true
    else
        echo "- Parameter already exists: $PARAM"
    fi
done

if [ "$MODIFIED" = true ]; then
    # Clean up double spaces
    NEW_CMDLINE=$(echo "$NEW_CMDLINE" | sed 's/  */ /g' | sed 's/^ //')
    # Update the file
    sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"$NEW_CMDLINE\"|" "$GRUB_FILE"
    
    echo "✓ Updated $GRUB_FILE"
    
    if command -v update-grub >/dev/null; then
        echo "Updating GRUB configuration... (this may take a moment)"
        update-grub
        echo "✓ GRUB updated."
    else
        echo "⚠ 'update-grub' not found. Please update your bootloader manually."
    fi
else
    echo "No changes needed to GRUB."
fi

echo ""
echo "Done. Changes will take effect after the next reboot."
