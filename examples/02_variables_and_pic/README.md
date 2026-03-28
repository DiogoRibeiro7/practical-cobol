# 02 - Variables and PIC

## Objective

Learn how COBOL defines and formats data using `PIC` (picture) clauses for both text and numeric fields.

## Concepts covered

- `PIC X(n)` for alphanumeric (text) fields
- `PIC 9(n)` and `PIC 999` for numeric fields
- Space-padding in text fields
- Leading-zero display in numeric fields
- The `WS-` naming convention
- A reference table of common PIC symbols

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 02 - Variables and PIC
      *> Demonstrates how COBOL defines data with PIC clauses.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VARIABLE-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *> PIC X(20) reserves 20 characters for text.
       01 WS-NAME     PIC X(20) VALUE "ALICE".
      *> PIC 999 reserves exactly 3 numeric digits.
       01 WS-AGE      PIC 999   VALUE 27.
      *> Another 3-digit numeric field.
       01 WS-SCORE    PIC 999   VALUE 095.

       PROCEDURE DIVISION.
           DISPLAY "NAME  : " WS-NAME.
           DISPLAY "AGE   : " WS-AGE.
           DISPLAY "SCORE : " WS-SCORE.
           STOP RUN.
```

## Walkthrough

### PIC X -- alphanumeric fields

```cobol
       01 WS-NAME     PIC X(20) VALUE "ALICE".
```

`PIC X(20)` reserves a fixed-width field of 20 characters. The value `"ALICE"` is only 5 characters long, so COBOL fills the remaining 15 positions with spaces. When you `DISPLAY` this variable you will see `ALICE` followed by trailing spaces. This is not a bug -- it is how COBOL handles fixed-width text. Every alphanumeric field is always exactly the size its `PIC` declares, no more and no less.

In a modern language this is roughly equivalent to:

```python
ws_name = "ALICE".ljust(20)  # "ALICE               "
```

### PIC 9 -- numeric fields

```cobol
       01 WS-AGE      PIC 999   VALUE 27.
       01 WS-SCORE    PIC 999   VALUE 095.
```

`PIC 999` means "three numeric digits." You can also write this as `PIC 9(3)` -- the two forms are identical. Because the field is exactly three digits wide:

- The value `27` is stored and displayed as `027` (padded with a leading zero).
- The value `095` is stored and displayed as `095`.

COBOL always displays the full width of a numeric picture, including leading zeros. This behavior is intentional: many business systems (banking, insurance, government) rely on fixed-width numeric output for reports and file formats.

### The WS- prefix convention

All three variable names start with `WS-`. This stands for Working Storage and is a widely used naming convention in COBOL shops. It instantly tells a reader that the variable lives in `WORKING-STORAGE SECTION`. The compiler does not require it, but adopting the convention makes large programs much easier to navigate.

### Common PIC symbols -- quick reference

| Symbol | Meaning | Example | Holds |
| -------- | --------- | --------- | ------- |
| `X` | Any character (alphanumeric) | `PIC X(10)` | Up to 10 characters of text |
| `9` | A single numeric digit | `PIC 9(5)` | A 5-digit unsigned integer |
| `A` | A single alphabetic character | `PIC A(15)` | Up to 15 letters (no digits) |
| `V` | Implied decimal point | `PIC 9(3)V99` | 3 digits, decimal, 2 digits (e.g. 123.45) |
| `S` | Sign (positive or negative) | `PIC S9(4)` | A signed 4-digit integer |
| `9(n)` | Shorthand repeat | `PIC 9(7)` | Same as `PIC 9999999` |

You will use `V` and `S` in later lessons when you work with arithmetic and signed numbers.

### DISPLAY with concatenation

```cobol
           DISPLAY "NAME  : " WS-NAME.
```

`DISPLAY` can print multiple items on one line by listing them one after another separated by spaces. Here the literal `"NAME  : "` and the variable `WS-NAME` are joined together in the output. No explicit concatenation operator is needed.

## How to compile and run

```bash
cobc -x -o vars main.cob
./vars
```

## Expected output

```text
NAME  : ALICE
AGE   : 027
SCORE : 095
```

The `NAME` line shows `ALICE` followed by 15 trailing spaces because `PIC X(20)` is 20 characters wide. The `AGE` and `SCORE` lines show leading zeros because `PIC 999` always displays three digits.

## Exercises

1. **Add a new variable.** Define `WS-CITY` with `PIC X(15)` and a `VALUE` of your city name. Add a `DISPLAY` line for it and verify the output, paying attention to any trailing space padding.
2. **Shrink a numeric picture.** Change `WS-AGE` from `PIC 999` to `PIC 99`, recompile, and run. What happens to the displayed value? Think about what COBOL does when a value does not fit the picture size.
3. **Predict the output.** Create a new variable `WS-CODE` with `PIC 9(5)` and `VALUE 42`. Before you compile, write down what you think the output will be. Then compile and check. The answer demonstrates how COBOL zero-pads numeric fields to fill the full picture width.

## What comes next

In the next lesson you will learn how to move data between variables and accept input from the user with the `MOVE` and `ACCEPT` statements.
