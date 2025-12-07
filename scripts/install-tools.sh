set -e #Exit on error

echo "=== Installing GDB and pwndbg on Kali Linux"

sudo apt update
sudo apt install -y gdb
sudo apt install -y python3 python3-pip python3-dev git libglib2.0-dev libc6-dbg libssl-dev libffi-dev build-essential gcc-multilib
curl -qsL 'https://install.pwndbg.re' | sh -s -- -t pwndbg-gdb

echo "=== Installing ghidra on Kali Linux"

sudo apt install ghidra -y

echo "=== Installing pwntools on Kali Linux"

sudo apt install python3-pwntools

echo "=== Installing checksec on Kali Linux"

sudo apt install checksec