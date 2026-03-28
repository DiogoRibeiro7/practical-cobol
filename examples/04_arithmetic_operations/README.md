# 04 - Arithmetic Operations

## Objective

Learn how to perform arithmetic in COBOL using the four built-in verbs: ADD, SUBTRACT, MULTIPLY, and DIVIDE.

## Concepts covered

- `ADD ... TO ... GIVING ...` — addition
- `SUBTRACT ... FROM ... GIVING ...` — subtraction
- `MULTIPLY ... BY ... GIVING ...` — multiplication
- `DIVIDE ... BY ... GIVING ...` — division
- The `GIVING` clause — stores the result without modifying the operands
- Leading zeros in numeric output (`PIC 999`)
- Integer division truncation

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 04 - Arithmetic Operations
      *> Demonstrates ADD, SUBTRACT, MULTIPLY, and DIVIDE.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ARITHMETIC-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-A         PIC 999 VALUE 15.
       01 WS-B         PIC 999 VALUE 05.
      *> WS-RESULT stores the output of each operation.
       01 WS-RESULT    PIC 999 VALUE 0.

       PROCEDURE DIVISION.
      *> GIVING puts the result in WS-RESULT without
      *> changing WS-A or WS-B.
           ADD WS-A TO WS-B GIVING WS-RESULT.
           DISPLAY "ADD RESULT      : " WS-RESULT.

           SUBTRACT WS-B FROM WS-A GIVING WS-RESULT.
           DISPLAY "SUBTRACT RESULT : " WS-RESULT.

           MULTIPLY WS-A BY WS-B GIVING WS-RESULT.
           DISPLAY "MULTIPLY RESULT : " WS-RESULT.

           DIVIDE WS-A BY WS-B GIVING WS-RESULT.
           DISPLAY "DIVIDE RESULT   : " WS-RESULT.

           STOP RUN.
```

## Walkthrough

**WORKING-STORAGE SECTION** — Three numeric fields are declared. `WS-A` and `WS-B` are the operands, initialized to 15 and 5. `WS-RESULT` holds the output of each operation and starts at 0. All three use `PIC 999`, which means three numeric digits with no decimal point.

**Why English words instead of +, -, *, /?** — COBOL was designed in the late 1950s to be readable by business people, not just programmers. Using full English verbs like `ADD`, `SUBTRACT`, `MULTIPLY`, and `DIVIDE` was a deliberate choice so that managers and auditors could review program logic. This is one of the most distinctive features of the language.

**ADD WS-A TO WS-B GIVING WS-RESULT** — Adds WS-A (15) and WS-B (5), placing the sum (20) into WS-RESULT. In a modern language this is simply `result = a + b`. The `GIVING` clause is key: it tells COBOL to store the result in a separate field without changing WS-A or WS-B. Without `GIVING`, a statement like `ADD WS-A TO WS-B` would modify WS-B in place.

**SUBTRACT WS-B FROM WS-A GIVING WS-RESULT** — Subtracts WS-B (5) from WS-A (15), giving 10. Equivalent to `result = a - b`.

**MULTIPLY WS-A BY WS-B GIVING WS-RESULT** — Multiplies 15 by 5, giving 75. Equivalent to `result = a * b`.

**DIVIDE WS-A BY WS-B GIVING WS-RESULT** — Divides 15 by 5, giving 3. Equivalent to `result = a / b`. Important: COBOL integer division truncates. Since `WS-RESULT` has no decimal places (`PIC 999`), any fractional part is dropped. For example, 17 / 5 would also produce 3, not 3.4.

**Leading zeros in output** — The results display as `020`, `010`, `075`, and `003` rather than `20`, `10`, `75`, and `3`. This is because `PIC 999` defines a three-digit field, and COBOL always displays all the digit positions. To suppress leading zeros you would use an edited picture like `PIC ZZ9`, but that is a topic for a later lesson.

**A preview: COMPUTE** — COBOL also offers the `COMPUTE` verb, which lets you write expressions with familiar operators: `COMPUTE WS-RESULT = WS-A + WS-B`. This is often more convenient for complex formulas and will be covered in a future lesson.

## How to compile and run

```bash
cobc -x -o arithmetic main.cob
./arithmetic
```

## Expected output

```text
ADD RESULT      : 020
SUBTRACT RESULT : 010
MULTIPLY RESULT : 075
DIVIDE RESULT   : 003
```

## Exercises

1. Use `ACCEPT` to read two numbers from the user, then compute and display their sum and product using `ADD` and `MULTIPLY` with `GIVING`.
2. Add a `COMPUTE` statement that calculates `(WS-A + WS-B) * 2` and displays the result. For example: `COMPUTE WS-RESULT = (WS-A + WS-B) * 2`.
3. Change `PIC 999` to `PIC 9(5)` for `WS-RESULT` and multiply two larger numbers (such as 150 and 200) to see how the wider field accommodates bigger values and changes the output formatting.

## What comes next

In lesson 05 you will learn about conditional logic with `IF`, `ELSE`, and `EVALUATE`, giving your programs the ability to make decisions.
