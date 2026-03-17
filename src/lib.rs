use std::io::{self, Write};
use std::process;

// On Mach-O, #[no_mangle] `print` exports as `_print` (linker adds the underscore).
// On ELF, it exports as `print`. NASM calls `_print` on macOS and `print` on Linux —
// but since our NASM uses `call _print` on both, we use must cfg to export the right name.

#[cfg_attr(target_os = "macos", export_name = "print")]
#[cfg_attr(target_os = "linux", export_name = "_print")]
pub extern "sysv64" fn print(ptr: *const u8, len: usize) {
    let slice = unsafe { std::slice::from_raw_parts(ptr, len) };
    io::stdout().write_all(slice).unwrap();
}

#[cfg_attr(target_os = "macos", export_name = "exit_with_code")]
#[cfg_attr(target_os = "linux", export_name = "_exit_with_code")]
pub extern "sysv64" fn exit_with_code(code: i32) -> ! {
    process::exit(code)
}
