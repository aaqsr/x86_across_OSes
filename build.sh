#!/usr/bin/env bash
set -euo pipefail

OS="$(uname -s)"

case "$OS" in
Linux)
    echo "==> Linux (x86_64 ELF)"

    nasm -f elf64 hello.asm -o hello.o

    cargo build --release --target x86_64-unknown-linux-gnu

    # -nostartfiles: we provide _start ourselves via NASM
    # no -static: std needs libc
    gcc -m64 \
        -nostartfiles \
        -o hello \
        hello.o \
        target/x86_64-unknown-linux-gnu/release/libfrom_rust.a \
        -lpthread -ldl

    echo "==> Built ./hello"
    echo "==> Run: qemu-x86_64 ./hello"
    ;;

Darwin)
    echo "==> macOS (x86_64 Mach-O)"

    nasm -f macho64 hello.asm -o hello.o

    cargo build --release --target x86_64-apple-darwin

    # clang handles linking against libSystem automatically
    clang -arch x86_64 \
          -e _start \
          -o hello \
          hello.o \
          target/x86_64-apple-darwin/release/libfrom_rust.a

    echo "==> Built ./hello"
    echo "==> Run: arch -x86_64 ./hello"
    ;;

*)
    echo "Unsupported OS: $OS"; exit 1 ;;
esac
