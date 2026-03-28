# Notes — Lesson 00

## Key terminology

- **PROGRAM-ID** — names the program; required in every COBOL source file
- **DISPLAY** — sends output to the terminal (standard out)
- **STOP RUN** — terminates program execution and returns control to the operating system
- **Division** — the highest-level structural unit in a COBOL program (IDENTIFICATION, ENVIRONMENT, DATA, PROCEDURE)
- **Fixed-format** — traditional COBOL source layout where columns 1-6 are sequence numbers, column 7 is the indicator area, columns 8-11 are Area A, and columns 12-72 are Area B

## Common beginner mistakes

- Forgetting STOP RUN at the end of the PROCEDURE DIVISION, which can cause unpredictable behavior or fall-through into paragraphs
- Forgetting the period at the end of statements — COBOL uses periods as statement terminators, not semicolons or newlines
- Putting code in the wrong column — Area A and Area B rules are strict in fixed-format COBOL and will cause compiler errors if violated

## Comparison with modern languages

- `DISPLAY` is like `print()` in Python, `System.out.println()` in Java, `console.log()` in JavaScript, or `printf()` in C
- `STOP RUN` is like `sys.exit()` in Python, `System.exit(0)` in Java, `process.exit()` in Node.js, or `return 0` from `main()` in C
- The overall structure (divisions, explicit program naming) has no direct equivalent in modern languages — most modern languages let you start writing code immediately without declaring a program skeleton

## Where this pattern appears

- Every COBOL program starts this way — PROGRAM-ID and the division structure are mandatory regardless of what the program does
- Even the largest mainframe batch jobs and CICS online transactions begin with this same skeleton
