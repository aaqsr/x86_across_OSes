## how to debug on Mac

- `lldb hello` to launch lldb with the executable
- `b start` to set a breakpoint at `_start`
- `r` to run the process (must be done before stepping)
- `f` to see the assembly context of your execution
- `l` to see the source file (but this doesnt seem to work due to our handwritten binary)
- `s`, `n`, `c` to step(step into), next(step over), continue
- `bt` for backtrace
- `register read` to get values in registers

