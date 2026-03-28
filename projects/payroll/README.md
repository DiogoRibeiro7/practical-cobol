# Payroll Processor

A complete mini project that reads employee records from a data file, computes gross pay with overtime, calculates tax, and produces a formatted payroll report.

This is the first end-to-end business-style program in the repository. It combines concepts from lessons 01 through 11 into a single, realistic application.

## Project objective

Build a COBOL program that:

1. Reads employee records from a sequential file
2. Computes regular pay and overtime pay (1.5x rate for hours above 40)
3. Calculates a 15% flat tax on gross pay
4. Displays a formatted report with one line per employee
5. Shows summary totals at the bottom

## Input file format

The input file is `data/employees.dat`. Each line is a fixed-width record of 36 characters:

```text
E1001ALICE JOHNSON       ENGR4002500
E1002BOB MARTINEZ        SALE4502000
E1003CAROL DAVIS         ADMN3753000
E1004DAVID CHEN          ENGR4802200
E1005EVA KOWALSKI        SALE4002800
E1006FRANK OLIVEIRA      ADMN4251600
```

Record layout:

| Positions | Length | Field | PIC | Example | Meaning |
| --------- | ------ | ----- | --- | ------- | ------- |
| 1-5 | 5 | Employee ID | X(5) | E1001 | Unique identifier |
| 6-25 | 20 | Name | X(20) | ALICE JOHNSON | Employee name, space-padded |
| 26-29 | 4 | Department | X(4) | ENGR | Department code |
| 30-32 | 3 | Hours worked | 99V9 | 400 | Hours with 1 implied decimal (40.0) |
| 33-36 | 4 | Hourly rate | 99V99 | 2500 | Rate with 2 implied decimals (25.00) |

The `V` in the PIC clauses marks an implied decimal point. No actual decimal character is stored in the file. `400` with `PIC 99V9` means 40.0. `2500` with `PIC 99V99` means 25.00.

## Business rules

The payroll calculation uses these rules:

1. **Regular pay**: hours worked (up to 40.0) multiplied by the hourly rate
2. **Overtime pay**: any hours above 40.0 are paid at 1.5 times the hourly rate
3. **Gross pay**: regular pay + overtime pay
4. **Tax**: 15% of gross pay (flat rate, no brackets)
5. **Net pay**: gross pay minus tax

**Example — Bob Martinez (45.0 hours at $20.00/hr):**

| Step | Calculation | Result |
| ---- | ----------- | ------ |
| Regular hours | min(45.0, 40.0) | 40.0 |
| Overtime hours | 45.0 - 40.0 | 5.0 |
| Regular pay | 40.0 x $20.00 | $800.00 |
| Overtime pay | 5.0 x $20.00 x 1.5 | $150.00 |
| Gross pay | $800.00 + $150.00 | $950.00 |
| Tax (15%) | $950.00 x 0.15 | $142.50 |
| Net pay | $950.00 - $142.50 | $807.50 |

## Program structure

The program is organized into five paragraphs:

```text
PROCEDURE DIVISION
    PERFORM PRINT-REPORT-HEADER     → display title and column headings
    PERFORM READ-ALL-EMPLOYEES      → open file, loop through records
        PERFORM PROCESS-EMPLOYEE    → compute pay, display detail line
    PERFORM PRINT-REPORT-FOOTER     → display totals and counts
    STOP RUN
```

This follows the standard COBOL batch pattern:

1. **Print header** — set up the report
2. **Read and process** — loop through every record
3. **Print footer** — summarize results

Each paragraph has one clear responsibility. The main flow reads like a business process description.

## Code

