# Apple Silicon (M1/M2/M3/M4) Setup Guide
## Lightweight Binary Exploitation (PWN) Workshop Setup
**Hack The Box Meetup**

---

## 1. Overview & Concept

Instead of running a heavy virtual machine with a full desktop GUI (like Kali Linux inside VMware Fusion or UTM), which uses **8GB+ RAM** and lags under emulation, this guide uses a lightweight approach:

1. **Host OS (macOS)**: Runs **Ghidra** natively with full Apple Silicon speed and no GUI lag.
2. **Execution Environment (Colima)**: A headless, lightweight **x86_64 Linux VM** managed by Colima and QEMU (~2GB RAM).
3. **Inside Colima (`colima ssh`)**: You do everything just like a **typical Kali Linux environment**—compiling with GCC, debugging with GDB + pwndbg, running CTF containers, and writing/running exploit scripts.

Because Colima automatically shares your macOS filesystem, any file created on macOS is instantly accessible inside Colima (and vice versa) at the exact same file path.

---

## 2. Phase 1: macOS Host Setup (Getting Colima & Ghidra Ready)

Run the following commands in your **macOS Terminal**:

### Step 1: Ensure Homebrew is Installed
```bash
which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Install Ghidra on macOS Host
Ghidra runs on macOS so reverse engineering is fast and responsive:
```bash
# Install Ghidra and OpenJDK
brew install ghidra

# Create a symlink so typing 'ghidra' launches it from terminal
ln -sf /opt/homebrew/bin/ghidraRun /opt/homebrew/bin/ghidra
```
*Verify by running `which ghidra`. It should return `/opt/homebrew/bin/ghidra`.*

### Step 3: Install Colima, QEMU, and Lima
```bash
brew install colima qemu lima lima-additional-guestagents docker docker-compose
```

> [!IMPORTANT]
> **Lima Guest Agent Symlink (Apple Silicon Fix)**
> On Apple Silicon Macs, Lima only includes the ARM64 guest agent by default. The `lima-additional-guestagents` package provides the x86_64 agent. Link it into Lima's Cellar directory:
> ```bash
> ln -sf /opt/homebrew/share/lima/lima-guestagent.*.gz /opt/homebrew/Cellar/lima/*/share/lima/
> ```

### Step 4: Start Colima in x86_64 Emulation Mode
```bash
colima start --arch x86_64 --vm-type qemu
```

Verify that Colima is running with an x86_64 kernel:
```bash
colima status
# Shows: arch: x86_64, colima is running using QEMU
```

---

## 3. Phase 2: Enter the Linux Environment (`colima ssh`)

Now, enter your headless x86_64 Linux environment:

```bash
colima ssh
```

> [!TIP]
> **You are now inside an x86_64 Ubuntu Linux environment!**
> Everything from this point onward is done here, exactly like a Kali Linux terminal.

---

## 4. Phase 3: Setup & Work Inside Colima (Like Typical Kali Linux)

### Step 1: Navigate to the Repository
Your macOS files are automatically mounted under `/Users/...`:
```bash
cd /Users/<your-username>/Documents/GitHub/htb-meetup-pwn
# Or clone inside Colima if not already cloned:
# git clone https://github.com/danishhakim/htb-meetup-pwn.git && cd htb-meetup-pwn
```

### Step 2: Install PWN Tools inside Colima
Run the repo's tool installer (using `--skip-ghidra` since Ghidra is on your Mac):
```bash
chmod +x scripts/install-tools.sh
./scripts/install-tools.sh --skip-ghidra
```
*This installs:*
- `build-essential` and `gcc-multilib` (for 32-bit and 64-bit compilation)
- `gdb` and `pwndbg` (for interactive debugging)
- `python3`, `pip3`, and `pwntools`
- `checksec`
- `socat` and networking utilities

---

## 5. Phase 4: Compiling, Debugging & Testing Challenges

Everything is tested directly inside your Colima terminal session:

### Guided Hands-on Practice (`handson/`)
```bash
cd handson

# 1. Compile both 32-bit and 64-bit challenges
./build.sh

# 2. Inspect with checksec
checksec --file=x64/challenge
checksec --file=x86/challenge

# 3. Interactive Debugging with pwndbg
gdb ./x64/challenge
# pwndbg> r
# pwndbg> cyclic 100

# 4. Run the solve scripts
cd x64 && python3 solve.py
# Output: FLAG{x64_r3t2w1n_b4s1cs}

cd ../x86 && python3 solve.py
# Output: FLAG{x86_r3t2w1n_b4s1cs}
```

### Mini-CTF Docker Challenges (`mini-ctf/`)
```bash
cd /Users/<your-username>/Documents/GitHub/htb-meetup-pwn/mini-ctf

# 1. Start the challenge containers
docker compose up -d

# 2. Extract challenge binaries for reversing
./extract-binaries.sh

# 3. Run solve scripts against local containers
python3 x64/solve.py
# Output: 🚩 HTB{x64_st4ck_sm4sh1ng_pr0}

python3 x86/solve.py
# Output: 🚩 HTB{x86_buff3r_0v3rfl0w_m4st3r}
```

---

## 6. Phase 5: Reversing with Ghidra (macOS Host)

Whenever you need to inspect or disassemble a binary:
1. Open a **new terminal tab on your macOS host** (outside Colima).
2. Launch Ghidra:
   ```bash
   ghidra
   ```
3. Open or import the binary directly from your repository folder (e.g. `handson/x64/challenge` or `mini-ctf/binaries/challenge_x86`).
4. Find the target function address (`win()` or `get_flag()`) and buffer size.
5. Switch back to your `colima ssh` terminal to write the exploit and debug!

---

## 7. Useful Colima Commands (on macOS Host)

When you are done with the workshop:
```bash
# Exit Colima shell back to macOS
exit

# Stop Colima VM to save battery
colima stop

# Resume Colima anytime
colima start

# Delete Colima VM and free disk space
colima delete -f
```

---

## 8. Troubleshooting Cheat Sheet

| Issue | Where | Solution |
|---|---|---|
| `guest agent binary could not be found for Linux-x86_64` | macOS | Run `brew install lima-additional-guestagents` and link: `ln -sf /opt/homebrew/share/lima/lima-guestagent.*.gz /opt/homebrew/Cellar/lima/*/share/lima/` |
| `ghidra: command not found` | macOS | Run `ln -sf /opt/homebrew/bin/ghidraRun /opt/homebrew/bin/ghidra` |
| Cannot find repository inside Colima | Colima | Path is identical to macOS: `cd /Users/<your-username>/...` |
| GDB doesn't load pwndbg | Colima | Run `echo "source /usr/local/lib/pwndbg-gdb/gdbinit.py" >> ~/.gdbinit` |
| `ModuleNotFoundError: No module named 'pwn'` | Colima | Run `pip3 install pwntools --break-system-packages` |

---
**Happy Hacking! 🚩**
