use std::io::{self, Write};
use std::process;

// On Mach-O, #[no_mangle] `print` exports as `_print` (linker adds the underscore).
// On ELF, it exports as `print`. NASM calls `_print` on macOS and `print` on Linux.
// but since our NASM uses `call _print` on both, we use must cfg to export the right name.
// (Note this should not apply to NATIVEjava.io.blah.blah so we should still be able to have those)
// Thankfully I discovered that \x01 tells LLVM to PLEASE OH PLEASE DO NOT ADD LEADING _ THNX

// !!!!!
// WARNING!!: THIS WILL CLOBBER ALL CALLER SAVE REGISTERS, (and may clobber more)
// !!!!!

// byte to print is in al (low byte of eax).
// We save eax immediately in the naked stub before the compiler
// can clobber it, then forward to the real implementation.
#[unsafe(naked)]
#[export_name = "\x01NATIVEjava.io.OutputStream.nativeWrite"]
pub unsafe extern "C" fn print() {
    core::arch::naked_asm!(
        // eax contains the byte, we move al into edi which is the first SysV arg, (zero-extended)
        "movzx edi, al",
        "call {inner}",
        "ret",
        inner = sym print_inner,
    )
}

extern "sysv64" fn print_inner(byte: u8) {
    let buf = [byte];
    io::stdout().write_all(&buf).unwrap();
}

#[unsafe(naked)]
#[export_name = "\x01__debexit"]
pub unsafe extern "C" fn exit_with_code() -> ! {
    core::arch::naked_asm!(
        // eax contains the code, we move into edi which is the first SysV arg
        "mov edi, eax",
        "call {inner}",
        inner = sym exit_inner,
    )
}

extern "sysv64" fn exit_inner(code: i32) -> ! {
    process::exit(code)
}

