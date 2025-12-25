# cohsh (Coherent Shell)

A strict, 64-bit clean port of the historical Coherent Operating System Bourne Shell (1993) to modern Linux.

## Overview

`cohsh` is a preservation project dedicated to porting the shell from the Mark Williams Company (MWC) Coherent Operating System. This shell was originally a "clean room" implementation independent of AT&T source code. This port brings it to modern 64-bit systems while maintaining its original logic and behavior.

This port was achieved through an "Invasive Life Support" effort to modernize 30-year-old K&R C code for the 2025 Linux environment.

### Key Modifications
- **64-bit Memory Safety:** The original allocator assumed unaligned pointer access was safe. This port implements unaligned-safe `memcpy` shims for all internal heap headers to prevent SIGBUS and corruption on 64-bit systems.
- **Portability Header:** Introduced `sh_port.h` to shim early 90s K&R/ANSI macros and provide POSIX compatibility for system signals and I/O.
- **Thread-Safe Path Search:** Rewrote `ffind` to eliminate a global buffer dependency that previously caused memory corruption during nested expansions.
- **Robust Signals:** Implemented a `sigaction`-based `sigset` shim to handle the shell's System V signal assumptions on modern Linux kernels.

## Build Requirements

- A modern C compiler (`gcc` or `clang`)
- `make`
- `yacc` or `bison` (for the parser)

## Installation

```sh
# Build the shell and utility
make

# Run the shell
./sh
```

## Running Tests

The port includes a "Paranoid Mode" stress test to verify the stability of the heap and the accuracy of the 64-bit shims:

```sh
./sh stress.sh
```

## Credits

- **Porting & Preservation:** Mario (@wordatet)
- **Engineering Assistance:** Gemini (Google AI)

## Legal & Licensing

The original Coherent source code is licensed under the **3-Clause BSD License**. All porting modifications, patches, and modern build scripts are licensed under the **GNU General Public License v3.0**. See the `LICENSE` file for full details.

---
*Maintained by Mario (@wordatet)*