# Research: AMD GPU Stability on Minisforum AI X1 (HX370)
**Document Revision:** 1.0
**Target Hardware:** AMD Ryzen AI 9 HX370 / Radeon 890M (DCN 3.5)
**Target Kernel:** Linux 7.0 and newer

## 1. Issue Overview: The "Black Screen" Hang
Users of the Minisforum AI X1 (Standard/Non-PRO) have reported unexpected system hangs where monitors go black, but the PC remains powered on (fans spinning, LEDs active). This typically occurs during or after audio/video activity, or when using external Type-C/HDMI monitors.

## 2. Root Cause Analysis
Research indicates a hard lockup of the **AMD Display Core (DCN 3.5)**. This is not a hardware failure but a driver-firmware synchronization bug prevalent in early Linux 7.0+ kernels.

### 2.1 Trigger Mechanisms
1.  **DMCUB (Display Microcontroller) De-sync:** The display engine fails to coordinate with the integrated HDMI/DP audio bridge during power state transitions (e.g., stopping a video stream).
2.  **Memory Allocation Corruption:** The "Scatter-Gather" (S/G) display feature may attempt to allocate buffers with invalid (negative) coordinates, leading to a terminal GNOME Shell/Wayland crash.
3.  **Panel Self Refresh (PSR) Failure:** The aggressive power-saving PSR feature fails to wake the display pipeline from an idle state.
4.  **UMA Buffer Instability:** Dynamic VRAM allocation ("Auto" in BIOS) creates race conditions for the driver during high-load transitions.

## 3. Evidence from System Logs
During a crash event, the following error signatures are common in `journalctl`:

*   **Coordinate Corruption:**
    `gnome-shell: Actor 'unnamed [StBin]' tried to allocate a size of -2147483648.00 x -2147483648.00`
*   **Audio Backend Stall:**
    `gsd-media-keys: Unable to get default sink`
*   **I/O Freeze:**
    Sudden log silence followed by journal corruption messages upon reboot.

## 4. Mitigation & Resolution Strategy
A 3-layer approach is required to fully stabilize the platform:

### Layer 1: BIOS Configuration (Hardware Level)
The integrated GPU requires a reserved, stable memory pool.
*   **Action:** Set `UMA Frame Buffer Size` to a fixed value (**4GB** or **8GB**) instead of "Auto".

### Layer 2: Audio Power Management (Driver Level)
Preventing the audio bridge from entering low-power states avoids the DMCUB hang.
*   **Action:** Disable `snd_hda_intel` power saving (`power_save=0`).

### Layer 3: Kernel Workarounds (Boot Level)
Disabling unstable display features at the kernel level.
*   **Parameters:**
    *   `amdgpu.dcdebugmask=0x10`: Disables unstable PSR.
    *   `amdgpu.sg_display=0`: Disables Scatter-Gather to prevent allocation crashes.
    *   `amdgpu.gpu_recovery=1`: Allows the driver to attempt a reset if a hang occurs.

## 5. References & Community Tracking
*   **GNOME GitLab #3515:** [ClutterActor Allocation Errors](https://gitlab.gnome.org/GNOME/gnome-shell/-/work_items/3515)
*   **Ubuntu Bug #2167096:** [AMD DCN 3.5 GPU Hangs](https://bugs.launchpad.net/ubuntu/+source/linux-hwe-7.0/+bug/2167096)
*   **Phoronix:** [AMD Strix Point Linux Support Analysis](https://www.phoronix.com/review/amd-ryzen-ai-9-hx-370)
