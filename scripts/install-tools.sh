#!/bin/bash
set -e # Exit on error

echo "=================================================="
echo "    HTB Meetup PWN - Tool Installation Script"
echo "    Target: Kali Linux / Debian-based systems"
echo "=================================================="

# 1. System packages & dependencies
echo ""
echo "[*] Updating package index..."
sudo apt update

echo ""
echo "[*] Installing GDB and development libraries..."
sudo apt install -y \
    gdb \
    python3 \
    python3-pip \
    python3-dev \
    git \
    libglib2.0-dev \
    libc6-dbg \
    libssl-dev \
    libffi-dev \
    build-essential \
    gcc-multilib \
    netcat-traditional \
    socat \
    file \
    unzip \
    curl \
    wget

# 2. Pwndbg
echo ""
echo "[*] Installing pwndbg for GDB..."
if [ -d "$HOME/.gdbinit.d" ] || grep -q "pwndbg" "$HOME/.gdbinit" 2>/dev/null; then
    echo "[+] pwndbg already configured."
else
    curl -qsL 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb || {
        echo "[!] Quick installer failed, falling back to git install..."
        if [ ! -d "/opt/pwndbg" ]; then
            sudo git clone https://github.com/pwndbg/pwndbg /opt/pwndbg
            cd /opt/pwndbg && ./setup.sh
            cd - >/dev/null
        fi
    }
fi

# Ensure typing 'gdb' also launches pwndbg directly
if [ -x "/usr/local/bin/pwndbg" ]; then
    sudo ln -sf /usr/local/bin/pwndbg /usr/local/bin/gdb
fi

# Disable debuginfod network stalls in GDB
if ! grep -q "set debuginfod enabled off" "$HOME/.gdbinit" 2>/dev/null; then
    echo "set debuginfod enabled off" >> "$HOME/.gdbinit"
fi

# 3. Pwntools
echo ""
echo "[*] Installing pwntools..."
if sudo apt install -y python3-pwntools; then
    echo "[+] python3-pwntools installed via apt."
else
    echo "[-] apt package not available, installing pwntools via pip..."
    pip3 install --upgrade pwntools --break-system-packages 2>/dev/null || pip3 install --upgrade pwntools
fi

# 4. Checksec
echo ""
echo "[*] Installing checksec..."
sudo apt install -y checksec

# 5. Ghidra Installation & Symlink Setup
if [ "$1" = "--skip-ghidra" ] || [ "$SKIP_GHIDRA" = "1" ]; then
    echo ""
    echo "[*] Skipping Ghidra installation (using native Ghidra on macOS host)."
    GHIDRA_INSTALLED=true
else
    echo ""
    echo "[*] Installing Ghidra..."

    # Ensure Java (JDK 17+) required by Ghidra is present
    echo "[*] Ensuring OpenJDK is installed..."
    sudo apt install -y openjdk-17-jdk 2>/dev/null || sudo apt install -y default-jdk

    GHIDRA_INSTALLED=false

# Method A: Try installing via Kali's official apt repository
if sudo apt install -y ghidra; then
    echo "[+] Ghidra installed via apt."
    GHIDRA_INSTALLED=true
fi

# Method B: Fallback to manual download if apt package is missing or failed
if [ "$GHIDRA_INSTALLED" = false ] || ! command -v ghidra >/dev/null 2>&1; then
    echo "[*] Installing Ghidra from official GitHub release..."
    GHIDRA_BASE="/opt/ghidra"
    sudo mkdir -p "$GHIDRA_BASE"

    LATEST_JSON=$(curl -s https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest)
    DOWNLOAD_URL=$(echo "$LATEST_JSON" | grep "browser_download_url.*\.zip" | cut -d '"' -f 4 | head -n 1)

    if [ -n "$DOWNLOAD_URL" ]; then
        echo "[*] Downloading: $DOWNLOAD_URL"
        curl -L "$DOWNLOAD_URL" -o /tmp/ghidra.zip
        echo "[*] Extracting Ghidra to $GHIDRA_BASE..."
        sudo unzip -qo /tmp/ghidra.zip -d "$GHIDRA_BASE"
        rm -f /tmp/ghidra.zip

        # Find extracted directory containing ghidraRun
        EXTRACTED_DIR=$(find "$GHIDRA_BASE" -maxdepth 2 -name "ghidraRun" -exec dirname {} \; | head -n 1)
        if [ -n "$EXTRACTED_DIR" ]; then
            sudo chmod +x "$EXTRACTED_DIR/ghidraRun"
            sudo ln -sfn "$EXTRACTED_DIR" /opt/ghidra_latest
            sudo ln -sf "$EXTRACTED_DIR/ghidraRun" /usr/local/bin/ghidra
            GHIDRA_INSTALLED=true
        fi
    fi
fi

# Symlink verification: ensure 'ghidra' command exists in PATH
echo "[*] Configuring terminal command for Ghidra..."
if command -v ghidra >/dev/null 2>&1; then
    GHIDRA_PATH=$(command -v ghidra)
    echo "[+] Ghidra executable found at: $GHIDRA_PATH"
else
    # Search common directories for ghidraRun and create symlink
    GHIDRA_RUN=$(find /usr/share /opt "$HOME" -name "ghidraRun" 2>/dev/null | head -n 1)
    if [ -n "$GHIDRA_RUN" ]; then
        sudo chmod +x "$GHIDRA_RUN"
        sudo ln -sf "$GHIDRA_RUN" /usr/local/bin/ghidra
        echo "[+] Symlinked $GHIDRA_RUN -> /usr/local/bin/ghidra"
    else
        echo "[!] Warning: ghidraRun not located automatically. Please check your Ghidra directory."
    fi
fi

# Create desktop entry if application directory exists
if [ -d "/usr/share/applications" ]; then
    echo "[*] Ensuring Ghidra desktop shortcut exists..."
    sudo tee /usr/share/applications/ghidra.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Ghidra
Comment=NSA Software Reverse Engineering Framework
Exec=ghidra
Icon=ghidra
Terminal=false
Type=Application
Categories=Development;ReverseEngineering;Security;
EOF
fi
fi

# 6. Verification Summary
echo ""
echo "=================================================="
echo "               Verification Summary"
echo "=================================================="
echo -n "[*] GDB:        " && (gdb --version 2>/dev/null | head -n 1 || echo "NOT FOUND")
echo -n "[*] pwndbg:     " && (grep -q "pwndbg" ~/.gdbinit 2>/dev/null && echo "Configured in ~/.gdbinit" || echo "Check ~/.gdbinit")
echo -n "[*] checksec:   " && (which checksec 2>/dev/null || echo "NOT FOUND")
echo -n "[*] pwntools:   " && (python3 -c "import pwn; print('Installed (v' + pwn.__version__ + ')') " 2>/dev/null || echo "NOT FOUND")
echo -n "[*] Ghidra:     " && (which ghidra 2>/dev/null && echo "Available (Run 'ghidra' directly in terminal)" || echo "NOT IN PATH")
echo "=================================================="
echo "[+] Setup complete! You can now run 'ghidra' in any terminal."