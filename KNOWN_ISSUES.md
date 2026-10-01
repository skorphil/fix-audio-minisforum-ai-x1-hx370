# Known Issues: Minisforum AI X1 (HX370)

## ⚠️ Critical: Display Hang When Using External Monitors

### Symptoms
- Monitors go completely black while the PC remains powered on (fans spinning, LEDs on).
- System becomes unresponsive to keyboard/mouse input.
- Occurs primarily when using **Type-C or HDMI displays** that also handle audio.

### Root Cause
The AMD Ryzen AI 9 HX 370 uses the new **DCN 3.5** display engine. In Linux kernels around **7.0.x**, there is a severe synchronization bug between the GPU's display core and its integrated HDMI/DP audio bridge. Power management events in the audio stream (e.g., stopping a video or entering/waking from sleep) can cause a hard lockup of the display microcontroller (DMCUB).

### Verified Solutions
To stabilize your system, apply the following three layers of fixes:

1.  **BIOS Adjustment:** Set **UMA Frame Buffer Size** to a fixed value (**4GB** or **8GB**) instead of "Auto." This prevents memory allocation desyncs.
2.  **Audio Power Fix:** Run the included `fix-gpu-audio-hang.sh` to disable `snd_hda_intel` power saving.
3.  **Kernel Parameters:** Add the following to your GRUB configuration:
    - `amdgpu.dcdebugmask=0x10` (Disables unstable Panel Self Refresh)
    - `amdgpu.sg_display=0` (Prevents Scatter-Gather allocation errors)
    - `amdgpu.gpu_recovery=1` (Allows driver to attempt reset on hang)

### References & Technical Deep-Dive
*   **GNOME GitLab #3515:** [Allocation errors leading to GPU hangs](https://gitlab.gnome.org/GNOME/gnome-shell/-/work_items/3515)
*   **Ubuntu Bug #2167096:** [AMD DCN 3.5 / SMU GPU hang after display/audio activity](https://bugs.launchpad.net/ubuntu/+source/linux-hwe-7.0/+bug/2167096)
*   **Reddit /r/MiniPCs:** [Community confirmation of HX370 PSR workarounds](https://www.reddit.com/r/MiniPCs/comments/1i4eyik/anyone_running_linux_on_an_ai_9_hx_370/)
*   **Phoronix:** [Strix Point Linux Stability Analysis](https://www.phoronix.com/review/amd-ryzen-ai-9-hx-370)