```cobol
      *> =============================================================
      *> PAYROLL PROCESSOR
      *> Reads employee records from a data file, computes gross pay
      *> (with overtime at 1.5x for hours above 40), calculates
      *> a 15% flat tax, and produces a formatted payroll report.
      *>
      *> This project combines concepts from lessons 01 through 11:
      *>   - Variables and PIC clauses (lesson 02)
      *>   - Arithmetic with COMPUTE (lesson 04)
      *>   - Conditionals with IF (lesson 05)
      *>   - Paragraph-based structure (lesson 06)
      *>   - Formatted output with edited PIC and groups (lesson 07)
      *>   - Sequential file reading (lesson 09)
      *>   - Accumulators and report totals (lesson 11)
      *> =============================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYROLL-PROCESSOR.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMPLOYEE-FILE
               ASSIGN TO "data/employees.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

      *> =============================================================
      *> FILE SECTION — input record layout (36 chars per line)
      *> =============================================================
       FILE SECTION.
       FD EMPLOYEE-FILE.
       01 EMP-RECORD.
           05 EMP-ID           PIC X(5).
           05 EMP-NAME         PIC X(20).
           05 EMP-DEPT         PIC X(4).
           05 EMP-HOURS        PIC 99V9.
           05 EMP-RATE         PIC 99V99.

      *> =============================================================
      *> WORKING-STORAGE SECTION
      *> =============================================================
       WORKING-STORAGE SECTION.

      *> --- End-of-file flag ---
       01 WS-EOF               PIC X VALUE "N".

      *> --- Overtime threshold ---
       01 WS-OT-THRESHOLD      PIC 99V9 VALUE 40.0.

      *> --- Per-employee calculation fields ---
       01 WS-REGULAR-HOURS     PIC 99V9    VALUE 0.
       01 WS-OT-HOURS          PIC 99V9    VALUE 0.
       01 WS-REGULAR-PAY       PIC 9(5)V99 VALUE 0.
       01 WS-OT-PAY            PIC 9(5)V99 VALUE 0.
       01 WS-GROSS             PIC 9(5)V99 VALUE 0.
       01 WS-TAX               PIC 9(5)V99 VALUE 0.
       01 WS-NET               PIC 9(5)V99 VALUE 0.

      *> --- Report accumulators ---
       01 WS-TOTAL-GROSS       PIC 9(7)V99 VALUE 0.
       01 WS-TOTAL-TAX         PIC 9(7)V99 VALUE 0.
       01 WS-TOTAL-NET         PIC 9(7)V99 VALUE 0.
       01 WS-EMP-COUNT         PIC 99      VALUE 0.
       01 WS-OT-COUNT          PIC 99      VALUE 0.

      *> --- Edited display fields (per-employee) ---
       01 WS-HOURS-DISP        PIC Z9.9.
       01 WS-GROSS-DISP        PIC Z,ZZ9.99.
       01 WS-TAX-DISP          PIC Z,ZZ9.99.
       01 WS-NET-DISP          PIC Z,ZZ9.99.
       01 WS-OT-HOURS-DISP     PIC Z9.9.

      *> --- Edited display fields (totals) ---
       01 WS-TOTAL-GROSS-DISP  PIC ZZ,ZZ9.99.
       01 WS-TOTAL-TAX-DISP    PIC ZZ,ZZ9.99.
       01 WS-TOTAL-NET-DISP    PIC ZZ,ZZ9.99.

      *> --- Detail line layout ---
      *> This group-level item formats one employee row.
       01 WS-DETAIL-LINE.
           05 WS-DL-ID         PIC X(5).
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-NAME       PIC X(20).
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-DEPT       PIC X(4).
           05 FILLER            PIC X(2) VALUE "  ".
           05 WS-DL-HOURS      PIC Z9.9.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-GROSS      PIC Z,ZZ9.99.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-TAX        PIC Z,ZZ9.99.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-NET        PIC Z,ZZ9.99.

      *> --- Totals line layout ---
       01 WS-TOTALS-LINE.
           05 FILLER            PIC X(34) VALUE
              "TOTALS                            ".
           05 WS-TL-GROSS      PIC ZZ,ZZ9.99.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-TL-TAX        PIC ZZ,ZZ9.99.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-TL-NET        PIC ZZ,ZZ9.99.

      *> =============================================================
      *> PROCEDURE DIVISION — main flow
      *> =============================================================
       PROCEDURE DIVISION.
           PERFORM PRINT-REPORT-HEADER
           PERFORM READ-ALL-EMPLOYEES
           PERFORM PRINT-REPORT-FOOTER

           STOP RUN.

      *> -------------------------------------------------------------
      *> PRINT-REPORT-HEADER
      *> Displays the report title and column headings.
      *> -------------------------------------------------------------
       PRINT-REPORT-HEADER.
           DISPLAY "============================================"
                   "======================"
           DISPLAY "                     PAYROLL REPORT"
           DISPLAY "============================================"
                   "======================"
           DISPLAY " "
           DISPLAY "ID    Name                  Dept"
                   "  Hours    Gross       Tax   Net Pay"
           DISPLAY "--------------------------------------------"
                   "----------------------".

      *> -------------------------------------------------------------
      *> READ-ALL-EMPLOYEES
      *> Opens the file and loops through every record.
      *> -------------------------------------------------------------
       READ-ALL-EMPLOYEES.
           OPEN INPUT EMPLOYEE-FILE

           PERFORM UNTIL WS-EOF = "Y"
               READ EMPLOYEE-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESS-EMPLOYEE
               END-READ
           END-PERFORM

           CLOSE EMPLOYEE-FILE.

      *> -------------------------------------------------------------
      *> PROCESS-EMPLOYEE
      *> Computes pay for one employee and displays the detail line.
      *>
      *> Business rules:
      *>   - Regular pay: hours (up to 40) * hourly rate
      *>   - Overtime pay: hours above 40 * hourly rate * 1.5
      *>   - Gross pay: regular pay + overtime pay
      *>   - Tax: 15% of gross pay (flat rate)
      *>   - Net pay: gross pay - tax
      *> -------------------------------------------------------------
       PROCESS-EMPLOYEE.
           ADD 1 TO WS-EMP-COUNT

      *> --- Compute regular and overtime hours ---
           IF EMP-HOURS > WS-OT-THRESHOLD
               COMPUTE WS-REGULAR-HOURS = WS-OT-THRESHOLD
               COMPUTE WS-OT-HOURS =
                   EMP-HOURS - WS-OT-THRESHOLD
               ADD 1 TO WS-OT-COUNT
           ELSE
               MOVE EMP-HOURS TO WS-REGULAR-HOURS
               MOVE 0 TO WS-OT-HOURS
           END-IF

      *> --- Compute pay amounts ---
           COMPUTE WS-REGULAR-PAY =
               WS-REGULAR-HOURS * EMP-RATE
           COMPUTE WS-OT-PAY =
               WS-OT-HOURS * EMP-RATE * 1.5
           COMPUTE WS-GROSS =
               WS-REGULAR-PAY + WS-OT-PAY
           COMPUTE WS-TAX =
               WS-GROSS * 0.15
           COMPUTE WS-NET =
               WS-GROSS - WS-TAX

      *> --- Build the detail line ---
           MOVE EMP-ID    TO WS-DL-ID
           MOVE EMP-NAME  TO WS-DL-NAME
           MOVE EMP-DEPT  TO WS-DL-DEPT
           MOVE EMP-HOURS TO WS-DL-HOURS
           MOVE WS-GROSS  TO WS-DL-GROSS
           MOVE WS-TAX    TO WS-DL-TAX
           MOVE WS-NET    TO WS-DL-NET

           DISPLAY WS-DETAIL-LINE

      *> --- Show overtime note if applicable ---
           IF WS-OT-HOURS > 0
               MOVE WS-OT-HOURS TO WS-OT-HOURS-DISP
               DISPLAY "       ("
                       WS-OT-HOURS-DISP
                       " overtime hours at 1.5x rate)"
           END-IF

      *> --- Accumulate totals ---
           ADD WS-GROSS TO WS-TOTAL-GROSS
           ADD WS-TAX   TO WS-TOTAL-TAX
           ADD WS-NET   TO WS-TOTAL-NET.

      *> -------------------------------------------------------------
      *> PRINT-REPORT-FOOTER
      *> Displays the separator, totals, and employee counts.
      *> -------------------------------------------------------------
       PRINT-REPORT-FOOTER.
           DISPLAY "--------------------------------------------"
                   "----------------------"

      *> --- Format and display totals ---
           MOVE WS-TOTAL-GROSS TO WS-TL-GROSS
           MOVE WS-TOTAL-TAX   TO WS-TL-TAX
           MOVE WS-TOTAL-NET   TO WS-TL-NET
           DISPLAY WS-TOTALS-LINE

           DISPLAY " "
           DISPLAY "Employees processed: " WS-EMP-COUNT
           DISPLAY "Overtime employees : " WS-OT-COUNT
           DISPLAY "============================================"
                   "======================".
```

