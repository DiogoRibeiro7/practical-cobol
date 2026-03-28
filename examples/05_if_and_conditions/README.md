# 05 - IF, Nested IF, and EVALUATE

## Objective

Learn every way COBOL lets you make decisions: simple `IF`, nested `IF`, and `EVALUATE` — and when to use each one.

## Concepts covered

- `IF` / `ELSE` / `END-IF` — basic conditional branching
- Nested `IF` for multi-way classification
- `EVALUATE TRUE` — COBOL's equivalent of `if / else if / else`
- `EVALUATE variable` — COBOL's equivalent of `switch / case`
- `WHEN OTHER` — the default/fallback branch
- Comparison operators (`=`, `>`, `<`, `>=`, `<=`, `NOT =`)
- `SPACES` as a figurative constant
- When to choose `IF` vs `EVALUATE`

## Why control flow matters

Every useful program needs to make decisions. In business systems, control flow drives the core logic: is this transaction a credit or a debit? Did the student pass? Which tax bracket applies? COBOL gives you two main tools for this:

- **`IF`** — good for true/false decisions and small chains
- **`EVALUATE`** — good when you are testing multiple ranges or matching exact values

This lesson demonstrates both side by side so you can see the difference.

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 05 - IF, Nested IF, and EVALUATE
      *> Comprehensive control flow in COBOL.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONTROL-FLOW.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> Student score to classify (hardcoded so every branch
      *> can be demonstrated in a single run).
       01 WS-SCORE            PIC 999 VALUE 0.

      *> Result fields for each demonstration.
       01 WS-PASS-FAIL        PIC X(6)  VALUE SPACES.
       01 WS-GRADE-IF         PIC X(12) VALUE SPACES.
       01 WS-GRADE-EVAL       PIC X(12) VALUE SPACES.

      *> -------------------------------------------------------
      *> PART 1 — Simple IF / ELSE
      *> -------------------------------------------------------
       PROCEDURE DIVISION.

           DISPLAY "========================================".
           DISPLAY " PART 1: Simple IF / ELSE".
           DISPLAY "========================================".

           MOVE 72 TO WS-SCORE.

           IF WS-SCORE >= 50
               MOVE "PASSED" TO WS-PASS-FAIL
           ELSE
               MOVE "FAILED" TO WS-PASS-FAIL
           END-IF.

           DISPLAY "Score : " WS-SCORE.
           DISPLAY "Result: " WS-PASS-FAIL.

      *> -------------------------------------------------------
      *> PART 2 — Nested IF for detailed classification
      *> -------------------------------------------------------
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 2: Nested IF".
           DISPLAY "========================================".

           MOVE 85 TO WS-SCORE.

           IF WS-SCORE >= 90
               MOVE "EXCELLENT" TO WS-GRADE-IF
           ELSE
               IF WS-SCORE >= 75
                   MOVE "GOOD" TO WS-GRADE-IF
               ELSE
                   IF WS-SCORE >= 50
                       MOVE "AVERAGE" TO WS-GRADE-IF
                   ELSE
                       MOVE "POOR" TO WS-GRADE-IF
                   END-IF
               END-IF
           END-IF.

           DISPLAY "Score : " WS-SCORE.
           DISPLAY "Grade : " WS-GRADE-IF.

      *> -------------------------------------------------------
      *> PART 3 — EVALUATE (the cleaner way)
      *> -------------------------------------------------------
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 3: EVALUATE".
           DISPLAY "========================================".

           MOVE 42 TO WS-SCORE.

           EVALUATE TRUE
               WHEN WS-SCORE >= 90
                   MOVE "EXCELLENT" TO WS-GRADE-EVAL
               WHEN WS-SCORE >= 75
                   MOVE "GOOD" TO WS-GRADE-EVAL
               WHEN WS-SCORE >= 50
                   MOVE "AVERAGE" TO WS-GRADE-EVAL
               WHEN OTHER
                   MOVE "POOR" TO WS-GRADE-EVAL
           END-EVALUATE.

           DISPLAY "Score : " WS-SCORE.
           DISPLAY "Grade : " WS-GRADE-EVAL.

      *> -------------------------------------------------------
      *> PART 4 — EVALUATE with exact values
      *> -------------------------------------------------------
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 4: EVALUATE with exact values".
           DISPLAY "========================================".

           MOVE 3 TO WS-SCORE.

           EVALUATE WS-SCORE
               WHEN 1
                   DISPLAY "Quarter: Q1 (Jan-Mar)"
               WHEN 2
                   DISPLAY "Quarter: Q2 (Apr-Jun)"
               WHEN 3
                   DISPLAY "Quarter: Q3 (Jul-Sep)"
               WHEN 4
                   DISPLAY "Quarter: Q4 (Oct-Dec)"
               WHEN OTHER
                   DISPLAY "Quarter: INVALID"
           END-EVALUATE.

           STOP RUN.
