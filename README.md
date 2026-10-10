# htb-meetup-pwn

Binary exploitation (pwn) workshop materials for HTB Meetup.

## Overview

This repository contains hands-on challenges and a mini-CTF for learning buffer overflow exploitation on both x86 (32-bit) and x64 (64-bit) architectures.

## Structure

```
├── docs/            # Workshop materials
│   ├── preparation.md/pdf  # Setup guide for attendees
│   └── slides.md/pdf       # Presentation slides
│
├── handson/         # Guided practice challenges
│   ├── x64/         # 64-bit ret2win challenge
│   └── x86/         # 32-bit ret2win challenge
│
├── mini-ctf/        # CTF-style challenges (Docker-based)
│   ├── x64/         # 64-bit challenge with hidden flag
│   └── x86/         # 32-bit challenge with hidden flag
│
└── scripts/         # Helper scripts
    └── install-tools.sh    # Install required tools on Kali
```

## Challenges

### Hands-on Challenges
Simple ret2win challenges to practice the basics:
- Overflow a buffer to overwrite the return address
- Redirect execution to a `win()` function that prints the flag

### Mini-CTF
More realistic challenges running in Docker containers:
- Find and exploit the buffer overflow vulnerability
- Call a hidden `get_flag()` function to read `flag.txt`

## Requirements

- GCC with multilib support
- Python 3 with [pwntools](https://github.com/Gallopsled/pwntools)
- Docker & Docker Compose (for mini-CTF)
- GDB with [pwndbg](https://github.com/pwndbg/pwndbg)
- [Ghidra](https://ghidra-sre.org/) for reverse engineering

> **Kali Linux users:** Run `scripts/install-tools.sh` to install all required tools.

## Quick Start

```bash
# Build challenges
cd handson && ./build.sh
cd ../mini-ctf && docker-compose up -d

# Try the x64 hands-on
cd ../handson/x64
./challenge
python3 solve.py
```

## Learning Objectives

- Understanding stack-based buffer overflows
- Finding offsets to overwrite return addresses
- Using pwntools for exploit development
- x86 vs x64 calling conventions and stack alignment

## Writeup

A detailed writeup for these challenges is available at:
**[HTB Meetup IIUM 2025 - Intro to PWN](https://ctf.danplace.tech/posts/htb-meetup-iium/)**