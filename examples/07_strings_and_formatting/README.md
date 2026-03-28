# 07 - Strings, Formatting, and Report Output

## Objective

Learn how COBOL formats data for human-readable output using edited picture clauses, group-level display lines, and aligned column layouts.

## Concepts covered

- Alphanumeric fields (`PIC X`) and fixed-width text
- Edited picture clauses for currency, zero suppression, and decimal formatting
- Group-level items as reusable output line templates
- `FILLER` fields for column spacing
- Building aligned label-value pairs
- Building columnar detail lines (like a receipt or report)
- `MOVE` from numeric storage to edited display fields
- The COBOL formatting philosophy: define the layout in DATA DIVISION, populate it in PROCEDURE DIVISION

## Why COBOL emphasizes formatted output

In most modern languages, formatting happens at the point of output — you call `printf`, use an f-string, or chain `.toFixed(2)`. The format lives inside the print statement and is scattered throughout the code.

COBOL takes a different approach. Formatting is defined **in the DATA DIVISION**, as part of the variable declaration. You declare an edited picture clause like `PIC $Z,ZZ9.99` once, and then every time you MOVE a value into that field, it is automatically formatted. The PROCEDURE DIVISION never contains format strings — it just MOVEs data and DISPLAYs fields.

This design was intentional. COBOL was built for **report-heavy business programs** — payroll summaries, bank statements, invoices, inventory reports. These programs display the same numbers in the same format hundreds or thousands of times. Defining the format once in the data layout and reusing it everywhere makes the output consistent and the code easier to audit.

This lesson demonstrates three progressively richer formatting techniques:

