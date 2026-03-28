# Notes — Payroll Processor

## Design decisions

This project was designed to be the simplest realistic payroll program possible while still exercising every major COBOL concept from the course.

**Why overtime?** Overtime adds a single IF statement and two extra COMPUTE lines. That small addition transforms the program from a trivial multiply into a genuine business rule with conditional logic. It also provides a natural place to demonstrate the IF/ELSE pattern from lesson 05 inside a file-processing loop.

**Why a flat tax rate?** Progressive tax brackets would be more realistic, but a flat 15% keeps the arithmetic straightforward and lets the learner focus on the program structure. The Extensions section suggests adding brackets as a challenge.

**Why COMPUTE instead of MULTIPLY/DIVIDE?** Earlier lessons (04) taught the verbose arithmetic verbs. This project introduces COMPUTE as the practical alternative for multi-step calculations. `COMPUTE WS-GROSS = WS-REGULAR-PAY + WS-OT-PAY` is clearer than chaining ADD statements, and it reads like a formula.

**Why group-level display lines?** The `WS-DETAIL-LINE` and `WS-TOTALS-LINE` items demonstrate the COBOL approach to formatted output: define the layout once in DATA DIVISION, populate it with MOVEs, display the group. This is the same pattern used in real-world COBOL report generators.

## Program structure

The program follows the classic COBOL batch pattern:

```text
PRINT-HEADER  →  READ-LOOP  →  PRINT-FOOTER
                    ↓
              PROCESS-RECORD
```

This three-phase structure (setup, process, summarize) appears in virtually every COBOL batch program. Understanding it is more valuable than memorizing any single keyword.

## Key patterns to recognize

- **EOF flag loop** — `WS-EOF` initialized to "N", flipped to "Y" inside `AT END`, tested in `PERFORM UNTIL`; this is the universal COBOL file-reading idiom
- **Accumulate inside the loop** — `ADD WS-GROSS TO WS-TOTAL-GROSS` runs once per record; the totals grow incrementally without storing individual values
- **Two-step display** — MOVE raw values into edited PIC fields, then DISPLAY the group; the format is defined in DATA DIVISION, not in the DISPLAY statement
- **Separation of concerns** — each paragraph has one job; PROCESS-EMPLOYEE does not know about the report header, and PRINT-REPORT-FOOTER does not know about individual employees

## Common mistakes when building this kind of program

- **Forgetting to initialize accumulators** — if `WS-TOTAL-GROSS` is not set to 0 before the loop, it may carry over garbage or values from a previous run
- **Wrong decimal alignment** — `PIC 99V9` (1 decimal place) and `PIC 99V99` (2 decimal places) must be handled carefully; COMPUTE aligns them automatically, but MULTIPLY/DIVIDE can truncate if the receiving field's decimal places are wrong
- **Overtime hours going negative** — if you subtract 40.0 from hours without checking first, a 35-hour employee gets -5.0 overtime; always use IF before the subtraction
- **FILLER with wrong VALUE** — if you forget the VALUE " " in a FILLER, it defaults to spaces anyway for PIC X, but numeric FILLERs may default to zeros; always specify VALUE explicitly
- **Display line columns not aligning with header** — the header is a literal string, but the detail line is a group; if the PIC widths do not match the header spacing, columns will be misaligned; always count character positions carefully

## How this project scales to real systems

Real payroll programs process thousands of employees and have dozens of business rules (multiple tax brackets, deductions for insurance/retirement, state vs. federal tax, year-to-date accumulators, multiple pay periods). But the fundamental structure is identical:

1. Read a record
2. Apply business rules
3. Format and output a line
4. Accumulate totals
5. Repeat until end-of-file
6. Print summary

The skills practiced in this 180-line project are the same skills used in production COBOL systems that process millions of records per day.
