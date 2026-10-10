# Hack The Box Talk - Setup Guide

This repository contains setup materials for the HTB (Hack The Box) talk, including a Kali Linux VM and a tool installation script.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installing VMware](#installing-vmware)
- [Installing Kali Linux](#installing-kali-linux)
- [Running the Tool Installation Script](#running-the-tool-installation-script)
- [Tools Installed](#tools-installed)

---

## Prerequisites

- A computer with at least **8GB RAM** (16GB recommended)
- At least **50GB** of free disk space
- Virtualization enabled in BIOS/UEFI (Intel VT-x or AMD-V)

---

## Installing VMware

If you haven't yet have a Kali Linux VM, I have provided an exe for you guys to install. Please be sure to click and install first. You can download it from [https://drive.google.com/drive/folders/1QQyk3JtvSkOf7fQmAnBpaJRBDmlsZiJv?usp=sharing](https://drive.google.com/drive/folders/1QQyk3JtvSkOf7fQmAnBpaJRBDmlsZiJv?usp=sharing)

---

## Installing Kali Linux

### Using the Pre-configured VM (Recommended)

We are going to use a Kali Linux, if you do not have it yet, you can download using this link [https://www.kali.org/get-kali/#kali-virtual-machines](https://www.kali.org/get-kali/#kali-virtual-machines), choose for VMWare and open/import it inside VMWare.

## Running the Tool Installation Script

Once Kali Linux is running, follow these steps to install the required tools:

### Step 1: Transfer or Clone the Script

**Option A: Clone this repository directly in Kali (Recommended)**
```bash
git clone https://github.com/danishhakim/htb-meetup-pwn.git
cd htb-meetup-pwn
chmod +x scripts/install-tools.sh
./scripts/install-tools.sh
```

**Option B: Clone via standalone Gist**
```bash
git clone https://gist.github.com/Jerit3787/2cda2b3a62517109cb8f50e5a2254a62.git htb-tools
cd htb-tools
chmod +x install-htb-tools.sh
./install-htb-tools.sh
```

The script will automatically install all required tools with `sudo` privileges. You may be prompted for the password (`kali`).

---

## Tools Installed

The `install-htb-tools.sh` script installs the following tools:

| Tool | Description |
|------|-------------|
| **GDB** | GNU Debugger - essential for debugging binaries |
| **pwndbg** | GDB plugin that makes debugging exploits easier |
| **Ghidra** | NSA's reverse engineering tool for analyzing binaries |
| **pwntools** | Python library for CTF and exploit development |
| **checksec** | Tool to check security properties of binaries (RELRO, Stack Canary, NX, PIE, etc.) |

---

## Troubleshooting

### VMware says virtualization is disabled
- Restart your computer and enter BIOS/UEFI settings
- Enable **Intel VT-x** (Intel) or **AMD-V/SVM** (AMD)
- Save and restart

### Network not working in Kali
1. In VMware, go to **VM > Settings > Network Adapter**
2. Ensure it's set to **NAT** or **Bridged**
3. Restart the VM

## Quick Start Summary

```bash
# 1. Start Kali Linux VM in VMware
# 2. Login with kali/kali
# 3. Open terminal and run:

chmod +x install-htb-tools.sh
./install-htb-tools.sh

# 4. Wait for installation to complete
# 5. You're ready for the HTB talk!
```

---

**And that is all, see you guys in the session!**
