# Setup

This repository uses **GnuCOBOL** as the compiler for all examples and exercises. You do not need a mainframe or a special enterprise environment to follow the course.

The goal of setup is simple:

1. install `cobc`
2. confirm it works
3. compile one lesson

If you can do those three things, you are ready to start.

## Linux

### Debian or Ubuntu

```bash
sudo apt update
sudo apt install gnucobol
```

### Fedora

```bash
sudo dnf install gnucobol
```

## macOS

With Homebrew:

```bash
brew install gnu-cobol
```

## Windows

The simplest learning setup is usually **WSL with Ubuntu**.

Typical path:

1. install WSL
2. install Ubuntu from the Microsoft Store
3. open the Ubuntu terminal
4. run the Debian/Ubuntu install commands from this page

This keeps the environment close to the Linux commands used in the repository.

Another option is an MSYS2 or MinGW-based GnuCOBOL environment, but WSL is usually easier for beginners to follow.

## Confirm the compiler

Run:

```bash
cobc -V
```

If GnuCOBOL is installed correctly, you should see version information. If the command is not found, the compiler is either not installed or not on your `PATH`.

## Compile your first lesson

From the repository root:

```bash
cobc -x -o hello examples/00_hello_world/main.cob
./hello
```

You can also use the helper script:

```bash
./scripts/run_example.sh examples/00_hello_world
```

If you only want to check compilation:

```bash
./scripts/compile_lesson.sh examples/00_hello_world
```

## Common beginner issues

### `cobc: command not found`

The compiler is not installed, or your shell cannot find it. Re-check the install step and open a new terminal session.

### The program compiles but does not run with `./hello`

On some systems the output file may be `hello.exe` or may need a different shell environment. Check the current directory and run the generated file directly.

### File-based lessons cannot find their data file

Run the program from the lesson directory or use the repository scripts. Many lesson examples use relative paths such as `data/sales.dat`, so the working directory matters.

### Windows path confusion

If you are using WSL, keep the compile and run commands inside the Linux shell. Mixing Windows and Linux toolchains usually creates avoidable path problems.

## Why GnuCOBOL for this course?

GnuCOBOL is a good fit because it is:

- easy to install on common systems
- good enough for practical learning
- close enough to real COBOL workflows to teach the right habits
- simple to use in local scripts and CI

The lessons teach COBOL itself. GnuCOBOL is just the tool that makes the examples runnable.
