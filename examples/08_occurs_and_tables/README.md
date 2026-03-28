# 08 - OCCURS and Tables

## Objective

Learn how COBOL stores repeated data in fixed-size tables using the `OCCURS` clause, how to access elements by subscript, and how to iterate with `PERFORM VARYING`.

## Concepts covered

- `OCCURS N TIMES` — declaring a table (array) of fixed size
- Subscript access with parentheses: `WS-STU-NAME(1)`, `WS-STU-GRADE(3)`
- Group-level OCCURS — a table where each element contains multiple fields (a record)
- `PERFORM VARYING` — the COBOL `for` loop with explicit start, step, and end
- Accumulating a total and a count while iterating
- Computing an average with integer division
- Combining `IF` inside a loop to classify table elements

## What is a table in COBOL?

A **table** is COBOL's version of an array. It stores a fixed number of identically structured elements in contiguous memory. You declare it with the `OCCURS` clause:

```cobol
       05 WS-GRADE PIC 999 OCCURS 5 TIMES.
```

This creates five separate `PIC 999` fields, accessed as `WS-GRADE(1)` through `WS-GRADE(5)`.

Tables can also hold **groups** — each element can contain multiple fields, like a row in a spreadsheet:

```cobol
       05 WS-STUDENT OCCURS 5 TIMES.
           10 WS-STU-NAME  PIC X(15).
           10 WS-STU-GRADE PIC 999.
```

Now each element is a record with a name and a grade. You access individual fields with `WS-STU-NAME(3)` or `WS-STU-GRADE(3)`.

### How this compares to other languages

| COBOL | Python | Java | C |
| ----- | ------ | ---- | - |
| `OCCURS 5 TIMES` | `[None] * 5` | `new int[5]` | `int arr[5]` |
| `WS-GRADE(1)` | `grades[0]` | `grades[0]` | `grades[0]` |
| Fixed size, set at compile time | Dynamic, can append | Fixed (array) or dynamic (ArrayList) | Fixed (array) or dynamic (malloc) |
| 1-based subscripts | 0-based | 0-based | 0-based |

The two biggest differences:

1. **COBOL subscripts start at 1**, not 0. The first element is `(1)`, the last in a 5-element table is `(5)`. This matches how business users count: month 1, employee 1, region 1.
2. **COBOL tables cannot grow or shrink.** The size is fixed at compile time. There is no `append()` or `push()`. This is a deliberate design — COBOL programs process data of known structure (employee records, transactions, monthly totals), so the size is always predictable.

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 08 - OCCURS and Tables
      *> Stores student records in a table, iterates with
      *> PERFORM VARYING, and computes totals and averages.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TABLE-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> -------------------------------------------------------
      *> A table of 5 student records.
      *> Each entry is a group with a name and a grade.
      *> OCCURS creates 5 copies of this group in memory.
      *> -------------------------------------------------------
       01 WS-CLASS-TABLE.
           05 WS-STUDENT OCCURS 5 TIMES.
               10 WS-STU-NAME   PIC X(15).
               10 WS-STU-GRADE  PIC 999.

      *> Loop counter for PERFORM VARYING.
       01 WS-IDX              PIC 9  VALUE 0.

      *> Accumulators and results.
       01 WS-TOTAL-GRADE      PIC 9(4) VALUE 0.
       01 WS-AVERAGE          PIC 999  VALUE 0.
       01 WS-PASS-COUNT       PIC 9    VALUE 0.
       01 WS-STUDENT-COUNT    PIC 9    VALUE 5.

      *> Display line for formatted output.
       01 WS-DETAIL-LINE.
           05 WS-DL-NUM       PIC 9.
           05 FILLER           PIC X(2) VALUE ". ".
           05 WS-DL-NAME      PIC X(15).
           05 FILLER           PIC X(2) VALUE "  ".
           05 WS-DL-GRADE     PIC ZZ9.
           05 FILLER           PIC X(2) VALUE "  ".
           05 WS-DL-STATUS    PIC X(6).

       PROCEDURE DIVISION.

      *> =====================================================
      *> STEP 1: Populate the table with student data.
      *> =====================================================
           PERFORM LOAD-STUDENTS

      *> =====================================================
      *> STEP 2: Display all students with pass/fail status.
      *> =====================================================
           DISPLAY "==========================================="
           DISPLAY " CLASS GRADE REPORT"
           DISPLAY "==========================================="
           DISPLAY " "
           DISPLAY "#  Name             Grade  Status"
           DISPLAY "-------------------------------------------"

           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > WS-STUDENT-COUNT
               PERFORM DISPLAY-STUDENT
           END-PERFORM

      *> =====================================================
      *> STEP 3: Compute and display summary statistics.
      *> =====================================================
           DISPLAY "-------------------------------------------"

           DIVIDE WS-TOTAL-GRADE BY WS-STUDENT-COUNT
               GIVING WS-AVERAGE

           DISPLAY " "
           DISPLAY "Total grades : " WS-TOTAL-GRADE
           DISPLAY "Average grade: " WS-AVERAGE
           DISPLAY "Students who passed (>= 50): " WS-PASS-COUNT
           DISPLAY " of " WS-STUDENT-COUNT

           STOP RUN.

      *> -------------------------------------------------------
      *> LOAD-STUDENTS
      *> Populates each table entry with a name and grade.
      *> In a real program, this data would come from a file.
      *> -------------------------------------------------------
       LOAD-STUDENTS.
           MOVE "ALICE JOHNSON" TO WS-STU-NAME(1)
           MOVE 082             TO WS-STU-GRADE(1)

           MOVE "BOB MARTINEZ"  TO WS-STU-NAME(2)
           MOVE 045             TO WS-STU-GRADE(2)

           MOVE "CAROL DAVIS"   TO WS-STU-NAME(3)
           MOVE 091             TO WS-STU-GRADE(3)

           MOVE "DAVID CHEN"    TO WS-STU-NAME(4)
           MOVE 067             TO WS-STU-GRADE(4)

           MOVE "EVA KOWALSKI"  TO WS-STU-NAME(5)
           MOVE 038             TO WS-STU-GRADE(5).

      *> -------------------------------------------------------
      *> DISPLAY-STUDENT
      *> Formats and displays one student row.
      *> Also accumulates the total and counts passes.
      *> -------------------------------------------------------
       DISPLAY-STUDENT.
      *> Build the display line.
           MOVE WS-IDX              TO WS-DL-NUM
           MOVE WS-STU-NAME(WS-IDX) TO WS-DL-NAME
           MOVE WS-STU-GRADE(WS-IDX) TO WS-DL-GRADE

      *> Determine pass or fail.
           IF WS-STU-GRADE(WS-IDX) >= 50
               MOVE "PASS" TO WS-DL-STATUS
               ADD 1 TO WS-PASS-COUNT
           ELSE
               MOVE "FAIL" TO WS-DL-STATUS
           END-IF

      *> Display the formatted line and accumulate.
           DISPLAY WS-DETAIL-LINE
           ADD WS-STU-GRADE(WS-IDX) TO WS-TOTAL-GRADE.
