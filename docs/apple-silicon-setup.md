# Apple Silicon (M1/M2/M3/M4) Setup Guide
## Lightweight Binary Exploitation (PWN) Workshop Setup
**Hack The Box Meetup**

---

## 1. Overview & Architecture

### The Problem with Traditional Virtual Machines
Running a full desktop Linux VM (such as Kali Linux GUI inside VMware Fusion or UTM) under x86_64 emulation on Apple Silicon is extremely heavy:
- Consumes **8GB+ RAM** and **40–50GB disk space**.
- Emulating an entire x86 desktop GUI results in mouse lag, display scaling artifacts, and high battery consumption.
- Frustrating experience for attendees during live workshops.

### The Lightweight Split Architecture
Instead of running a heavy virtual desktop, we split the workflow:

```
┌─────────────────────────────────────────────────────────────────┐
│                     macOS Host (Apple Silicon)                  │
│                                                                 │
│  • Ghidra (Native macOS GUI - Zero lag, fast decompiler)        │
│  • Terminal, Text Editor (VS Code / Neovim)                     │
│  • Python 3 + pwntools (Exploit scripts connect via network)   │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                                 │ Docker Port Forwarding
                                 │ (localhost:9001 / 9002)
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│               Headless Colima Linux VM (QEMU x86_64)            │
│                                                                 │
│  • Lightweight headless Ubuntu 24.04 kernel (~2GB RAM)          │
│  • Runs authentic x86 (32-bit) & x64 (64-bit) Linux ELFs        │
│  • Hosts Docker containers (mini-ctf challenges)                │
└─────────────────────────────────────────────────────────────────┘
```

1. **Host OS (macOS)**: Runs **Ghidra natively** via Homebrew (blazing fast, native Retina display) and your exploit scripts.
2. **Execution Environment (Colima)**: A minimal, headless **x86_64 Linux VM** managed by Colima and QEMU. It handles ELF binary execution and Docker containers with minimal resource overhead.

---

## 2. Prerequisites