## How to compile and run

```bash
cd projects/payroll
cobc -x -o payroll main.cob
./payroll
```

Make sure the `data/employees.dat` file exists in the `data/` subdirectory relative to where you run the program.

## Expected output

```text
==================================================================
                     PAYROLL REPORT
==================================================================

ID    Name                  Dept  Hours    Gross       Tax   Net Pay
------------------------------------------------------------------
E1001 ALICE JOHNSON         ENGR  40.0 1,000.00   150.00   850.00
E1002 BOB MARTINEZ          SALE  45.0   950.00   142.50   807.50
       ( 5.0 overtime hours at 1.5x rate)
E1003 CAROL DAVIS           ADMN  37.5 1,125.00   168.75   956.25
E1004 DAVID CHEN            ENGR  48.0 1,144.00   171.60   972.40
       ( 8.0 overtime hours at 1.5x rate)
E1005 EVA KOWALSKI          SALE  40.0 1,120.00   168.00   952.00
E1006 FRANK OLIVEIRA        ADMN  42.5   700.00   105.00   595.00
       ( 2.5 overtime hours at 1.5x rate)
------------------------------------------------------------------
TOTALS                             6,039.00   905.85 5,133.15

Employees processed: 06
Overtime employees : 03
==================================================================
```

## How this project connects earlier lessons

