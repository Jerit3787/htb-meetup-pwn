#!/bin/bash
# Build script for hands-on challenges

echo "=== Building Hands-on Challenges ==="

# Build x86 (32-bit)
echo "[*] Building x86 challenge..."
cd x86
gcc -m32 -fno-stack-protector -no-pie -o challenge challenge.c
echo "[+] x86 challenge built: x86/challenge"

# Build x64 (64-bit)
echo "[*] Building x64 challenge..."
cd ../x64
gcc -fno-stack-protector -no-pie -o challenge challenge.c
echo "[+] x64 challenge built: x64/challenge"

echo ""
echo "=== Build Complete ==="
echo "Run with: ./challenge"
