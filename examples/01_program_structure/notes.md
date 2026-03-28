# Notes — Lesson 01

## Key terminology

- **IDENTIFICATION DIVISION** — identifies the program (contains PROGRAM-ID and optional metadata)
- **DATA DIVISION** — declares all data items (variables, records, file descriptions) used by the program
- **WORKING-STORAGE SECTION** — the section within DATA DIVISION where program variables are defined; values persist for the life of the program
- **PROCEDURE DIVISION** — contains the executable logic (the actual instructions the program runs)
- **Level number (01)** — indicates the hierarchy of a data item; 01 is a top-level record or standalone variable
- **PIC** (PICTURE) — defines the type and size of a data item (e.g., PIC X(10) for 10 alphanumeric characters)
- **VALUE** — assigns an initial value to a data item at compile time

## Common beginner mistakes

- Putting divisions in the wrong order — COBOL requires IDENTIFICATION, then ENVIRONMENT, then DATA, then PROCEDURE, and the compiler rejects anything else
- Missing section headers — for example, declaring variables directly in DATA DIVISION without specifying WORKING-STORAGE SECTION first
- Forgetting the period after division and section names — `DATA DIVISION.` and `WORKING-STORAGE SECTION.` both require a trailing period

## Comparison with modern languages

- The four divisions are conceptually like a class with metadata (IDENTIFICATION), configuration (ENVIRONMENT), fields/member variables (DATA), and methods (PROCEDURE)
- WORKING-STORAGE is like global variables in C, class-level fields in Java, or module-level variables in Python — they are accessible from anywhere in the PROCEDURE DIVISION
- The rigid structure has no direct parallel in Python, JavaScript, or most modern languages, which allow interleaving declarations and logic freely

## Where this pattern appears

- Every COBOL program uses this skeleton — there is no way to write a valid COBOL program without at least IDENTIFICATION DIVISION and PROCEDURE DIVISION
- Large enterprise systems may have thousands of programs, and every one follows this same division structure
