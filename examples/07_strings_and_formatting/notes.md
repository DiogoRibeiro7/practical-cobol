# Notes — Lesson 07

## Key terminology

- **Edited picture clause** — a PIC that includes formatting characters for display purposes (e.g., `PIC $ZZ,ZZ9.99`); not used for arithmetic, only for holding a formatted copy of a numeric value
- **Implied decimal (V)** — marks the decimal point position in a numeric storage field without storing an actual character; `PIC 9(5)V99` occupies 7 bytes but represents a number with 2 decimal places
- **Zero suppression (Z)** — replaces leading zeros with spaces in an edited field; `PIC ZZZ9` displays 42 as three spaces followed by 42
- **Insertion characters** — literal characters placed in an edited PIC that appear in the output: comma (`,`) for thousands, period (`.`) for the decimal point, dollar sign (`$`), slash (`/`) for dates
- **Group-level item** — a level-01 variable made up of sub-fields (level-05 or deeper); when you DISPLAY a group item, all sub-fields are output as one continuous string
- **FILLER** — a reserved word for an unnamed field inside a group; used to create spacing, separators, or padding in output line layouts; cannot be referenced in the PROCEDURE DIVISION
- **Detail line** — an output line layout (usually a group-level item) designed to display one row of data in a columnar report

## Common beginner mistakes

- **Confusing storage PIC with display PIC** — `PIC 9(5)V99` is for storage and arithmetic; `PIC ZZ,ZZ9.99` is for display; you must MOVE from a storage field into an edited field before displaying it; displaying a storage field shows raw digits with leading zeros
- **Forgetting to MOVE before displaying** — if you display a storage PIC directly you get unformatted output (e.g., `0152340` instead of `1,523.40`); always MOVE to the display field first
- **Wrong decimal alignment** — if the storage field has `V99` (2 decimal places) but the display field expects 3, the value will be misaligned or truncated; match the number of decimal places between storage and display fields
- **Displaying a group item before populating all sub-fields** — if you forget to MOVE a value into one of the sub-fields, it retains whatever was there before (or spaces/zeros from initialization); always populate every sub-field before each DISPLAY
- **Using edited PIC fields in arithmetic** — you cannot ADD, SUBTRACT, MULTIPLY, or DIVIDE with an edited field; arithmetic only works on numeric storage fields (`PIC 9`, `PIC S9(5)V99`, etc.)

## The formatting mindset

In most modern programming, formatting happens at the moment of output:

```python
print(f"Balance: ${balance:,.2f}")
```

In COBOL, formatting is separated into two distinct steps:

1. **Declare the format** in the DATA DIVISION (edited PIC)
2. **Populate and display** in the PROCEDURE DIVISION (MOVE + DISPLAY)

This separation is a feature, not a limitation. It means:

- Every formatted field is visible in the DATA DIVISION, making the output structure auditable at a glance
- The same display field can be reused for every record in a batch — MOVE new data in, DISPLAY, repeat
- Changes to formatting (e.g., adding a dollar sign) require changing one PIC clause, not hunting through the PROCEDURE DIVISION

Real COBOL programs often have dozens of group-level items — one for each type of output line (header, detail, subtotal, footer). This is the foundation of COBOL report generation.

## Comparison with modern languages

- Edited PIC clauses are like `printf` format specifiers in C, `String.format()` in Java, or f-strings in Python — but declared at the variable level, not at the output call
- Group-level items are like structs or records in C, except they are also the output format — DISPLAYing a group outputs all fields concatenated, like a formatted line buffer
- FILLER has no direct equivalent in most languages; the closest is padding in printf or str.ljust() in Python, but FILLER is part of the data structure itself
- The two-step pattern (MOVE to display field, then DISPLAY) has no equivalent; modern languages format inline

## Where this pattern appears

- **Report generation** — the primary use case; COBOL programs produce printed reports with headers, column-aligned detail lines, subtotals, and grand totals
- **Invoices and billing** — dollar amounts formatted with currency symbols, commas, and fixed decimal places
- **Bank statements** — account summaries, transaction lists, and balance displays
- **Payroll output** — payslips with aligned earnings, deductions, and net pay
- **Any columnar business output** — the group-level line layout pattern scales from simple terminal display to multi-page printed reports; the same approach is used with file output in later lessons
