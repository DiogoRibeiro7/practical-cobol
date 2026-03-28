# Notes — Lesson 03

## Key terminology

- **ACCEPT** — reads input from the terminal (or system date/time) into a data item
- **MOVE** — copies the value of one data item into another, applying type conversion and padding/truncation rules
- **DISPLAY** — writes one or more data items to the terminal (standard out)
- **Data movement** — the general concept of transferring values between fields; COBOL always copies, never shares references
- **Space padding** — when a shorter value is MOVEd into a longer alphanumeric field, the remaining positions are filled with spaces
- **Truncation** — when a value is too long for the receiving field, COBOL silently cuts it to fit

## Common beginner mistakes

- Expecting MOVE to work like pointer assignment — MOVE always copies the value; changing the source afterward does not affect the target (there are no references or pointers in standard COBOL)
- Forgetting that short values get padded with spaces — MOVEing "Hi" into PIC X(20) fills positions 3-20 with spaces, which can cause unexpected results in comparisons or string operations
- Trying to ACCEPT into a numeric field with non-numeric input — if the user types letters into a PIC 9 field, the result is undefined or causes a runtime error depending on the compiler

## Comparison with modern languages

- `MOVE` is like the `=` assignment operator in Python, Java, JavaScript, and C — but it always copies and applies formatting rules
- `ACCEPT` is like `input()` in Python, `Scanner.nextLine()` in Java, `readline` in Node.js, or `scanf()` in C
- `DISPLAY` is like `print()` in Python, `System.out.println()` in Java, `console.log()` in JavaScript, or `printf()` in C

## Where this pattern appears

- MOVE is one of the most-used COBOL verbs in real systems — data is constantly moved between fields, reformatted, and prepared for output
- Batch programs routinely MOVE data from input record fields to working variables, apply transformations, and MOVE results to output record fields
- ACCEPT is used for interactive programs (CICS screens, terminal input) and for retrieving system information like the current date
