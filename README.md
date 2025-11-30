# C Position-Independent Code (PIC)

[GitHub Project](https://github.com/mrzaxaryan/c-pic)

Small cross-platform demo that compiles a tiny C program into position-independent machine code for Windows and Linux. The payload resolves any Windows APIs it needs at runtime and writes `"Hello world!"` directly to the console, all without the CRT, standard library, or system headers.

> ⚠️ This repository is for low-level systems / compiler education and security research in *controlled* environments only. Do not use it in any way that violates laws or policies.

---

## Overview

The project shows how to:

- obtain the Process Environment Block (PEB) manually on Windows;
- walk the loader data structures to find the base address of `Kernel32.dll`;
- parse PE export tables to resolve functions such as `WriteConsoleA`;
- call those APIs using function pointers from position-independent C;
- perform direct Linux syscalls (`write`, `exit`) without libc;
- cross-compile the same C source for multiple OS / architecture targets;
- extract a compact, contiguous shellcode-like blob from the resulting binary.

The concrete example simply prints `"Hello world!\n"` and exits, but the same techniques can be extended to more complex payloads.

---

## Features

- **No CRT / libc** – custom integer / pointer / string primitives only.
- **No Windows headers** – required NT / PE structures are re-declared locally.
- **Manual API resolution** – functions obtained from PEB + PE export parsing.
- **Position-independent output** – code is safe to copy to an arbitrary address.
- **Cross-OS, cross-arch** – Windows & Linux, x86, x86-64, and ARM64.
- **Single `.text` segment** – linker script keeps all code & read-only data together.
- **Shellcode-friendly artifacts** – build scripts emit a raw byte blob plus basic metadata.

---

## Supported targets

The current build scripts aim at:

- **Windows**
  - 32-bit x86
  - 64-bit x86-64
  - 64-bit ARM64
- **Linux**
  - 32-bit x86
  - 64-bit x86-64
  - 64-bit ARM64

The exact triples / flags are defined in `build.bat` and passed through to `toolchain.bat`. You can add / remove targets there as needed.

---

## How it works

### Windows path

On Windows builds (`PLATFORM_WINDOWS`):

1. `GetCurrentPEB` in `peb.c` uses the appropriate segment register or thread-local register (`FS`/`GS`/`x18`) to obtain a pointer to the current process’s PEB.
2. `GetModuleHandleFromPEB` walks the linked list of loaded modules in `PEB_LDR_DATA` to find `Kernel32.dll` by case-insensitive name.
3. `GetExportAddress` in `pe.c` parses the PE headers and export directory of `Kernel32.dll` to look up a function by name and return its address.
4. `console.windows.c` casts that address to the correct function-pointer type and uses it to call `WriteConsoleA`.
5. `main.c` prepares the `"Hello world!\n"` string, calls `WriteConsole`, and finally uses the `ExitProcess` macro from `environment.h` to terminate cleanly.

All of this happens without including `<windows.h>` or linking against the standard import libraries.

### Linux path

On Linux builds (`PLATFORM_LINUX`):

- `console.linux.c` implements `WriteConsole` using inline assembly to invoke the `write` syscall (`rax = 1`) on `stdout`.
- `environment.linux.c` implements `TerminateProcess` using the appropriate `exit` syscall for each supported architecture.
- `main.c` is shared: it just calls `WriteConsole` and then `ExitProcess`.

Because the Linux path does not rely on any external library or dynamic loader data, the resulting code is also naturally position-independent.

---

## Building

The batch scripts are written for a **Windows host** with an LLVM / Clang toolchain installed and available on `PATH`.

Required tools:

- `clang` and `lld` (capable of targeting the chosen triples)
- `llvm-objcopy`
- `llvm-objdump`
- `llvm-strings`

To build all configured targets:

```powershell
# From the repository root
.\build.bat
```

If the build succeeds, you should get a `bin\` directory containing:

- one directory per platform (`bin\windows`, `bin\linux`);
- one sub-directory / file set per architecture (e.g. `windows_amd64`, `linux_i386`);
- for each target, a standard executable plus extracted “PIC blob” and helper files
  (section dump, string dump, and a small size summary).

The exact filenames are produced by `toolchain.bat` and may be tweaked there.

---

## Running the samples

For the **Windows** payloads:

1. Copy the corresponding executable from `bin\windows\…` to a test VM.
2. Run it from a console window.
3. You should see `Hello world!` printed without any external DLL imports beyond the default loader requirements.

For the **Linux** payloads:

1. Copy the desired binary from `bin/linux/…` to a Linux test machine that matches the architecture.
2. Make it executable if needed:
   ```bash
   chmod +x ./linux_amd64   # example
   ./linux_amd64
   ```
3. You should again see `Hello world!` and an immediate clean exit.

> 💡 Keep all experiments inside disposable VMs or containers. This keeps your main system safe and avoids accidentally violating any environment policies (school, work, etc.).

---

## Project layout

```text
src/
  main.c               # Shared entrypoint that prints "Hello world!"
  primitives.h         # Minimal type & integer / pointer definitions
  string.{c,h}         # Small helpers: length + case-insensitive comparisons
  environment.h        # Common macros + platform-specific entry / exit glue
  environment.linux.c  # Linux `TerminateProcess` implementation
  console.h            # Platform-neutral `WriteConsole` declaration
  console.windows.c    # Windows implementation, uses manual API resolution
  console.linux.c      # Linux implementation, uses raw syscalls
  peb.{c,h}            # PEB structures + module enumeration (Windows only)
  pe.{c,h}             # PE header / export directory parsing helpers
linker.script          # lld linker script: pack .text / .rodata into one segment
build.bat              # Top-level build script for all targets
toolchain.bat          # Per-target build & extraction pipeline
```

---

## Strings & data in PIC

Position-independent **code** is straightforward; the hard part is usually **data**:

- Compilers like to place string literals and constants in `.rdata` / `.rodata`.
- When you later extract only a single section (for shellcode-style use), any pointers into those other sections become invalid.
- On x86-64, RIP-relative addressing hides much of this: as long as code and read-only data end up in the same contiguous region, relative references still work.
- On 32-bit x86, the compiler often emits absolute addresses, so the blob must either:
  - compute its own base address at runtime and “fix up” pointers, or
  - avoid pointers entirely (for example by reconstructing strings on the stack).

This repository takes a pragmatic approach:

- the custom `linker.script` keeps `.text` and `.rodata` together in a single loadable segment;
- the code is written to avoid unexpected global data where possible;
- architecture-specific notes in the source highlight where extra relocation work would be needed for more complex payloads, especially on 32-bit x86.

If you extend the project with additional global data or longer strings, keep these constraints in mind so the resulting blob stays truly position-independent.

---

## Limitations

- Only a subset of Windows / NT structures are defined – just enough for this demo.
- Error handling is intentionally minimal to keep the control flow small and obvious.
- The build scripts assume an LLVM toolchain and a Windows host; other setups may require manual changes.
- The Linux path currently uses the traditional syscall numbers; running on very old or unusual kernels may require adjustments.

---

## Research & ethics

This repository is intended for:

- learning how binaries, loaders, and calling conventions work;
- experimenting with compiler output and custom link layouts;
- building better intuition for what “position-independent code” actually means.

It is **not** intended for:

- bypassing security controls,
- running untrusted third-party payloads,
- or any use that would violate laws, school rules, workplace policies, or service terms.

Always:

- work in isolated test environments (VMs, lab machines, or containers);
- only experiment on systems you own or have clear permission to use;
- follow local laws and responsible security-research practices.

---

## Reference

- Original idea and inspiration: [mrzaxaryan / c-pic](https://github.com/mrzaxaryan/c-pic)
