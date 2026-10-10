#!/bin/bash
set -e
# Build script for hands-on challenges

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Building Hands-on Challenges ==="

# Build x86 (32-bit)
echo "[*] Building x86 challenge..."
cd "$SCRIPT_DIR/x86"
gcc -m32 -fno-stack-protector -no-pie -Wno-deprecated-declarations -o challenge challenge.c
chmod +x challenge
echo "[+] x86 challenge built: handson/x86/challenge"

# Build x64 (64-bit)
echo "[*] Building x64 challenge..."
cd "$SCRIPT_DIR/x64"
gcc -fno-stack-protector -no-pie -Wno-deprecated-declarations -o challenge challenge.c
chmod +x challenge
echo "[+] x64 challenge built: handson/x64/challenge"

echo ""
echo "=== Build Complete ==="
echo "Run with: ./challenge"
