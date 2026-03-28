# 00 - Hello World

## Objective

Write and run the smallest possible COBOL program to understand the basic structure and compilation workflow.

## Concepts covered

- The `IDENTIFICATION DIVISION` and `PROGRAM-ID`
- The `PROCEDURE DIVISION`
- `DISPLAY` statement for printing text
- `STOP RUN` statement for ending a program
- COBOL comment syntax (`*>`)
- Uppercase keyword convention

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 00 - Hello World
      *> The smallest useful COBOL program.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO-WORLD.

       PROCEDURE DIVISION.
           DISPLAY "Hello, COBOL world!".
           STOP RUN.
```

## Walkthrough

### Comments

```cobol
      *> Lesson 00 - Hello World
```

Lines that begin with `*>` are comments. COBOL ignores everything after `*>` on that line. Use comments to describe what your code does, just like `//` in C or `#` in Python.

### IDENTIFICATION DIVISION

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO-WORLD.
```

Every COBOL program starts with the `IDENTIFICATION DIVISION`. Its only required entry is `PROGRAM-ID`, which gives the program a name. Think of it as the label on the outside of the box: it tells the compiler (and other programmers) what this program is called. The name `HELLO-WORLD` is arbitrary; you can choose any valid COBOL name.

### PROCEDURE DIVISION

```cobol
       PROCEDURE DIVISION.
           DISPLAY "Hello, COBOL world!".
           STOP RUN.
```

The `PROCEDURE DIVISION` is where all the executable logic lives. If the `IDENTIFICATION DIVISION` is the label, the `PROCEDURE DIVISION` is the contents of the box.

- **`DISPLAY`** prints text to the terminal. It is the COBOL equivalent of `print` or `console.log`. Here it outputs the string `Hello, COBOL world!`.
- **`STOP RUN`** terminates the program. Without it the program may still end, but including `STOP RUN` is good practice because it makes the intent explicit.

### A note on uppercase

COBOL keywords are written in uppercase by long-standing convention. Modern compilers like GnuCOBOL accept lowercase too, but most COBOL codebases and teaching materials stick with uppercase. This course follows that convention.

## How to compile and run

```bash
cobc -x -o hello main.cob
./hello
```

- `cobc` is the GnuCOBOL compiler.
- `-x` tells it to produce a standalone executable (not a shared module).
- `-o hello` names the output file `hello`.
- `main.cob` is the source file.

## Expected output

```text
Hello, COBOL world!
```

## Exercises

1. **Change the greeting.** Replace `"Hello, COBOL world!"` with a message of your choice, recompile, and run.
2. **Add a second DISPLAY line.** Print your name on a separate line beneath the greeting. Each `DISPLAY` produces its own line of output.
3. **Remove STOP RUN and observe what happens.** Does the program still compile? Does it still run correctly? Think about why.

## What comes next

In the next lesson you will explore the full program structure of COBOL by adding the `DATA DIVISION` and your first variable.
