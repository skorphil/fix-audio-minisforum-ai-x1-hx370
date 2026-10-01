# Known Issues: Minisforum AI X1 (HX370)

## ⚠️ Critical: Display Hang When Using External Monitors

### Symptoms
- Monitors go completely black while the PC remains powered on (fans spinning, LEDs on).
- System becomes unresponsive to keyboard/mouse input.
- Occurs primarily when using **Type-C or HDMI displays** that also handle audio.

### Root Cause
The AMD Ryzen AI 9 HX 370 uses the new **DCN 3.5** display engine. In Linux kernels **7.0 and newer**, there is a severe synchronization bug between the GPU's display core and its integrated HDMI/DP audio bridge. 

The three primary failure modes are:
1. **DMCUB Hang:** Audio power events crash the display microcontroller.
2. **Allocation Failure:** Scatter-Gather display support causes "negative allocation" errors in GNOME/Wayland.
3. **PSR Bug:** Panel Self Refresh fails to wake the display output.

### The Comprehensive Solution
The `install.sh` script in this repository automates the OS-level fixes:

1. **Audio Power Fix:** Disables `snd_hda_intel` power saving to keep the GPU audio bridge active.
2. **GRUB Parameters:**
    - `amdgpu.dcdebugmask=0x10` (Disables PSR)
    - `amdgpu.sg_display=0` (Prevents Scatter-Gather allocation errors)
    - `amdgpu.gpu_recovery=1` (Enables driver reset on hang)
3. **BIOS UMA:** Fixing the Frame Buffer size ensures a stable memory pool for the Radeon 890M.

### References
* [GNOME GitLab #3515](https://gitlab.gnome.org/GNOME/gnome-shell/-/work_items/3515) - Allocation errors.
* [Ubuntu Bug #2167096](https://bugs.launchpad.net/ubuntu/+source/linux-hwe-7.0/+bug/2167096) - AMD DCN 3.5 GPU hangs.
