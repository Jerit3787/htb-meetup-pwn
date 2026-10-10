#!/bin/bash
set -e
# Build script for CTF challenges (local testing)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Building CTF Challenges ==="

# Build x86 (32-bit)
echo "[*] Building x86 challenge..."
cd "$SCRIPT_DIR/x86"
gcc -m32 -fno-stack-protector -no-pie -Wno-deprecated-declarations -o challenge_x86 challenge.c
cp -f challenge_x86 challenge
chmod +x challenge_x86 challenge
echo "[+] x86 challenge built: mini-ctf/x86/challenge_x86 (and challenge)"

# Build x64 (64-bit)
echo "[*] Building x64 challenge..."
cd "$SCRIPT_DIR/x64"
gcc -fno-stack-protector -no-pie -Wno-deprecated-declarations -o challenge_x64 challenge.c
cp -f challenge_x64 challenge
chmod +x challenge_x64 challenge
echo "[+] x64 challenge built: mini-ctf/x64/challenge_x64 (and challenge)"

echo ""
echo "=== Build Complete ==="
echo ""
echo "To run locally:  cd mini-ctf/x64 && ./challenge"
echo "To run Docker:   cd mini-ctf && docker-compose up -d"
