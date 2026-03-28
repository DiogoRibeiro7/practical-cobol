# Setup

This repository uses **GNU COBOL** as the reference compiler.

## Linux

On Debian or Ubuntu:

```bash
sudo apt update
sudo apt install gnucobol
```

On Fedora:

```bash
sudo dnf install gnucobol
```

## macOS

With Homebrew:

```bash
brew install gnu-cobol
```

## Windows

A common option is to use:

- WSL with Ubuntu and GNU COBOL, or
- a MinGW/MSYS2-based GNU COBOL environment

WSL is often the simplest path for a modern development workflow.

## Check installation

```bash
cobc -V
```

## Compile and run

```bash
cobc -x -o hello examples/00_hello_world/main.cob
./hello
```

## Why GNU COBOL?

GNU COBOL is practical for learning because it is:

- open source
- widely available
- good enough for educational and small project work
- close enough to real COBOL learning needs for a first repository
