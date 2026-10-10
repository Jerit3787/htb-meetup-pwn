# htb-meetup-pwn

Binary exploitation (pwn) workshop materials for HTB Meetup.

## Overview

This repository contains hands-on challenges and a mini-CTF for learning buffer overflow exploitation on both x86 (32-bit) and x64 (64-bit) architectures.

## Structure

```
├── docs/            # Workshop materials
│   ├── index.html          # Interactive browser slides & memory visualizer
│   ├── preparation.md/pdf  # Setup guide for attendees
│   ├── apple-silicon-setup.md/pdf # Apple Silicon setup guide
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
    └── install-tools.sh    # Install required tools on Kali / Linux
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
>
> **Apple Silicon (macOS M1/M2/M3/M4) users:** See the lightweight setup guide: [docs/apple-silicon-setup.md](docs/apple-silicon-setup.md) (or [PDF](docs/apple-silicon-setup.pdf)) to run Ghidra natively on macOS and x86_64 execution via Colima without heavy virtual machines.

## Interactive Presentation & Slides

An interactive, browser-based slide deck and memory visualizer is available in [`docs/index.html`](docs/index.html):
- **Live Memory Layout Explorer**: Click and inspect Linux memory segments (Stack, Heap, BSS, Data, Text).
- **Interactive Stack Frame Explorer**: Understand function call frames, caller vs callee, and memory growth.
- **Real-Time Buffer Overflow Simulator**: Type or test presets to see memory corruption, segmentation faults, and ret2win control-flow hijacking live.
- **Host it anywhere**: Open `docs/index.html` directly in any web browser, host via GitHub Pages, or serve locally with `python3 -m http.server 8000 -d docs`.

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