# fix-audio-alc245-minisforum-hx370

Comprehensive stability and audio fix for the **Minisforum AI X1 (HX370)** (Standard/Non-PRO series) running **Linux Kernel 7.0 or newer**.

## ⚠️ MANDATORY: GPU Crash Prevention

The Minisforum AI X1 suffers from a critical bug in **Kernel 7.0+** and the **AMD DCN 3.5** display engine that causes **Black Screen crashes** (PC remains powered on, but video output dies) when using external Type-C or HDMI monitors.

This repository provides a **3-Layer Protection** plan specifically tested on **Ubuntu/Debian** based systems to solve these hangs.

### 1. Install Dependencies
You must have `alsa-tools` installed for `hda-verb`.

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt install alsa-tools
```

### 2. Run the Integrated Installer
```bash
git clone https://github.com/skorphil/fix-audio-minisforum-ai-x1-hx370.git
cd fix-audio-minisforum-ai-x1-hx370
sudo bash install.sh
```

The installer will guide you through:
- ✅ **Layer 1:** Fixing the Realtek ALC245 audio codec (Headphone jack detection).
- ✅ **Layer 2:** Disabling HDA power management (Prevents GPU-Audio sync hangs).
- ✅ **Layer 3:** Applying Kernel Parameters (Disables PSR and S/G Display bugs).

### 3. Manual BIOS Step (Crucial)
After running the installer:
1. Reboot and enter **BIOS** (Press `Del` or `F7`).
2. Go to **Advanced > Graphics Configuration**.
3. Set **UMA Frame Buffer Size** to **4GB** or **8GB** (Do not leave it on "Auto").

---

## Verification
Run the included check script to ensure all OS-level mitigations are active:
```bash
bash check-gpu-stability.sh
```

## How it works
The fix addresses the underlying hardware-driver desynchronization on the new Zen 5 architecture by stabilizing power states and reserving a fixed memory pool for the Radeon 890M iGPU. It is specifically aimed at solving stability issues present in the initial support cycle of Kernel 7.0.

## Uninstallation
To remove all changes:
```bash
sudo bash uninstall.sh
```
