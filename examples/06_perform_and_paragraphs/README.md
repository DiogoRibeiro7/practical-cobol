# 06 - PERFORM and Paragraphs

## Objective

Learn how COBOL organizes logic into named paragraphs, how `PERFORM` calls them, and how `PERFORM UNTIL` creates loops.

## Concepts covered

- Paragraphs as named blocks of code in the PROCEDURE DIVISION
- `PERFORM paragraph-name` — call a paragraph and return
- `PERFORM paragraph-name N TIMES` — repeat a paragraph a fixed number of times
- `PERFORM paragraph-name UNTIL condition` — repeat until a condition becomes true
- Why `STOP RUN` must appear before the first paragraph
- Fall-through behavior and how to avoid it
- Paragraph naming conventions (verb-noun style)
- How COBOL loops compare to `for` and `while` in modern languages

## Why paragraphs matter

In lessons 00 through 05, all the logic lived in one flat block inside the PROCEDURE DIVISION. That works for small programs, but real COBOL systems process thousands of records, apply dozens of business rules, and generate multi-page reports. Without structure, the code becomes impossible to follow.

COBOL's answer is **paragraphs** — named blocks of code that you call with `PERFORM`. They serve the same role as functions in Python, methods in Java, or functions in C, but with one important simplification: they take no parameters and return no values. All data is shared through WORKING-STORAGE.

This sounds limiting, but it is a deliberate design choice. COBOL programs are built around **shared record layouts** — the variables in WORKING-STORAGE represent the fields of a business record (employee, invoice, transaction), and every paragraph reads and writes those same fields. The paragraph names describe the business steps: `READ-INPUT`, `VALIDATE-RECORD`, `COMPUTE-TAX`, `WRITE-REPORT-LINE`.

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 06 - PERFORM and Paragraphs
      *> Demonstrates paragraph-based program flow, PERFORM,
      *> PERFORM N TIMES, and PERFORM UNTIL.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PERFORM-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> --- Part 1: employee data for paragraph demo ---
       01 WS-EMPLOYEE-NAME    PIC X(15) VALUE "MARIA SANTOS".
       01 WS-BASE-SALARY      PIC 9(5)  VALUE 03200.
       01 WS-BONUS            PIC 9(5)  VALUE 0.
       01 WS-NET-PAY          PIC 9(5)  VALUE 0.

      *> --- Part 2: counter for PERFORM TIMES ---
       01 WS-LINE-COUNT       PIC 9     VALUE 0.

      *> --- Part 3: counter and total for PERFORM UNTIL ---
       01 WS-COUNTER          PIC 99    VALUE 0.
       01 WS-RUNNING-TOTAL    PIC 9(4)  VALUE 0.

      *> =======================================================
      *> MAIN FLOW
      *> Read this section first. It is the table of contents
      *> for the entire program.
      *> =======================================================
       PROCEDURE DIVISION.

      *> --- Part 1: paragraph-based flow ---
           DISPLAY "========================================".
           DISPLAY " PART 1: Paragraph-based flow".
           DISPLAY "========================================".
           PERFORM COMPUTE-BONUS
           PERFORM SHOW-PAYSLIP

      *> --- Part 2: PERFORM N TIMES ---
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 2: PERFORM 3 TIMES".
           DISPLAY "========================================".
           PERFORM PRINT-SEPARATOR 3 TIMES

      *> --- Part 3: PERFORM UNTIL ---
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 3: PERFORM UNTIL".
           DISPLAY "========================================".
           MOVE 1 TO WS-COUNTER
           MOVE 0 TO WS-RUNNING-TOTAL
           PERFORM ACCUMULATE-STEP
               UNTIL WS-COUNTER > 5
           DISPLAY "Final total: " WS-RUNNING-TOTAL

           STOP RUN.

      *> =======================================================
      *> PARAGRAPHS
      *> Each paragraph handles one clear task.
      *> =======================================================

      *> -------------------------------------------------------
      *> COMPUTE-BONUS
      *> Calculates a 15% bonus on the base salary.
      *> -------------------------------------------------------
       COMPUTE-BONUS.
           MULTIPLY WS-BASE-SALARY BY 15
               GIVING WS-BONUS
           DIVIDE WS-BONUS BY 100
               GIVING WS-BONUS
           ADD WS-BASE-SALARY TO WS-BONUS
               GIVING WS-NET-PAY.

      *> -------------------------------------------------------
      *> SHOW-PAYSLIP
      *> Displays the employee summary.
      *> -------------------------------------------------------
       SHOW-PAYSLIP.
           DISPLAY "Employee : " WS-EMPLOYEE-NAME
           DISPLAY "Base pay : " WS-BASE-SALARY
           DISPLAY "Bonus    : " WS-BONUS
           DISPLAY "Net pay  : " WS-NET-PAY.

      *> -------------------------------------------------------
      *> PRINT-SEPARATOR
      *> Prints a dashed line. Called multiple times by
      *> PERFORM ... TIMES to show repetition.
      *> -------------------------------------------------------
       PRINT-SEPARATOR.
           ADD 1 TO WS-LINE-COUNT
           DISPLAY "--- separator line " WS-LINE-COUNT
                   " ---".

      *> -------------------------------------------------------
      *> ACCUMULATE-STEP
      *> Adds the current counter to the running total,
      *> displays progress, and advances the counter.
      *> Called repeatedly by PERFORM UNTIL.
      *> -------------------------------------------------------
       ACCUMULATE-STEP.
           ADD WS-COUNTER TO WS-RUNNING-TOTAL
           DISPLAY "Step " WS-COUNTER
                   ": total is now " WS-RUNNING-TOTAL
           ADD 1 TO WS-COUNTER.
