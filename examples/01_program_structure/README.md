# 01 - Program Structure

## Objective

Understand the major divisions of a COBOL program and define your first variable using the `DATA DIVISION`.

## Concepts covered

- The four COBOL divisions: `IDENTIFICATION`, `ENVIRONMENT`, `DATA`, and `PROCEDURE`
- `WORKING-STORAGE SECTION` for program variables
- Level number `01` (top-level data item)
- `PIC X(n)` for defining text fields
- The `VALUE` clause for setting initial values

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 01 - Program Structure
      *> Shows the main divisions of a COBOL program.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. STRUCTURE-DEMO.

      *> DATA DIVISION is where you define all variables.
       DATA DIVISION.
      *> WORKING-STORAGE holds variables that live for the
      *> entire duration of the program.
       WORKING-STORAGE SECTION.
       01 WS-MESSAGE PIC X(30) VALUE "This is a structured program.".

      *> PROCEDURE DIVISION contains the executable logic.
       PROCEDURE DIVISION.
           DISPLAY WS-MESSAGE.
           STOP RUN.
```

## Walkthrough

### The four divisions

A full COBOL program can contain up to four divisions, always in this order:

1. **IDENTIFICATION DIVISION** -- Names the program. Required in every program.
2. **ENVIRONMENT DIVISION** -- Describes the computing environment (file paths, special hardware). Not used in this lesson.
3. **DATA DIVISION** -- Declares every piece of data the program will use.
4. **PROCEDURE DIVISION** -- Contains the executable statements.

Only `IDENTIFICATION DIVISION` is strictly required, but most programs use at least `DATA DIVISION` and `PROCEDURE DIVISION` as well. The `ENVIRONMENT DIVISION` is omitted here because this program does not interact with files or external resources.

### DATA DIVISION and WORKING-STORAGE SECTION

```cobol
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-MESSAGE PIC X(30) VALUE "This is a structured program.".
```

The `DATA DIVISION` is where you declare all variables. Within it, `WORKING-STORAGE SECTION` holds variables that exist for the entire lifetime of the program. Think of it like declaring a variable at the top of a `main` function in C or Python -- it is available everywhere in the procedure code below.

- **`01`** is the level number. Level `01` means this is a top-level data item (not a sub-field of something larger). You will see other level numbers in later lessons.
- **`WS-MESSAGE`** is the variable name. The `WS-` prefix is a common convention that stands for "Working Storage." It is not required by the language, but it makes code easier to read.
- **`PIC X(30)`** defines the picture (data type and size). `X` means alphanumeric (text), and `(30)` means 30 characters wide. If the stored text is shorter than 30 characters, COBOL pads the remaining positions with spaces.
- **`VALUE "This is a structured program."`** sets the initial value. Without a `VALUE` clause the contents of the variable are undefined (often spaces for text fields).

In modern languages this whole line is roughly equivalent to:

```python
ws_message: str = "This is a structured program."  # padded to 30 chars
```

### PROCEDURE DIVISION

```cobol
       PROCEDURE DIVISION.
           DISPLAY WS-MESSAGE.
           STOP RUN.
```

`DISPLAY WS-MESSAGE` prints the contents of the variable. Because `PIC X(30)` is 30 characters wide and the stored text is 30 characters long (including the period), the output fills the field exactly. If the text were shorter, you would see trailing spaces.

## How to compile and run

```bash
cobc -x -o structure main.cob
./structure
```

## Expected output

```text
This is a structured program.
```

Note: depending on the terminal, trailing spaces may pad the output to 30 characters. The visible text is the same either way.

## Exercises

1. **Add a second variable.** Define `WS-AUTHOR` with `PIC X(20)` and a `VALUE` of your name. Add a `DISPLAY WS-AUTHOR` line in the `PROCEDURE DIVISION` and verify both lines print.
2. **Observe truncation.** Change `PIC X(30)` to `PIC X(10)` on `WS-MESSAGE`, recompile, and run. What happens to the text? COBOL silently truncates data that does not fit the picture size.
3. **Remove the VALUE clause.** Delete `VALUE "This is a structured program."` from the definition of `WS-MESSAGE`, recompile, and run. What does `DISPLAY` show? This demonstrates COBOL's default initialization behavior for alphanumeric fields.

## What comes next

In the next lesson you will take a closer look at `PIC` clauses and learn how COBOL handles both text and numeric variables.