1. **Aligned label-value pairs** — a customer summary
2. **Columnar detail lines** — a purchase receipt with headers, items, and totals
3. **Formatted currency totals** — subtotal, tax, and grand total

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 07 - Strings, Formatting, and Report Output
      *> Demonstrates aligned labels, edited PIC clauses,
      *> group-level display lines, and receipt-style output.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. FORMAT-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> -------------------------------------------------------
      *> Part 1: Customer summary fields
      *> -------------------------------------------------------
       01 WS-ACCOUNT-NO       PIC 9(8)  VALUE 10045782.
       01 WS-CUSTOMER-NAME    PIC X(20) VALUE "ANA SILVA".
       01 WS-STATUS           PIC X(10) VALUE "ACTIVE".
       01 WS-BALANCE          PIC 9(5)V99 VALUE 152340.
       01 WS-BALANCE-DISP     PIC $Z,ZZ9.99.

      *> -------------------------------------------------------
      *> Part 2: Receipt detail line layout
      *> A group-level item defines one output line.
      *> Each 05-level field occupies a fixed column position.
      *> -------------------------------------------------------
       01 WS-DETAIL-LINE.
           05 WS-DL-ITEM      PIC X(22).
           05 WS-DL-QTY       PIC Z9.
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-PRICE     PIC ZZ9.99.
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-AMOUNT    PIC Z,ZZ9.99.

      *> Working fields for line calculations
       01 WS-ITEM-NAME        PIC X(22).
       01 WS-QTY              PIC 99    VALUE 0.
       01 WS-PRICE            PIC 999V99 VALUE 0.
       01 WS-LINE-AMT         PIC 9(5)V99 VALUE 0.

      *> -------------------------------------------------------
      *> Part 3: Totals
      *> -------------------------------------------------------
       01 WS-SUBTOTAL         PIC 9(5)V99 VALUE 0.
       01 WS-TAX              PIC 9(5)V99 VALUE 0.
       01 WS-GRAND-TOTAL      PIC 9(5)V99 VALUE 0.

       01 WS-SUBTOTAL-DISP    PIC Z,ZZ9.99.
       01 WS-TAX-DISP         PIC Z,ZZ9.99.
       01 WS-TOTAL-DISP       PIC Z,ZZ9.99.

       PROCEDURE DIVISION.

      *> =====================================================
      *> PART 1: Customer summary with aligned labels
      *> =====================================================
           DISPLAY "============================================"
           DISPLAY "       CUSTOMER ACCOUNT SUMMARY"
           DISPLAY "============================================"
           DISPLAY " "
           DISPLAY "Account : " WS-ACCOUNT-NO
           DISPLAY "Name    : " WS-CUSTOMER-NAME
           DISPLAY "Status  : " WS-STATUS

           MOVE WS-BALANCE TO WS-BALANCE-DISP
           DISPLAY "Balance : " WS-BALANCE-DISP

      *> =====================================================
      *> PART 2: Receipt with columnar detail lines
      *> =====================================================
           DISPLAY " "
           DISPLAY "============================================"
           DISPLAY "       PURCHASE RECEIPT"
           DISPLAY "============================================"
           DISPLAY " "
           DISPLAY "Item                  Qty   Price"
                   "     Amount"
           DISPLAY "--------------------------------------------"

      *> --- Line 1: Office Supplies ---
           MOVE "Office Supplies"  TO WS-ITEM-NAME
           MOVE 3                  TO WS-QTY
           MOVE 12.50              TO WS-PRICE
           PERFORM FORMAT-AND-PRINT-LINE

      *> --- Line 2: Printer Paper ---
           MOVE "Printer Paper"    TO WS-ITEM-NAME
           MOVE 10                 TO WS-QTY
           MOVE 8.75               TO WS-PRICE
           PERFORM FORMAT-AND-PRINT-LINE

      *> --- Line 3: Toner Cartridge ---
           MOVE "Toner Cartridge"  TO WS-ITEM-NAME
           MOVE 2                  TO WS-QTY
           MOVE 45.00              TO WS-PRICE
           PERFORM FORMAT-AND-PRINT-LINE

      *> =====================================================
      *> PART 3: Totals with formatted currency
      *> =====================================================
           DISPLAY "--------------------------------------------"

           MOVE WS-SUBTOTAL TO WS-SUBTOTAL-DISP
           DISPLAY "                         Subtotal: "
                   WS-SUBTOTAL-DISP

      *> Calculate 8% tax
           MULTIPLY WS-SUBTOTAL BY 0.08
               GIVING WS-TAX
           MOVE WS-TAX TO WS-TAX-DISP
           DISPLAY "                         Tax (8%): "
                   WS-TAX-DISP

           ADD WS-SUBTOTAL TO WS-TAX
               GIVING WS-GRAND-TOTAL
           MOVE WS-GRAND-TOTAL TO WS-TOTAL-DISP
           DISPLAY "                         TOTAL  : "
                   WS-TOTAL-DISP

           DISPLAY " "
           DISPLAY "Thank you for your purchase!"

           STOP RUN.

      *> -------------------------------------------------------
      *> FORMAT-AND-PRINT-LINE
      *> Computes the line amount, populates the group-level
      *> detail line, displays it, and adds to the subtotal.
      *> -------------------------------------------------------
       FORMAT-AND-PRINT-LINE.
           MULTIPLY WS-QTY BY WS-PRICE
               GIVING WS-LINE-AMT
           MOVE WS-ITEM-NAME  TO WS-DL-ITEM
           MOVE WS-QTY        TO WS-DL-QTY
           MOVE WS-PRICE      TO WS-DL-PRICE
           MOVE WS-LINE-AMT   TO WS-DL-AMOUNT
           DISPLAY WS-DETAIL-LINE
           ADD WS-LINE-AMT TO WS-SUBTOTAL.
```

## Walkthrough

### Part 1 — Aligned label-value pairs

```cobol
           DISPLAY "Account : " WS-ACCOUNT-NO
           DISPLAY "Name    : " WS-CUSTOMER-NAME
           DISPLAY "Status  : " WS-STATUS
```

The simplest alignment technique: pad each label to the same width. "Account", "Name", "Status", and "Balance" are all followed by enough spaces so that the colon always appears in the same column. This is how COBOL programs build summaries and headers.

```cobol
       01 WS-BALANCE          PIC 9(5)V99 VALUE 152340.
       01 WS-BALANCE-DISP     PIC $Z,ZZ9.99.