```

## Walkthrough

The program is split into three parts. Each demonstrates a different way to use `PERFORM`.

### The main flow — reading the program top-down

```cobol
       PROCEDURE DIVISION.
           ...
           PERFORM COMPUTE-BONUS
           PERFORM SHOW-PAYSLIP
           ...
           PERFORM PRINT-SEPARATOR 3 TIMES
           ...
           PERFORM ACCUMULATE-STEP
               UNTIL WS-COUNTER > 5
           ...
           STOP RUN.
```

This block is the program's **table of contents**. By reading just these lines, you know the program computes a bonus, shows a payslip, prints some separators, and then runs an accumulation loop. The details are in the paragraphs below. This top-down style is one of the most important COBOL habits to develop.

**STOP RUN is critical.** It appears before the first paragraph definition. Without it, after the last DISPLAY, execution would "fall through" into `COMPUTE-BONUS` and re-execute every paragraph sequentially. This is the single most common PERFORM-related bug for beginners.

### Part 1 — PERFORM for program structure

```cobol
           PERFORM COMPUTE-BONUS
           PERFORM SHOW-PAYSLIP
```

Each `PERFORM` transfers control to the named paragraph. When that paragraph's last statement finishes, control returns to the line after the `PERFORM`. This is the COBOL equivalent of a function call.

The `COMPUTE-BONUS` paragraph does the math:

```cobol
       COMPUTE-BONUS.
           MULTIPLY WS-BASE-SALARY BY 15
               GIVING WS-BONUS
           DIVIDE WS-BONUS BY 100
               GIVING WS-BONUS
           ADD WS-BASE-SALARY TO WS-BONUS
               GIVING WS-NET-PAY.
```

With a base salary of 3200: first `3200 * 15 = 48000`, then `48000 / 100 = 480` (the bonus), then `3200 + 480 = 3680` (the net pay). Each step stores its result in a WORKING-STORAGE field that the next paragraph can read.

The `SHOW-PAYSLIP` paragraph simply displays the results. Because all data lives in WORKING-STORAGE, it can read `WS-BONUS` and `WS-NET-PAY` without receiving them as parameters.

### How paragraphs are defined

A paragraph is created by writing a name in Area A (starting at column 8), followed by a period:

```cobol
       COMPUTE-BONUS.
           MULTIPLY WS-BASE-SALARY BY 15
               GIVING WS-BONUS
           ...
```

The paragraph ends when the next paragraph name is encountered or the end of the PROCEDURE DIVISION is reached. There is no `END-PARAGRAPH` keyword. This is different from functions in most modern languages, which have explicit closing markers (braces, `end`, or dedent).

**Naming convention:** Use verb-noun style — `COMPUTE-BONUS`, `SHOW-PAYSLIP`, `PRINT-SEPARATOR`. The verb says what the paragraph does, the noun says what it operates on. When the main flow PERFORMs these names in sequence, it reads like a business process description.

### Part 2 — PERFORM N TIMES

```cobol
           PERFORM PRINT-SEPARATOR 3 TIMES
```

This tells COBOL to execute the `PRINT-SEPARATOR` paragraph three times in a row, then continue. Inside the paragraph, `WS-LINE-COUNT` is incremented each time, so the output shows lines numbered 1, 2, 3.

**In Python, this would be:**

```python
for _ in range(3):
    print_separator()
```

`PERFORM ... TIMES` is the simplest form of looping in COBOL. You give it a fixed count and the paragraph runs that many times. The count can also be a variable: `PERFORM PRINT-SEPARATOR WS-REPEAT-COUNT TIMES`.

### Part 3 — PERFORM UNTIL

```cobol
           MOVE 1 TO WS-COUNTER
           MOVE 0 TO WS-RUNNING-TOTAL
           PERFORM ACCUMULATE-STEP
               UNTIL WS-COUNTER > 5
