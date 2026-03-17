#!/usr/bin/env bash
set -euo pipefail

OS="$(uname -s)"

case "$OS" in
Linux)
    echo "==> Linux (x86_64 ELF)"

    nasm -f elf64 hello.asm -o hello.o

    cargo build --release --target x86_64-unknown-linux-gnu

    ld -m elf_x86_64 \
       -e _start \
       --gc-sections \
       -dynamic-linker /lib64/ld-linux-x86-64.so.2 \
       -L/lib/x86_64-linux-gnu \
       hello.o \
       target/x86_64-unknown-linux-gnu/release/libfrom_rust.a \
       -lc -lpthread -ldl -lgcc_s -lm \
       -o hello

    echo "==> Built ./hello"
    echo "==> Run: qemu-x86_64 ./hello"
    ;;

Darwin)
    echo "==> macOS (x86_64 Mach-O)"

    nasm -f macho64 hello.asm -o hello.o

    cargo build --release --target x86_64-apple-darwin

    ld -arch x86_64 \
       -e _start \
       -dead_strip \
       -lSystem \
       -syslibroot $(xcrun --sdk macosx --show-sdk-path) \
       hello.o \
       target/x86_64-apple-darwin/release/libfrom_rust.a \
       -o hello

    echo "==> Built ./hello"
    echo "==> Run: arch -x86_64 ./hello"
    ;;

*)
    echo "Unsupported OS: $OS"; exit 1 ;;
esac
