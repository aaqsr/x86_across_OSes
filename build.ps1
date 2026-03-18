nasm -f win64 hello.asm -o hello.o
cargo build --release
lld-link /NOLOGO /NXCOMPAT /OUT:main.exe /OPT:REF,NOICF /DEBUG /SUBSYSTEM:CONSOLE /entry:_start ./target/release/from_rust.lib ./hello.o kernel32.lib ntdll.lib userenv.lib ws2_32.lib ucrt.lib vcruntime.lib /defaultlib:libcmt