```

`PERFORM UNTIL` is COBOL's general-purpose loop. It works like this:

1. **Check the condition** (`WS-COUNTER > 5`). If already true, skip the loop entirely.
2. **Execute the paragraph** (`ACCUMULATE-STEP`).
3. **Go back to step 1.**

Inside `ACCUMULATE-STEP`, the counter is incremented and the running total is updated:

```cobol
       ACCUMULATE-STEP.
           ADD WS-COUNTER TO WS-RUNNING-TOTAL
           DISPLAY "Step " WS-COUNTER
                   ": total is now " WS-RUNNING-TOTAL
           ADD 1 TO WS-COUNTER.
```

The loop runs with counter values 1, 2, 3, 4, 5. When the counter reaches 6, the condition `> 5` becomes true and the loop stops. The final total is 1+2+3+4+5 = 15.

**Important detail:** The condition is tested **before** each iteration, not after. This means if the condition is already true when the PERFORM is reached, the paragraph never executes. This is the same as a `while` loop in C or Python:

```python
counter = 1
total = 0
while not (counter > 5):     # same as: while counter <= 5
    total += counter
    counter += 1
```

Notice the inversion: COBOL says `UNTIL counter > 5` (stop when true), while most languages say `while counter <= 5` (continue while true). They are logically equivalent, but the phrasing is opposite. This catches many beginners off guard.

### Comparison with modern languages — all three PERFORM forms

| COBOL | Python | C / Java |
| ----- | ------ | -------- |
| `PERFORM DO-WORK` | `do_work()` | `doWork();` |
| `PERFORM DO-WORK 5 TIMES` | `for _ in range(5): do_work()` | `for (int i=0; i<5; i++) doWork();` |
| `PERFORM DO-WORK UNTIL X > 10` | `while not (x > 10): do_work()` | `while (!(x > 10)) doWork();` |

Key differences from functions in modern languages:

- **No parameters.** Paragraphs cannot receive arguments. Data is shared through WORKING-STORAGE.
- **No return values.** Paragraphs do not return results. They write to shared fields instead.
- **No local scope.** Every paragraph can read and modify any WORKING-STORAGE variable. There is no concept of local variables.
- **Implicit boundaries.** Paragraphs end at the next paragraph label, not at a closing brace or keyword.

## How to compile and run

```bash
cobc -x -o perform main.cob
./perform
```

## Expected output

```text
========================================
 PART 1: Paragraph-based flow
========================================
Employee : MARIA SANTOS
Base pay : 03200
Bonus    : 00480
Net pay  : 03680

========================================
 PART 2: PERFORM 3 TIMES
========================================
--- separator line 1 ---
--- separator line 2 ---
--- separator line 3 ---

========================================
 PART 3: PERFORM UNTIL
========================================
Step 01: total is now 0001
Step 02: total is now 0003
Step 03: total is now 0006
Step 04: total is now 0010
Step 05: total is now 0015
Final total: 0015
```

## Exercises

1. **Counting loop.** Write a program with a paragraph called `PRINT-COUNT` that displays the current value of a counter. Use `PERFORM PRINT-COUNT UNTIL WS-COUNT > 10` to print the numbers 1 through 10, one per line. Initialize `WS-COUNT` to 1 and increment it inside the paragraph.

2. **Repeated accumulation.** Create a program that computes the sum of the first 20 positive integers (1 + 2 + ... + 20 = 210). Use a `PERFORM UNTIL` loop with a counter and a running total. Display the final total after the loop ends. Use `PIC 9(4)` for the total field.

3. **Menu loop.** Write an interactive program that displays a menu with three options:
   - 1 = Say hello
   - 2 = Show the date
   - 3 = Quit

   Use `PERFORM SHOW-MENU UNTIL WS-CHOICE = 3`. Inside `SHOW-MENU`, display the menu, ACCEPT the choice, and use `EVALUATE WS-CHOICE` to dispatch to the correct action. This combines lesson 05's EVALUATE with PERFORM UNTIL to create an interactive loop.

4. **Factorial calculator.** Write a program that computes the factorial of 7 (7! = 5040). Start with `WS-RESULT = 1` and `WS-N = 7`. Use `PERFORM MULTIPLY-STEP UNTIL WS-N < 2`, where each step does `MULTIPLY WS-N BY WS-RESULT GIVING WS-RESULT` and then `SUBTRACT 1 FROM WS-N`. Display the final result. Use `PIC 9(5)` for the result.

5. **Payroll with multiple employees.** Extend Part 1 of this lesson: instead of one hardcoded employee, create three employees by calling `PERFORM PROCESS-EMPLOYEE 3 TIMES`. Before each call, MOVE different names and salaries into the working fields. This previews how real batch programs process multiple records with the same paragraph.

## What comes next

In the next lesson you will learn how to format numbers and strings for clean output using edited picture clauses — see [07 - Strings and Formatting](../07_strings_and_formatting/).
