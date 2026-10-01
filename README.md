# fix-audio-alc245-minisforum-hx370

Fixes silent/broken audio and headphone jack detection on the **Minisforum AI X1 (HX370)** (not PRO) with the **Realtek ALC245** codec.

This repository provides a set of scripts and systemd services to apply the correct vendor-specific codec coefficients at runtime, restoring full functionality to the audio output and automatic jack detection.

## Problem Statement

**What is happening:**
On Linux, the Minisforum AI X1 (HX370) suffers from completely silent audio or non-functional headphone jack detection, even when the sound card is recognized by the system. While the speakers might work in some cases, the headphone jack is often "stuck" in an unplugged state or produces no sound when connected.

**The Reason:**
The Realtek ALC245 codec used in this machine requires specific vendor-defined initialization coefficients (COEFs) to correctly route audio to the internal amplifiers and enable the jack detection sensor. Standard Linux drivers do not include these specific mappings for the Minisforum AI X1 subsystem ID (`1f4c:b022`).

**Who to blame:**
- **Minisforum:** For using a non-standard implementation without providing the necessary initialization data to the upstream Linux kernel/ALSA maintainers.
- **Realtek:** For the opaque nature of their codec coefficients, which makes it nearly impossible for the community to fix these issues without reverse engineering or trial-and-error.

## Overview

The Minisforum AI X1 (HX370) audio issue stems from missing vendor-specific codec coefficients that control internal routing and amplifiers for the headphone DAC. Applying these coefficients correctly initializes the hardware, enabling both the audio output path and the physical jack detection sensor.

**Result:** This fix restores **full automatic jack detection and audio switching** between speakers and headphones.

### System Specifications
- **Hardware:** Minisforum AI X1 (HX370)
- **Processor:** AMD Ryzen AI 9 HX 370
- **Audio Codec:** Realtek ALC245
- **Subsystem ID:** `1f4c:b022`

> **Note:** This solution was developed with AI assistance to identify and verify the correct register mappings for the ALC245 codec on this specific hardware.

## How it works

The core of the fix is a shell script that uses `hda-verb` to write specific coefficients to the ALC245 codec:
1. It locates the correct card device in `/dev/snd/`.
2. It writes the necessary processing coefficients (verbs 0x06 through 0x67).
3. It resets the GPIO state.

Two systemd services ensure the fix is applied:
- `fix-audio-alc245.service`: Runs at boot.
- `fix-audio-alc245-resume.service`: Runs after waking from sleep/suspend.

## Installation

### 1. Install Dependencies
You must have `alsa-tools` installed for `hda-verb`.

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install alsa-tools
```

**Arch Linux:**
```bash
sudo pacman -S alsa-tools
```

**Fedora:**
```bash
sudo dnf install alsa-tools
```

### 2. Clone and Install
```bash
git clone https://github.com/skorphil/fix-audio-minisforum-ai-x1-hx370.git
cd fix-audio-minisforum-ai-x1-hx370
sudo bash install.sh
```

## Manual Verification

After installation, you can verify the fix is working:

1. **Check Service Status:**
   ```bash
   systemctl status fix-audio-alc245.service
   ```
2. **Automatic Detection:** Plug in your headphones. The system should automatically detect the device and switch output.
3. **Check Jack State:**
   ```bash
   amixer -c2 contents | grep -A 2 "Headphone Jack"
   ```
   *(Note: replace `-c2` with your actual card number if different)*
4. **Test Audio:**
   ```bash
   speaker-test -c 2 -t wav -l 1
   ```

## Uninstallation

To remove the fix and its services:
```bash
sudo bash uninstall.sh
```

## Credits & References

Derived from community research and specialized fixes for the ALC245 codec:
- [checor/fix-audio-alc245-minisforum](https://github.com/checor/fix-audio-alc245-minisforum) (Similar solution for Minisforum X1 *PRO*)
- [NixOS Issue #1829](https://github.com/NixOS/nixos-hardware/issues/1829)
- [puffo/minisforum-audio-fix](https://github.com/puffo/minisforum-audio-fix)

## License
MIT