```

## Walkthrough

### The table definition — group-level OCCURS

```cobol
       01 WS-CLASS-TABLE.
           05 WS-STUDENT OCCURS 5 TIMES.
               10 WS-STU-NAME   PIC X(15).
               10 WS-STU-GRADE  PIC 999.
```

This is the most important new concept. `OCCURS 5 TIMES` creates five copies of the `WS-STUDENT` group. Each copy contains two fields: a 15-character name and a 3-digit grade. The entire table occupies 5 x (15 + 3) = 90 bytes of contiguous memory.

The level numbers tell COBOL the structure:

- **01** `WS-CLASS-TABLE` — the whole table (group item)
- **05** `WS-STUDENT` — one element, repeated 5 times
- **10** `WS-STU-NAME` and `WS-STU-GRADE` — fields inside each element

You access fields with a subscript: `WS-STU-NAME(1)` is the first student's name, `WS-STU-GRADE(3)` is the third student's grade. The subscript applies to the `OCCURS` level — the 10-level fields inherit it.

**In Python, this is like a list of named tuples:**

```python
students = [
    ("ALICE JOHNSON", 82),
    ("BOB MARTINEZ", 45),
    ...
]
# students[0][0] = "ALICE JOHNSON"  (0-based)
# WS-STU-NAME(1) = "ALICE JOHNSON" (1-based in COBOL)
```

### Populating the table

```cobol
       LOAD-STUDENTS.
           MOVE "ALICE JOHNSON" TO WS-STU-NAME(1)
           MOVE 082             TO WS-STU-GRADE(1)
           ...
```

Each `MOVE` stores a value into a specific slot. The subscript `(1)` through `(5)` identifies which of the five student records receives the data. In a real program, this data would come from reading a file — you would PERFORM a loop that reads one record at a time and MOVEs each field into the next table position.

### PERFORM VARYING — the counted loop

```cobol
           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > WS-STUDENT-COUNT
               PERFORM DISPLAY-STUDENT
           END-PERFORM
```

`PERFORM VARYING` is the COBOL `for` loop. It works in four steps:

1. **FROM 1** — initialize `WS-IDX` to 1
2. **UNTIL WS-IDX > 5** — test the condition before each iteration; if true, exit
3. Execute the body (PERFORM DISPLAY-STUDENT)
4. **BY 1** — increment `WS-IDX` by 1, then go back to step 2

This is equivalent to:

```python
for idx in range(1, 6):     # 1, 2, 3, 4, 5
    display_student(idx)