```

The balance is stored in a numeric field with an implied decimal (`V`). The VALUE `152340` means `01523.40` — five integer digits and two fractional digits. The display field `PIC $Z,ZZ9.99` adds a dollar sign, suppresses leading zeros, inserts a thousands comma, and shows the decimal point. After `MOVE WS-BALANCE TO WS-BALANCE-DISP`, the display field contains `$1,523.40`.

### Part 2 — Group-level display lines

This is the most important new concept in this lesson.

```cobol
       01 WS-DETAIL-LINE.
           05 WS-DL-ITEM      PIC X(22).
           05 WS-DL-QTY       PIC Z9.
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-PRICE     PIC ZZ9.99.
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-AMOUNT    PIC Z,ZZ9.99.
```

`WS-DETAIL-LINE` is a **group-level item**. It is a single variable (level 01) made up of sub-fields (level 05). When you `DISPLAY WS-DETAIL-LINE`, COBOL outputs the entire group as one continuous string — all the sub-fields are concatenated left to right.

This is how COBOL programs build formatted output lines. Instead of concatenating strings at runtime (like `f"{item:<22}{qty:>2}   {price:>6.2f}   {amount:>8.2f}"` in Python), you define the line layout once in the DATA DIVISION and then MOVE values into the sub-fields.

Each sub-field controls one column:

| Field | PIC | Width | Purpose |
| ----- | --- | ----- | ------- |
| `WS-DL-ITEM` | `X(22)` | 22 chars | Item description, left-justified, space-padded |
| `WS-DL-QTY` | `Z9` | 2 chars | Quantity with leading zero suppressed |
| FILLER | `X(3)` | 3 chars | Column gap (three spaces) |
| `WS-DL-PRICE` | `ZZ9.99` | 6 chars | Unit price, zero-suppressed, 2 decimals |
| FILLER | `X(3)` | 3 chars | Column gap |
| `WS-DL-AMOUNT` | `Z,ZZ9.99` | 9 chars | Line amount with comma and 2 decimals |

**FILLER** is a special COBOL keyword. It creates a field with no name — you cannot reference it in the PROCEDURE DIVISION, but it occupies space in the group. FILLERs are used for spacing, separators, and padding in output line layouts.

### The FORMAT-AND-PRINT-LINE paragraph

```cobol
       FORMAT-AND-PRINT-LINE.
           MULTIPLY WS-QTY BY WS-PRICE
               GIVING WS-LINE-AMT
           MOVE WS-ITEM-NAME  TO WS-DL-ITEM
           MOVE WS-QTY        TO WS-DL-QTY
           MOVE WS-PRICE      TO WS-DL-PRICE
           MOVE WS-LINE-AMT   TO WS-DL-AMOUNT
           DISPLAY WS-DETAIL-LINE
           ADD WS-LINE-AMT TO WS-SUBTOTAL.
```

This paragraph follows the standard COBOL output pattern:

1. **Compute** the derived value (line amount = quantity * price)
2. **MOVE** each value into its position in the group-level line
3. **DISPLAY** the group — COBOL outputs all sub-fields as one line
4. **Accumulate** the line amount into the running subtotal

The same paragraph is PERFORMed three times, once per item. Before each PERFORM, the main flow MOVEs new values into the working fields (`WS-ITEM-NAME`, `WS-QTY`, `WS-PRICE`). This is the preview of how real COBOL batch programs work: read a record, populate the fields, PERFORM the processing paragraph, repeat.

### Part 3 — Formatted totals

```cobol
       01 WS-SUBTOTAL-DISP    PIC Z,ZZ9.99.
       01 WS-TAX-DISP         PIC Z,ZZ9.99.
       01 WS-TOTAL-DISP       PIC Z,ZZ9.99.
