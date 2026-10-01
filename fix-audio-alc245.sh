#!/bin/bash
# Fixes ALC245 audio codec on Minisforum HX370
# by writing the correct verb coefficients at runtime via hda-verb.

set -euo pipefail

# Find the card number for the ALC245 codec
DEV=$(grep -rl "ALC245" /proc/asound/card*/codec#0 2>/dev/null \
    | grep -o 'card[0-9]*' | head -1 \
    | sed 's/card/\/dev\/snd\/hwC/' | sed 's/$/D0/')

if [[ -z "$DEV" || ! -e "$DEV" ]]; then
    echo "ERROR: ALC245 device not found"
    exit 1
fi

set_coef() {
    hda-verb "$DEV" 0x20 SET_COEF_INDEX "$1" > /dev/null
    hda-verb "$DEV" 0x20 SET_PROC_COEF  "$2" > /dev/null
}

echo "Applying ALC245 working coefficients to $DEV..."

# Apply ALC245 working coefficients
set_coef 0x06 0xe115
set_coef 0x08 0x6a08
set_coef 0x0f 0x00c2
set_coef 0x1a 0x8c03
set_coef 0x1b 0x4a4b
set_coef 0x45 0xd689
set_coef 0x46 0x00f4
set_coef 0x49 0x0249
set_coef 0x4a 0x21f0
set_coef 0x63 0x0000
set_coef 0x67 0x3000

# Reset GPIO to clean state
hda-verb "$DEV" 0x01 SET_GPIO_MASK      0x00 > /dev/null
hda-verb "$DEV" 0x01 SET_GPIO_DIRECTION 0x00 > /dev/null
hda-verb "$DEV" 0x01 SET_GPIO_DATA      0x00 > /dev/null

echo "Done."
