default rel

section .text
    global _start
    extern __debexit
    extern NATIVEjava.io.OutputStream.nativeWrite

_start:
    lea  rsi, [msg]         ; need 64-bit lea to get RIP-relative address sadly. will need to keep this
    mov  ebx, 14            ; length of msg we are output

.loop:
    movzx eax, byte [rsi]   ; load byte into al/fills the upper unused bits of the destination register with zeros
    push rsi
    call NATIVEjava.io.OutputStream.nativeWrite
    pop  rsi
    inc  rsi
    dec  ebx
    jnz  .loop

    mov  eax, 0
    call __debexit

section .data
    msg: db "Hello, world!", 0x0A ; \n . no null byte
