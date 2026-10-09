# Minisforum AI X1 (HX370) Audio Jack Fix for Linux

This repository addresses the headphone jack detection issue on the **Minisforum AI X1** (AMD Ryzen AI 9 HX 370) running Linux.

> [!IMPORTANT]
> This fix is tailored exclusively for the **Minisforum AI X1** (non-Pro) and avoids firmware modifications.

For other models and approaches, see:
- [fix-audio-alc245-minisforum](https://github.com/checor/fix-audio-alc245-minisforum) (for X1 Pro)
- [minisforum-audio-fix](https://github.com/puffo/minisforum-audio-fix) (firmware patch)

---

## 🚀 Quick Install (One-Liner)

Run the following command to launch the interactive manager directly:

```bash
/bin/bash -c "$(curl -fsSL https://github.com/skorphil/fix-audio-minisforum-ai-x1-hx370/releases/latest/download/hx370-audio-fix.sh)"
```

---

## 🛠 Usage Instructions

### 1. Simple Run (Standalone)
If you have cloned the repository, you can build and run the script:
```bash
make install
```

### 2. Command Line Arguments
For automation or power users:
- `sudo ./hx370-audio-fix.sh --install`: Silent install.
- `sudo ./hx370-audio-fix.sh --uninstall`: Remove all changes.
- `sudo ./hx370-audio-fix.sh --apply`: Apply codec coefficients immediately (without installing).
- `sudo ./hx370-audio-fix.sh --status`: Check installation status.

---

## 🏗 Developer Information
This repository uses a modular structure for easier maintenance.
- `src/`: Contains modular shell scripts.
- `templates/`: Contains systemd service templates.
- `build.sh`: A script that bundles everything into the standalone `hx370-audio-fix.sh`.

If you modify files in `src/` or `templates/`, make sure to run `bash build.sh` to update the main script.

---

## 📚 Research & References
- **NixOS Issue #1829:** [Minisforum AI X1 Headphones unplugged](https://github.com/NixOS/nixos-hardware/issues/1829)
- **Linux Mint Forums:** [Minisforum X1 Pro Audio Fix](https://forums.linuxmint.com/viewtopic.php?t=449602)

## 💻 Tested Environments

### Fedora 44
- **Hardware:** Minisforum AI X1 (AMD Ryzen AI 9 HX 370)
- **OS:** Fedora 44 (Workstation Edition)
- **Kernel:** `7.2.9-200.fc44.x86_64`
- **Codec:** Realtek ALC245

### Ubuntu 26.04 LTS
- **Hardware:** Minisforum AI X1 (AMD Ryzen AI 9 HX 370)
- **OS:** Ubuntu 26.04.1 LTS (Resolute Raccoon)
- **Kernel:** `7.0.0-14-generic`
- **Codec:** Realtek ALC245

---

This project was developed with AI assistance.
