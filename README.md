# quine-relay-nix

A Nix flake that provides all 128 programming language tools needed to run
[mame/quine-relay](https://github.com/mame/quine-relay) — a Ruby program that
generates a Rust program that generates a Scala program that generates ...
(through 128 languages in total) ... a REXX program that generates the original
Ruby program again.

## Quick start

```sh
git clone --branch nix https://github.com/siraben/quine-relay.git
cd quine-relay
nix build -L    # builds the environment and runs all 128 steps in the sandbox
```

Supported system: **x86_64-linux**. Both Nixpkgs and the relay source are pinned
in `flake.lock`. The build runs upstream's `make check`: it compares the final
Ruby program byte-for-byte and checks every intermediate checksum. `result/`
contains `QR.rb`, `QR2.rb`, and the verified `SHA256SUMS`.

```sh
nix fmt             # Nixpkgs' nixfmt formatter
nix flake check -L  # nixfmt, Statix, Deadnix, and the complete relay build
nix flake update   # update all inputs; rerun checks afterwards
```

For interactive work:

```sh
git clone https://github.com/mame/quine-relay.git upstream
nix develop
cd upstream
make check
```

The interactive checkout is independent of the locked build source; use the
`relay` revision in `flake.lock` to reproduce that exact version.

## What this provides

`nix develop` gives you a shell with every compiler, interpreter, and tool the
relay needs. No system packages, no Docker, no Ubuntu — just Nix.

Custom packages not in nixpkgs (or packaged for relay compatibility):

| Package | Language | Notes |
|---------|----------|-------|
| `lazyk` | Lazy K | Single-file C build |
| `ratfor` | Ratfor | Fortran preprocessor |
| `cimfomfa` | — | C library dependency of zoem |
| `zoem` | Zoem | Patched for C23 `bool` keyword |
| `velato` | Velato | Built from source with mono/xbuild |
| `velato-01` | Velato 0.1 | Prebuilt binary for quine-relay compat |
| `cfunge` | Befunge | CMake build |
| `squirrel` | Squirrel | CMake build |
| `nickle` | Nickle | Meson build |
| `spl2c` | Shakespeare | SPL-to-C transpiler + libspl |
| `livescript` | LiveScript | npm package |
| `mustache-cli` | Mustache | Ruby gem |
| `afnix` | AFNIX | Debian source, using its supported GCC 14 toolchain |
| `genius` | GEL/Genius | GNOME project, CLI-only |
| `yorick` | Yorick | Custom build system with path fixes |
| `gpt-portugol` | G-Portugol | Requires ANTLR 2.7 |
| `parser3` | Parser 3 | Patched nested ltdl autotools |
| `swift-bin` | Swift | Prebuilt binary with Nix sysroot wrapper |
| `gambas3` | Gambas | Full build with gbr3 argv[0] fix |
| `ksh93` | ksh | Maintained 93u+m; Nixpkgs' Ksh 2020 is incompatible |
| `gm2` | Modula-2 | GCC rebuilt with `--enable-languages=c,c++,m2,objc` |
| `acme-chef` | Chef | Perl Acme::Chef module |
| `vendor-env` | — | Pre-built vendor/local tree |

The old INTERCAL, npiet, Icon, and mbedTLS overrides are no longer needed.
The sole Nixpkgs source patch fixes Gnuplot 6.0.5's long-line reader; 6.0.6
still has the same regression. Gambas' unused legacy PDF backend is disabled
instead of patching it for newer Poppler.

The shell selects Scala 2, TypeScript 5, .NET 10, and Java 25 to match the
upstream interfaces. It uses Nixpkgs' bootstrap Gforth because the newer
interpreter depends on a broken SWIG fork. PHP deprecation notices and .NET's
online NuGet audit are disabled so they cannot corrupt generated programs.

Compatibility wrappers bridge Nix and the Makefile's expectations:

| Wrapper | Why |
|---------|-----|
| `make` | Injects `CLASSPATH` with `aspectjrt.jar` |
| `gcc` | Routes `.m` files to ObjC GCC; `-std=gnu89` for INTERCAL |
| `gdc` | Translates gdc flags to ldc2 |
| `stty` | Silences errors when no terminal is present |
| `scilab-cli` | Explicit headless mode and Nix-provided terminal definitions |
| `clojure` | Uses the bundled runtime without Maven downloads |
| `gap` | Disables unused package autoloading and its stdout notices |
| `java` / `javac` | Selects Java 25 ahead of propagated older JDKs |
| `gbs3` / `gbr3` | Fixes Gambas Qt wrapper argv[0] detection |
| `lci` | Maps to `lolcode-lci` |
| `bsh` | Runs BeanShell JAR via `java -classpath` |
| `lua5.3` | Symlink to `lua` (nixpkgs binary name) |

## The 128 languages

Ruby → Rust → Scala → Scheme → Scilab → sed → Shakespeare → S-Lang →
Squirrel → Standard ML → Subleq → SurgeScript → Swift → Tcl → tcsh → Thue →
TypeScript → Unlambda → Vala → Velato → Verilog → Vimscript → Visual Basic →
WebAssembly (binary) → WebAssembly (text) → Whitespace → XSLT → Yabasic →
Yorick → Zoem → zsh → Ada → AFNIX → Aheui → ALGOL 68 → Ante →
AspectJ → Asymptote → ATS → Awk → bash → bc → BeanShell → Befunge → BLC8 →
Brainfuck → C → C++ → C# → Chef → Clojure → CMake → COBOL → CoffeeScript →
Common Lisp → Crystal → D → dc → Dhall → Elixir → Emacs Lisp → Erlang →
Execline → F# → FALSE → Fennel → Flex → Fish → Forth → FORTRAN 77 → Fortran 90 →
Gambas script → GAP → GDB → GEL (Genius) → Gnuplot → Go → GolfScript →
G-Portugol → Grass → Groovy → Gzip → Haskell → Haxe → Icon → INTERCAL →
Jasmin → Java → JavaScript → Jq → JSFuck → Kotlin → ksh → Lazy K →
LiveScript → LLVM asm → LOLCODE → Lua → M4 → Makefile → MiniZinc →
Modula-2 → MSIL → Mustache → NASM → Neko → Nickle → Nim → Objective-C →
OCaml → Octave → Ook! → PARI/GP → Parser 3 → Pascal → Perl 5 → Perl 6 →
PHP → Piet → Pike → PostScript → Prolog → Promela (Spin) → Python → R →
Ratfor → rc → REXX → **Ruby**

## License

The Nix packaging code in this repository is available under the MIT license.
The quine-relay itself is MIT-licensed by [Yusuke Endoh](https://github.com/mame/quine-relay).