Make sure you have [Homebrew](https://brew.sh/) installed on your Mac:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## 3. Step 1: Install Ghidra on macOS Host

Install Ghidra directly on macOS so that reverse engineering runs natively with Apple Silicon performance:

```bash
# 1. Install Ghidra and its OpenJDK dependency
brew install ghidra

# 2. Create a symlink so you can launch Ghidra by typing 'ghidra' in any terminal
ln -sf /opt/homebrew/bin/ghidraRun /opt/homebrew/bin/ghidra
```

### Verification:
```bash
which ghidra
# Output: /opt/homebrew/bin/ghidra
```
Now typing `ghidra` in your terminal will instantly open the Ghidra GUI.

---

## 4. Step 2: Install & Configure Colima (x86_64)

Install Colima, QEMU, Lima, and the Docker command-line tools:

```bash
brew install colima qemu lima lima-additional-guestagents docker docker-compose
```

> [!IMPORTANT]
> **Apple Silicon Lima Guest Agent Fix**
> On ARM64 Macs, Lima installs only the ARM64 guest agent by default. The `lima-additional-guestagents` formula provides the x86_64 guest agent. Link it into Lima's Cellar directory so Lima finds it:
> ```bash
> ln -sf /opt/homebrew/share/lima/lima-guestagent.*.gz /opt/homebrew/Cellar/lima/*/share/lima/
> ```

---

## 5. Step 3: Start Colima in x86_64 Mode

Start the headless x86_64 Linux instance:

```bash
colima start --arch x86_64 --vm-type qemu
```

### Verification:
Check that the VM is running as `x86_64`:
```bash
colima status
# Expected output:
# colima is running using QEMU
# arch: x86_64
# runtime: docker

docker info | grep Architecture
# Expected output:
#  Architecture: x86_64
```

---

## 6. Step 4: Clone the Workshop Repository

```bash
git clone https://github.com/danishhakim/htb-meetup-pwn.git
cd htb-meetup-pwn
```

---

## 7. Step 5: Python & Pwntools on macOS Host

To develop and test exploit scripts natively on your Mac:

```bash
# 1. Create a Python virtual environment
python3 -m venv ~/.pwn-env

# 2. Activate the virtual environment
source ~/.pwn-env/activate

# 3. Install pwntools
pip install --upgrade pwntools
```

*(Tip: Add `alias pwn="source ~/.pwn-env/activate"` to your `~/.zshrc` for quick access).*

---

## 8. Step 6: Running the Mini-CTF Challenges

The CTF challenges run in Docker containers managed by Colima, while you interact with them from macOS.

### 1. Start the CTF Containers:
```bash
cd mini-ctf
docker compose up -d
```

### 2. Extract the Challenge Binaries:
Run the extraction script to pull the compiled binaries from the containers:
```bash
chmod +x extract-binaries.sh
./extract-binaries.sh
```
This copies:
- `binaries/challenge_x86` (32-bit ELF)
- `binaries/challenge_x64` (64-bit ELF)

### 3. Reverse Engineer in Ghidra (macOS):
In a new terminal window:
```bash
ghidra &
```
1. Create a new project in Ghidra.
2. Drag and drop `binaries/challenge_x86` and `binaries/challenge_x64`.
3. Analyze and locate the vulnerabilities and target functions (`get_flag()`).

### 4. Solve the Challenges:
The Docker containers forward their ports to your Mac host:
- **x86 Challenge**: `127.0.0.1:9001`
- **x64 Challenge**: `127.0.0.1:9002`

Run the solve scripts:
```bash
# For x64 challenge:
python3 x64/solve.py

# For x86 challenge:
python3 x86/solve.py
```
Both scripts will exploit the running containers on `localhost` and display the flags:
- `🚩 HTB{x64_st4ck_sm4sh1ng_pr0}`
- `🚩 HTB{x86_buff3r_0v3rfl0w_m4st3r}`

### 5. Stop the Containers:
When finished:
```bash
docker compose down
```

---

## 9. Step 7: Running the Hands-on Challenges

The guided hands-on challenges are located in `handson/`:

### Building Challenges (Inside x86_64 Linux Container):
Because macOS cannot compile native Linux ELFs with GCC, use Docker via Colima:
```bash
docker run --rm -v "$PWD:/workspace" -w /workspace/handson test-x86 ./build.sh
```
Or enter the Colima VM shell directly:
```bash
colima ssh
cd /Users/<your-username>/.../htb-meetup-pwn/handson
sudo apt update && sudo apt install -y build-essential gcc-multilib
./build.sh
```

### Running Hands-on Solves:
```bash
cd handson/x64
python3 solve.py
# FLAG{x64_r3t2w1n_b4s1cs}

cd ../x86
python3 solve.py
# FLAG{x86_r3t2w1n_b4s1cs}
```

---

## 10. Managing Colima

When you are done with the workshop, stop Colima to free CPU and battery:
```bash
colima stop
```

To resume at any time:
```bash
colima start
```

To delete the VM and reclaim disk space:
```bash
colima delete -f
```

---

## 11. Quick Troubleshooting

| Issue | Cause | Solution |
|---|---|---|
| `guest agent binary could not be found for Linux-x86_64` | Lima missing x86_64 agent on Apple Silicon. | Run `brew install lima-additional-guestagents` and symlink to `/opt/homebrew/Cellar/lima/*/share/lima/`. |
| `Cannot connect to Docker daemon` | Colima is stopped or Docker context is wrong. | Run `colima start` and `docker context use colima`. |
| `ghidra: command not found` | Formula installs as `ghidraRun`. | Run `ln -sf /opt/homebrew/bin/ghidraRun /opt/homebrew/bin/ghidra`. |
| `ModuleNotFoundError: No module named 'pwn'` | Python virtual environment not active. | Run `source ~/.pwn-env/activate`. |
| Port conflict on 9001 / 9002 | Another service using port. | Check with `lsof -i :9001` or change ports in `docker-compose.yml`. |

---
**Happy Hacking! 🚩**