```

## Walkthrough

This program is split into four parts. Each part demonstrates a different branching technique using the same kind of problem — classifying a numeric value.

### Data definitions

```cobol
       01 WS-SCORE            PIC 999 VALUE 0.
       01 WS-PASS-FAIL        PIC X(6)  VALUE SPACES.
       01 WS-GRADE-IF         PIC X(12) VALUE SPACES.
       01 WS-GRADE-EVAL       PIC X(12) VALUE SPACES.
```

`WS-SCORE` is a three-digit numeric field reused across all four parts. The result fields are alphanumeric and initialized with `SPACES`, a figurative constant that fills the entire field with blank characters. `SPACES` is useful because it ensures the field starts clean — if you later MOVE a shorter string in, the remaining positions are filled with spaces (not leftover garbage).

### Part 1 — Simple IF / ELSE

```cobol
           MOVE 72 TO WS-SCORE.

           IF WS-SCORE >= 50
               MOVE "PASSED" TO WS-PASS-FAIL
           ELSE
               MOVE "FAILED" TO WS-PASS-FAIL
           END-IF.
```

This is the simplest form of branching. The condition `WS-SCORE >= 50` is either true or false. If true, the first block runs. If false, the `ELSE` block runs. `END-IF` closes the scope.

The score is 72, so `72 >= 50` is true, and `WS-PASS-FAIL` receives "PASSED".

**In Python this would be:**

```python
if score >= 50:
    result = "PASSED"
else:
    result = "FAILED"
```

### Part 2 — Nested IF

```cobol
           IF WS-SCORE >= 90
               MOVE "EXCELLENT" TO WS-GRADE-IF
           ELSE
               IF WS-SCORE >= 75
                   MOVE "GOOD" TO WS-GRADE-IF
               ELSE
                   IF WS-SCORE >= 50
                       MOVE "AVERAGE" TO WS-GRADE-IF
                   ELSE
                       MOVE "POOR" TO WS-GRADE-IF
                   END-IF
               END-IF
           END-IF.
```

When you need more than two outcomes, you can nest `IF` statements inside the `ELSE` branch. The logic works top-down:

1. Is the score >= 90? If yes: EXCELLENT. If no, continue.
2. Is the score >= 75? If yes: GOOD. If no, continue.
3. Is the score >= 50? If yes: AVERAGE. If no: POOR.

With score = 85, the first test (>= 90) is false, the second test (>= 75) is true, so the result is "GOOD".

**The problem with nesting:** Each level adds indentation and a matching `END-IF`. With four or five levels, the code becomes hard to read. This is where `EVALUATE` becomes the better choice.

**In C or Java this pattern is written as `else if`:**

```java
if (score >= 90) grade = "EXCELLENT";
else if (score >= 75) grade = "GOOD";
else if (score >= 50) grade = "AVERAGE";
else grade = "POOR";
```

COBOL does not have a built-in `ELSE IF` keyword, but `EVALUATE` fills that role.

### Part 3 — EVALUATE TRUE (range-based)

```cobol
           EVALUATE TRUE
               WHEN WS-SCORE >= 90
                   MOVE "EXCELLENT" TO WS-GRADE-EVAL
               WHEN WS-SCORE >= 75
                   MOVE "GOOD" TO WS-GRADE-EVAL
               WHEN WS-SCORE >= 50
                   MOVE "AVERAGE" TO WS-GRADE-EVAL
               WHEN OTHER
                   MOVE "POOR" TO WS-GRADE-EVAL
           END-EVALUATE.