```

Three display fields, all with the same edited PIC. The raw numeric values in `WS-SUBTOTAL`, `WS-TAX`, and `WS-GRAND-TOTAL` are MOVEd into these fields before display. The 8% tax is computed with `MULTIPLY WS-SUBTOTAL BY 0.08 GIVING WS-TAX`.

### Edited PIC reference

| Symbol | Meaning | Example PIC | Example output |
| ------ | ------- | ----------- | -------------- |
| `9` | Always display the digit | `PIC 999` | `042` |
| `Z` | Suppress leading zeros (replace with space) | `PIC ZZ9` | `·42` (leading space) |
| `.` | Insert a decimal point | `PIC 99.99` | `01.50` |
| `,` | Insert a thousands separator | `PIC Z,ZZ9` | `1,523` |
| `$` | Insert a dollar sign | `PIC $Z,ZZ9.99` | `$1,523.40` |
| `-` | Show a minus sign if negative, space if positive | `PIC -Z,ZZ9.99` | `-1,523.40` |
| `+` | Show + if positive, - if negative | `PIC +Z,ZZ9.99` | `+1,523.40` |
| `CR` | Print CR after the amount if negative | `PIC Z,ZZ9.99CR` | `1,523.40CR` |
| `DB` | Print DB after the amount if negative | `PIC Z,ZZ9.99DB` | `1,523.40DB` |

### Comparison with modern languages

In Python, the receipt output might look like this:

```python
print(f"{'Office Supplies':<22}{3:>2}   {12.50:>6.2f}   {37.50:>8.2f}")
```

The format string (`<22`, `>2`, `>6.2f`) is embedded in the print call. If you display the same data in five places, you repeat the format five times.

In COBOL, the format is declared once:

```cobol
       01 WS-DETAIL-LINE.
           05 WS-DL-ITEM      PIC X(22).
           05 WS-DL-QTY       PIC Z9.
           ...
```

And then used everywhere by MOVEing data in and DISPLAYing the group. The format is visible in the DATA DIVISION, separate from the logic, making it easy to audit and change.

## How to compile and run

```bash
cobc -x -o format main.cob
./format
```

## Expected output

```text
============================================
       CUSTOMER ACCOUNT SUMMARY
============================================

Account : 10045782
Name    : ANA SILVA
Status  : ACTIVE
Balance : $1,523.40

============================================
       PURCHASE RECEIPT
============================================

Item                  Qty   Price     Amount
--------------------------------------------
Office Supplies        3    12.50       37.50
Printer Paper         10     8.75       87.50
Toner Cartridge        2    45.00       90.00
--------------------------------------------
                         Subtotal:    215.00
                         Tax (8%):     17.20
                         TOTAL  :    232.20

Thank you for your purchase!
```

## Exercises

1. **Student report line.** Define a group-level item `WS-STUDENT-LINE` with sub-fields for a student name (`PIC X(20)`), grade (`PIC Z9`), and result (`PIC X(10)`). Populate the fields for three students — one who passed, one who failed, and one who got an excellent grade. Display all three lines with a header row. The output should look like a simple class roster.

2. **Invoice summary with dollar signs.** Modify the receipt to use `PIC $Z,ZZ9.99` for all amounts (line amounts, subtotal, tax, total). Observe how the dollar sign appears in the output. Add a fourth item to the receipt and verify that the subtotal and total update correctly.

3. **Aligned two-column report.** Create a program that displays a comparison of two departments side by side:

   ```text
   Department     Budget     Actual     Variance
   ------------------------------------------------
   Engineering     50,000     48,250      1,750
   Marketing       35,000     37,100     -2,100
   ```

   Use a group-level item for the detail line. Use `PIC -Z,ZZ9` for the variance column so that overspending shows a minus sign.

4. **Payslip formatter.** Write a program that displays a formatted payslip:
   - Employee name and ID (aligned labels)
   - Base salary, overtime, deductions, and net pay (using `PIC $ZZ,ZZ9.99`)
   - A separator line between the earnings section and the totals

   Use at least one group-level item for the earnings detail line.

5. **Date formatting.** Store a date as `PIC 9(8)` with VALUE `20260315` (meaning March 15, 2026). Create an edited display field `PIC 9(4)/99/99` and MOVE the date into it. The output should be `2026/03/15`. The `/` in the PIC is an insertion character — it is placed literally in the output, similar to how `,` inserts a comma. Try also `PIC 99/99/9(4)` to see the difference.

## What comes next

In the next lesson you will learn how to work with arrays and tables using the `OCCURS` clause — see [08 - OCCURS and Tables](../08_occurs_and_tables/).