```

```java
for (int idx = 1; idx <= 5; idx++) {
    displayStudent(idx);
}
```

Note that the COBOL version says `UNTIL WS-IDX > 5` (stop when true), while the Java version says `idx <= 5` (continue while true). The conditions are logically equivalent but phrased in opposite directions.

### Inside the loop — display, classify, accumulate

```cobol
       DISPLAY-STUDENT.
           MOVE WS-IDX              TO WS-DL-NUM
           MOVE WS-STU-NAME(WS-IDX) TO WS-DL-NAME
           MOVE WS-STU-GRADE(WS-IDX) TO WS-DL-GRADE

           IF WS-STU-GRADE(WS-IDX) >= 50
               MOVE "PASS" TO WS-DL-STATUS
               ADD 1 TO WS-PASS-COUNT
           ELSE
               MOVE "FAIL" TO WS-DL-STATUS
           END-IF

           DISPLAY WS-DETAIL-LINE
           ADD WS-STU-GRADE(WS-IDX) TO WS-TOTAL-GRADE.
```

This paragraph does three things per student:

1. **Formats the display line** by MOVEing the current student's data into the group-level `WS-DETAIL-LINE` (learned in lesson 07)
2. **Classifies** the student as PASS or FAIL using an IF statement, and counts passes
3. **Accumulates** the grade into `WS-TOTAL-GRADE`

The variable subscript `WS-IDX` is what makes this work — on each iteration, `WS-STU-GRADE(WS-IDX)` refers to a different student.

### Computing the average

```cobol
           DIVIDE WS-TOTAL-GRADE BY WS-STUDENT-COUNT
               GIVING WS-AVERAGE
```

After the loop, the total (323) is divided by the count (5) to get the average (64). This is integer division — the fractional part is truncated. For a decimal average, you would use `PIC 999V99` for the result field.

## How to compile and run

```bash
cobc -x -o tables main.cob
./tables
```

## Expected output

```text
===========================================
 CLASS GRADE REPORT
===========================================

#  Name             Grade  Status
-------------------------------------------
1. ALICE JOHNSON      82  PASS
2. BOB MARTINEZ       45  FAIL
3. CAROL DAVIS        91  PASS
4. DAVID CHEN         67  PASS
5. EVA KOWALSKI       38  FAIL
-------------------------------------------

Total grades : 0323
Average grade: 064
Students who passed (>= 50): 3
 of 5
```

Alice (82), Carol (91), and David (67) passed. Bob (45) and Eva (38) failed. The total of all grades is 323, and the integer average is 64.

## Exercises

1. **Sum values in a table.** Create a program that stores five monthly sales amounts in a numeric table (`PIC 9(5) OCCURS 5 TIMES`). Use `PERFORM VARYING` to loop through the table, display each month's value, and accumulate a grand total. Display the total after the loop. Use values like 12500, 18300, 15000, 21000, and 16700.

2. **Find the highest grade.** Add a variable `WS-HIGHEST PIC 999 VALUE 0` to this lesson's program. Inside `DISPLAY-STUDENT`, compare `WS-STU-GRADE(WS-IDX)` against `WS-HIGHEST` — if the current grade is larger, MOVE it to `WS-HIGHEST`. After the loop, display the highest grade and the name of the student who earned it. (Hint: also store the index of the best student in a separate variable.)

3. **Count passing grades by threshold.** Modify the program to use three counters: `WS-EXCELLENT-COUNT` (grade >= 80), `WS-PASS-COUNT` (grade 50-79), and `WS-FAIL-COUNT` (grade < 50). Use `EVALUATE TRUE` inside the loop instead of a simple IF. Display all three counts in the summary.

4. **Table of product prices.** Create a program that stores five products in a group-level table:

   ```cobol
          05 WS-PRODUCT OCCURS 5 TIMES.
              10 WS-PROD-NAME  PIC X(20).
              10 WS-PROD-PRICE PIC 999V99.
   ```

   Populate it with product names and prices, loop through the table to display each product with its price formatted using `PIC ZZ9.99`, and compute the average price at the end.

5. **Expand to 10 students.** Change `OCCURS 5 TIMES` to `OCCURS 10 TIMES`, add five more students, and update `WS-STUDENT-COUNT`. Remember to change `WS-IDX` from `PIC 9` to `PIC 99` (a single digit only holds 0-9, and you need subscript values up to 10). Verify that the totals, average, and pass count all update correctly.

## What comes next

In the next lesson you will learn how to read data from sequential files — see [09 - Sequential Files](../09_sequential_files/).