```

`EVALUATE TRUE` means "find the first `WHEN` condition that is true and execute that branch." COBOL checks each `WHEN` from top to bottom and stops at the first match. `WHEN OTHER` is the fallback — it runs if none of the conditions matched.

This produces exactly the same result as the nested IF in Part 2, but the code is flat and easy to scan. Each classification is on its own `WHEN` line with no nesting.

With score = 42: none of the first three conditions are true, so `WHEN OTHER` fires and the result is "POOR".

**In modern languages, this is like a chain of `else if` or Python's `match` statement:**

```python
if score >= 90:   grade = "EXCELLENT"
elif score >= 75: grade = "GOOD"
elif score >= 50: grade = "AVERAGE"
else:             grade = "POOR"
```

### Part 4 — EVALUATE with exact values

```cobol
           EVALUATE WS-SCORE
               WHEN 1
                   DISPLAY "Quarter: Q1 (Jan-Mar)"
               WHEN 2
                   DISPLAY "Quarter: Q2 (Apr-Jun)"
               WHEN 3
                   DISPLAY "Quarter: Q3 (Jul-Sep)"
               WHEN 4
                   DISPLAY "Quarter: Q4 (Oct-Dec)"
               WHEN OTHER
                   DISPLAY "Quarter: INVALID"
           END-EVALUATE.
```

When you write `EVALUATE WS-SCORE` (instead of `EVALUATE TRUE`), COBOL compares the variable's value directly against each `WHEN` value. This is the exact equivalent of `switch/case` in C, Java, or JavaScript:

```java
switch (score) {
    case 1: System.out.println("Q1"); break;
    case 2: System.out.println("Q2"); break;
    case 3: System.out.println("Q3"); break;
    case 4: System.out.println("Q4"); break;
    default: System.out.println("INVALID");
}
```

A key difference: COBOL `EVALUATE` does **not** fall through. Each `WHEN` branch runs independently. There is no need for `break` statements.

With score = 3, the third `WHEN` matches and the output is "Quarter: Q3 (Jul-Sep)".

### When to use IF vs EVALUATE

| Situation | Use |
| --------- | --- |
| Simple yes/no decision | `IF` / `ELSE` |
| Two or three branches | `IF` / `ELSE` is fine |
| Four or more range-based branches | `EVALUATE TRUE` |
| Matching a variable against exact values | `EVALUATE variable` |
| Complex compound conditions with AND/OR | `IF` (EVALUATE cannot combine conditions with AND/OR) |

**Rule of thumb:** if you find yourself nesting more than two `IF` statements, switch to `EVALUATE`.

## How to compile and run

```bash
cobc -x -o control main.cob
./control
```

## Expected output

```text
========================================
 PART 1: Simple IF / ELSE
========================================
Score : 072
Result: PASSED

========================================
 PART 2: Nested IF
========================================
Score : 085
Grade : GOOD

========================================
 PART 3: EVALUATE
========================================
Score : 042
Grade : POOR

========================================
 PART 4: EVALUATE with exact values
========================================
Quarter: Q3 (Jul-Sep)
```

Note that scores display with leading zeros (072, 085, 042) because `PIC 999` always shows all three digit positions.

## Exercises

1. **Add a fifth classification.** Extend Part 3 to include a "VERY GOOD" band for scores from 80 to 89, so the full scale is: POOR (< 50), AVERAGE (50-74), GOOD (75-79), VERY GOOD (80-89), EXCELLENT (90+). Update both the nested IF version and the EVALUATE version. Which one was easier to change?

2. **Make it interactive.** Replace the hardcoded `MOVE 72 TO WS-SCORE` in Part 1 with `ACCEPT WS-SCORE` so the user can type a score. Add an input validation check: if `WS-SCORE > 100`, display "INVALID SCORE" and skip the pass/fail check. This teaches you how to guard against bad input.

3. **Salary band classifier with EVALUATE.** Write a new program that classifies an employee's annual salary into bands:
   - Below 25000: "JUNIOR"
   - 25000 to 49999: "MID-LEVEL"
   - 50000 to 79999: "SENIOR"
   - 80000 and above: "EXECUTIVE"
   Use `EVALUATE TRUE` with `WHEN salary >= threshold` conditions. Display the salary and its band.

4. **Day-of-week with EVALUATE.** Write a program that accepts a number 1-7 and displays the day name (1 = Monday, 7 = Sunday). Use `EVALUATE WS-DAY-NUMBER` with exact `WHEN` values. Add `WHEN OTHER` to handle invalid input.

5. **88-level condition names.** Rewrite the pass/fail check from Part 1 using 88-level condition names. Under `WS-SCORE`, define:

   ```cobol
          88 SCORE-PASS    VALUES 50 THRU 100.
          88 SCORE-FAIL    VALUES 0 THRU 49.
   ```

   Then replace `IF WS-SCORE >= 50` with `IF SCORE-PASS`. This is the idiomatic COBOL way to express named business rules. The condition reads like English: "if score passes."

## What comes next

In the next lesson you will learn how to organize your code into reusable paragraphs using `PERFORM` — see [06 - PERFORM and Paragraphs](../06_perform_and_paragraphs/).
