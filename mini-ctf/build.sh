#!/bin/bash
# Build script for CTF challenges (local testing)

echo "=== Building CTF Challenges ==="

# Build x86 (32-bit)
echo "[*] Building x86 challenge..."
cd x86
gcc -m32 -fno-stack-protector -no-pie -Wno-deprecated-declarations -o challenge challenge.c
echo "[+] x86 challenge built: x86/challenge"

# Build x64 (64-bit)
echo "[*] Building x64 challenge..."
cd ../x64
gcc -fno-stack-protector -no-pie -Wno-deprecated-declarations -o challenge challenge.c
echo "[+] x64 challenge built: x64/challenge"

echo ""
echo "=== Build Complete ==="
echo ""
echo "To run locally:  ./challenge"
echo "To run Docker:   docker-compose up -d"
