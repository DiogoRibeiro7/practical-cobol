# 03 - MOVE, ACCEPT, and DISPLAY

## Objective

Learn how to read user input from the terminal, move data between fields, and display output in COBOL.

## Concepts covered

- `ACCEPT` — reads a line of input from the terminal into a data field
- `DISPLAY` — writes text and/or variable contents to the terminal
- `MOVE` — copies data from a source to a destination field
- Space-padding behavior when input is shorter than the PIC size

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 03 - MOVE, ACCEPT, and DISPLAY
      *> Reading user input and moving data between fields.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INPUT-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *> Field to receive raw keyboard input.
       01 WS-RAW-NAME     PIC X(20).
      *> Field to hold a copy after MOVE.
       01 WS-STORED-NAME  PIC X(20).

       PROCEDURE DIVISION.
           DISPLAY "ENTER YOUR NAME: ".
      *> ACCEPT reads one line from the terminal.
           ACCEPT WS-RAW-NAME.
      *> MOVE copies data from one field to another.
           MOVE WS-RAW-NAME TO WS-STORED-NAME.
           DISPLAY "YOU ENTERED: " WS-STORED-NAME.
           STOP RUN.
```

## Walkthrough

**WORKING-STORAGE SECTION** — Two fields are declared, both `PIC X(20)`, meaning each can hold up to 20 alphanumeric characters. `WS-RAW-NAME` receives the raw keyboard input, and `WS-STORED-NAME` holds a copy made with `MOVE`.

**DISPLAY "ENTER YOUR NAME: "** — `DISPLAY` writes text to the terminal. You can pass it a literal string, a variable name, or a combination of both (as the final `DISPLAY` line does). Think of it as the COBOL equivalent of `print()` or `printf`.

**ACCEPT WS-RAW-NAME** — `ACCEPT` pauses the program and waits for the user to type a line of input, then stores that input into the specified field. It works much like `input()` in Python or `scanf` in C. If the user types fewer characters than the field's PIC size, the remaining positions are filled with spaces. So if you type "Ana" into a `PIC X(20)` field, the field contains `"Ana                 "` (Ana followed by 17 spaces).

**MOVE WS-RAW-NAME TO WS-STORED-NAME** — `MOVE` copies data from one field to another. In modern languages this is simply assignment (`stored_name = raw_name`), but in COBOL it is an explicit verb. `MOVE` matters enormously in business COBOL because data is constantly moved between record fields, reformatted, and transformed before being written to reports, files, or screens. A payroll program, for example, might `MOVE` an employee name from an input record into a pay-stub output record, adjusting field sizes along the way.

**DISPLAY "YOU ENTERED: " WS-STORED-NAME** — Displays a literal string followed by the contents of `WS-STORED-NAME` on the same line.

**STOP RUN** — Terminates the program.

## How to compile and run

```bash
cobc -x -o io main.cob
./io
```

## Expected output

The program is interactive. When prompted, the user types their name (for example, "Ana"):

```text
ENTER YOUR NAME:
YOU ENTERED: Ana
```

Notice the trailing spaces after "Ana" — the field is 20 characters wide and the unused positions are filled with spaces.

## Exercises

1. Read a first name and a last name into two separate fields using two `ACCEPT` statements, then display each on its own line (two `DISPLAY` statements).
2. Instead of using `ACCEPT`, `MOVE` a literal string `"HELLO"` directly into `WS-STORED-NAME` and display it. For example: `MOVE "HELLO" TO WS-STORED-NAME`.
3. Try `MOVE`ing a 30-character string into `WS-STORED-NAME` (which is `PIC X(20)`). Observe what happens — COBOL truncates the value to fit the destination field, silently dropping the extra characters on the right.

## What comes next

In lesson 04 you will learn the four arithmetic verbs — ADD, SUBTRACT, MULTIPLY, and DIVIDE — and see how COBOL handles numeric computation.
