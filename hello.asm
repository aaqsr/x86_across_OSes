; hello.asm — x86_64, identical source for Linux (elf64) and macOS (macho64)
; System V AMD64 ABI throughout.

default rel
extern _print, _exit_with_code

section .data
    msg: db "Hello, world!", 10  ; 14 bytes

section .text
    global _start

_start:
    ; print(ptr, len) — args in rdi, rsi per SysV AMD64
    lea  rdi, [msg]
    mov  rsi, 14
    push 0 ; no clue why we need this + pop rax afterwards
           ; but otherwise it segfaults on windows afterwards?
    call _print
    pop rax

    ; exit_with_code(code) — code in rdi
    mov  rdi, 0
    push 0
    call _exit_with_code
    pop rax
