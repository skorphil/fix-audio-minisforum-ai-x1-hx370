# Research: Minisforum AI X1 (HX370) Audio Jack Fix
**Document Revision:** 1.3 (October 2026)
**Target Hardware:** Minisforum AI X1 (ALC245 Codec)

## 1. Audio Investigation: Realtek ALC245 Headphone Jack
The headphone jack (3.5mm) on the HX370 (Subsystem ID `1f4c:b022`) is frequently not detected when headphones are plugged in.

### 1.1 Investigated Failure Modes
1.  **Jack Detector Reset Bit:** The ALC245 "Headphone Jack Detector Reset" bit can get stuck, making the hardware blind to plug events.
2.  **External Amplifier (EAPD):** The headphone output uses an EAPD on Node 0x21 that is often powered down by default in Linux.
3.  **Missing Kernel Quirks:** Specific support for the `1f4c:b022` subsystem is missing in current kernels.

### 1.2 Successful Resolution: HDA-Verb Coefficients
Applying vendor-specific codec coefficients at runtime initializes the hardware correctly, enabling both the output path and the physical jack sensor.
**Required Coefficients (Node 0x20):** `0x06:0xe115`, `0x08:0x6a08`, `0x0f:0x00c2`, `0x1a:0x8c03`, `0x1b:0x4a4b`, `0x45:0xd689`, `0x46:0x00f4`, `0x49:0x0249`, `0x4a:0x21f0`, `0x63:0x0000`, `0x67:0x3000`.

---

## 3. Who's to Blame?
The failure is a result of a missing handover between the hardware firmware and the operating system driver.

### 3.1 The Firmware (BIOS)
The primary fault lies with the **Minisforum BIOS/Firmware**. On modern PCs, the BIOS is responsible for performing the initial "verb" sequence that sets the codec's hardware state. On the AI X1, the BIOS fails to:
1.  Clear the "Jack Detector Reset" bit.
2.  Wake the External Amplifier (EAPD).
This leaves the hardware in a non-functional state before the OS even loads.

### 3.2 The Linux Kernel
The Linux Kernel is "to blame" for not having a software workaround (a **Kernel Quirk**) for this specific hardware bug yet. Linux maintains a database of machine-specific patches to fix broken BIOS implementations. Since the AI X1 is new, the subsystem ID `1f4c:b022` hasn't been added to the `patch_realtek.c` file in the kernel source, which is why manual intervention is required.

### 3.3 Why does it work on Windows?
**The issue is not present on Windows.** 
Windows "works" because the proprietary Realtek drivers provided by Minisforum contain the exact coefficient initialization sequence used in this fix. These drivers proactively re-initialize the chip regardless of the BIOS's failure. 

**Proving the Firmware Fault:** If you perform a "warm reboot" (Restart) from Windows into Linux, the audio jack often works temporarily. This is because the Windows driver successfully initialized the hardware, and the hardware state persisted through the soft reboot. A "cold boot" (Shutdown then Power On) will break it again, as the BIOS fails to re-apply the fix.
