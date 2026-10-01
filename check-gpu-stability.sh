#!/bin/bash
# Checks if GPU crash mitigations are active on this system.

echo "=== Minisforum HX370 GPU Stability Check ==="
echo "Report generated on: $(date)"
echo ""

# 1. Check Kernel parameters for GPU
echo -n "[1/3] Checking GPU Kernel Parameters... "
CMDLINE=$(cat /proc/cmdline)
PROTECTED=true

if [[ $CMDLINE == *"amdgpu.dcdebugmask=0x10"* ]]; then
    echo "✓ PSR disabled"
else
    echo "✗ PSR ENABLED (potential crash risk)"
    PROTECTED=false
fi

if [[ $CMDLINE == *"amdgpu.sg_display=0"* ]]; then
    echo "      ✓ S/G Display disabled"
else
    echo "      ✗ S/G Display enabled (potential allocation error risk)"
    PROTECTED=false
fi

# 2. Audio power save
echo -n "[2/3] Checking Audio Power Management... "
if [ -f /sys/module/snd_hda_intel/parameters/power_save ]; then
    VAL=$(cat /sys/module/snd_hda_intel/parameters/power_save)
    if [ "$VAL" = "0" ]; then
        echo "✓ Disabled"
    else
        echo "✗ ENABLED ($VAL sec timeout) - HIGH CRASH RISK"
        PROTECTED=false
    fi
else
    echo "WARN: snd_hda_intel status unknown"
fi

# 3. UMA Buffer check (approximate via lspci)
echo -n "[3/3] Checking VRAM (UMA) Reservation... "
VRAM=$(lspci -v -s $(lspci | grep VGA | cut -d" " -f1) 2>/dev/null | grep -i "memory at" | grep "size=" | head -1 | cut -d"=" -f2 | cut -d" " -f1)
if [[ ! -z "$VRAM" ]]; then
    echo "Detected ~${VRAM}"
    echo "      (Ensure BIOS is set to 4GB or 8GB, not 'Auto')"
else
    echo "Unable to detect via lspci"
fi

echo ""
if [ "$PROTECTED" = true ]; then
    echo "RESULT: System has stability mitigations active."
else
    echo "RESULT: System is VULNERABLE to display hangs."
    echo "Please see KNOWN_ISSUES.md for fix instructions."
fi