This project draws on nearly every lesson in the course:

| Lesson | Concept used here |
| ------ | ----------------- |
| 02 — Variables and PIC | `PIC X`, `PIC 9`, `PIC 99V9`, `PIC 99V99` for data definitions |
| 04 — Arithmetic | `COMPUTE` for pay calculations with decimal arithmetic |
| 05 — IF and Conditions | `IF EMP-HOURS > WS-OT-THRESHOLD` for overtime detection |
| 06 — PERFORM and Paragraphs | Five paragraphs with clear responsibilities, called from the main flow |
| 07 — Formatting | Group-level detail lines, FILLER for spacing, `PIC Z,ZZ9.99` for currency |
| 08 — OCCURS (indirect) | Accumulators replace tables here, but the accumulation pattern is the same |
| 09 — Sequential Files | `SELECT`, `FD`, `OPEN INPUT`, `READ ... AT END`, `CLOSE` |
| 11 — Summary Report | Header/detail/footer structure, multiple accumulators, formatted totals |

If you can read and understand every line of this program, you have a solid grasp of COBOL fundamentals.

## What to study in this project

As you read through the code, pay attention to:

1. **The main flow is a table of contents.** Three PERFORM statements describe the entire program. The details are in the paragraphs.

2. **Data definitions drive the output format.** The `WS-DETAIL-LINE` group item defines exactly how each employee row looks. Changing a column width means changing one PIC clause, not hunting through DISPLAY statements.

3. **The overtime logic is a simple IF.** The business rule (1.5x for hours > 40) translates directly into three lines of COBOL. Real payroll systems have more rules, but the pattern is the same.

4. **COMPUTE simplifies arithmetic.** Instead of chaining ADD, MULTIPLY, and DIVIDE, `COMPUTE WS-GROSS = WS-REGULAR-PAY + WS-OT-PAY` reads like a formula.

5. **Accumulators build totals incrementally.** Each employee's gross, tax, and net are added to running totals inside the loop. The footer simply displays the accumulated values.

6. **The EOF flag pattern controls the loop.** `PERFORM UNTIL WS-EOF = "Y"` with `READ ... AT END MOVE "Y" TO WS-EOF` is the universal COBOL file-reading pattern.

## Extensions

Ideas for improving or extending this project:

1. **Write the report to a file.** Add a second `SELECT`/`FD` for an output file and use `WRITE` instead of `DISPLAY` for each line. This creates a persistent payroll report that can be printed or archived.

2. **Add tax brackets.** Replace the flat 15% tax with progressive brackets: 10% on the first $500 of gross pay, 15% on the next $500, and 20% on anything above $1000. Use `EVALUATE TRUE` with `WHEN WS-GROSS >= threshold` conditions.

3. **Department totals.** Track separate totals for each department (ENGR, SALE, ADMN). Display a subtotal line after each department's employees. This requires the input file to be sorted by department — a preview of the control-break pattern used in real COBOL reporting.

4. **Add a bonus column.** Employees who worked more than 45 hours get an additional $50 flat bonus. Add a bonus field to the calculations and the detail line.

5. **Validate input data.** Before processing each record, check that hours are between 0 and 80 and that the rate is greater than 0. If a record fails validation, display a warning line instead of a payslip line, and skip it in the totals.

6. **Interactive mode.** Allow the user to enter employee data via `ACCEPT` instead of reading from a file. Use `PERFORM UNTIL` with a sentinel value (e.g., employee ID "XXXXX") to stop input.
