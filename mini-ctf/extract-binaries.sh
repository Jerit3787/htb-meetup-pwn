#!/bin/bash
set -e
# Script to extract binaries from Docker containers and pack as zip (Linux / macOS / Kali)
# Run this after: docker-compose up -d

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/binaries"
ZIP_PATH="$SCRIPT_DIR/ctf_challenges.zip"

echo "=== Extracting CTF Challenge Binaries ==="

mkdir -p "$OUTPUT_DIR"

# Extract x86 binary
echo "[*] Extracting x86 challenge..."
docker cp pwn-challenge-x86:/home/ctf/challenge "$OUTPUT_DIR/challenge_x86"
chmod +x "$OUTPUT_DIR/challenge_x86"

# Extract x64 binary
echo "[*] Extracting x64 challenge..."
docker cp pwn-challenge-x64:/home/ctf/challenge "$OUTPUT_DIR/challenge_x64"
chmod +x "$OUTPUT_DIR/challenge_x64"

# Create README for participants
cat << 'EOF' > "$OUTPUT_DIR/README.md"
# CTF Challenge Binaries

## Connection Info
| Challenge | Command |
|-----------|---------|
| x86 (32-bit) | nc bore.pub 31337 |
| x64 (64-bit) | nc bore.pub 31338 |

## Files
- challenge_x86 - 32-bit binary
- challenge_x64 - 64-bit binary

## Hints
- Buffer size: 32 bytes
- Find the hidden function!
- For x64: Remember stack alignment

Good luck! 🚩
EOF

# Create password-protected zip (or normal zip if zip with -P is available)
echo "[*] Creating password-protected zip file..."
rm -f "$ZIP_PATH"

if command -v 7z >/dev/null 2>&1; then
    7z a -tzip -p"htb2025" "$ZIP_PATH" "$OUTPUT_DIR"/*
elif command -v zip >/dev/null 2>&1; then
    (cd "$OUTPUT_DIR" && zip -P "htb2025" "$ZIP_PATH" *)
else
    echo "[!] Neither 7z nor zip found. Binaries are available in $OUTPUT_DIR"
fi

echo ""
echo "=== Done! ==="
if [ -f "$ZIP_PATH" ]; then
    echo "Zip file created: $ZIP_PATH"
    echo "Password: htb2025"
fi
echo "Share this zip with participants!"
