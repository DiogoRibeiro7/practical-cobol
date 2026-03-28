# 11 - File-Based Summary Report

## Objective

Read bank transactions from a file, classify each one as a credit or debit, accumulate separate totals, and produce a formatted report with a detail section and a summary section.

## Concepts covered

- Combining file reading (lesson 09), formatted output (lesson 07), EVALUATE (lesson 05), and paragraph structure (lesson 06) into one complete program
- The **read-classify-accumulate-report** pattern -- the core of COBOL batch reporting
- Multiple accumulators: separate counters and totals for credits and debits
- `PIC S9(7)V99` -- signed numeric fields (the net balance can be negative)
- `PIC -Z,ZZ9.99` -- edited field that shows a minus sign when negative and a space when positive
- Group-level detail line layout with FILLER fields for column spacing
- `EVALUATE` for classifying records by type
- Paragraph-based program structure: PRINT-HEADER, READ-AND-PROCESS, PRINT-SUMMARY

## Data file

The program reads `data/transactions.dat`. Each line is a fixed-length record of 18 characters with no delimiters:

```text
2026-01-15C0025000
2026-01-16D0012500
2026-01-18C0050000
2026-01-20D0008000
2026-01-22C0031500
2026-01-25D0015000
```

The layout is:

| Positions | Length | Field  | PIC      | Example    | Meaning                                     |
|-----------|--------|--------|----------|------------|---------------------------------------------|
| 1-10      | 10     | Date   | X(10)    | 2026-01-15 | Transaction date                             |
| 11        | 1      | Type   | X(1)     | C          | C = credit, D = debit                        |
| 12-18     | 7      | Amount | 9(5)V99  | 0025000    | Amount with implied decimal (250.00)         |

The amount field uses an implied decimal point (`V`). The value `0025000` means 00250.00 -- five integer digits followed by two decimal digits. There is no literal decimal point in the file; the `V` in the PIC clause tells COBOL where the decimal sits.

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 11 - File-Based Summary Report
      *> Reads bank transactions, classifies them as credits
      *> or debits, and produces a formatted report.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRANSACTION-REPORT.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANSACTION-FILE
               ASSIGN TO "data/transactions.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

      *> Each record: 10-char date + 1-char type + 7-digit amount
      *> Type: C = credit, D = debit
      *> Amount: 5 integer digits + 2 implied decimals
       FD TRANSACTION-FILE.
       01 TXN-RECORD.
           05 TXN-DATE        PIC X(10).
           05 TXN-TYPE        PIC X(1).
           05 TXN-AMOUNT      PIC 9(5)V99.

       WORKING-STORAGE SECTION.

      *> End-of-file flag.
       01 WS-EOF              PIC X      VALUE "N".

      *> Counters.
       01 WS-TOTAL-COUNT      PIC 99     VALUE 0.
       01 WS-CREDIT-COUNT     PIC 99     VALUE 0.
       01 WS-DEBIT-COUNT      PIC 99     VALUE 0.

      *> Accumulators.
       01 WS-CREDIT-TOTAL     PIC 9(7)V99 VALUE 0.
       01 WS-DEBIT-TOTAL      PIC 9(7)V99 VALUE 0.
       01 WS-NET-BALANCE      PIC S9(7)V99 VALUE 0.

      *> Display fields.
       01 WS-AMT-DISP         PIC ZZ,ZZ9.99.
       01 WS-CREDIT-DISP      PIC ZZ,ZZ9.99.
       01 WS-DEBIT-DISP       PIC ZZ,ZZ9.99.
       01 WS-NET-DISP         PIC -Z,ZZ9.99.

      *> Detail line layout.
       01 WS-DETAIL-LINE.
           05 WS-DL-DATE      PIC X(10).
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-TYPE       PIC X(6).
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-AMOUNT     PIC ZZ,ZZ9.99.

       PROCEDURE DIVISION.
           PERFORM PRINT-HEADER
           PERFORM READ-AND-PROCESS
           PERFORM PRINT-SUMMARY

           STOP RUN.

      *> -------------------------------------------------------
      *> PRINT-HEADER
      *> Displays the report title and column headings.
      *> -------------------------------------------------------
       PRINT-HEADER.
           DISPLAY "============================================"
           DISPLAY "       BANK TRANSACTION REPORT"
           DISPLAY "============================================"
           DISPLAY " "
           DISPLAY "Date         Type     Amount"
           DISPLAY "--------------------------------------------".

      *> -------------------------------------------------------
      *> READ-AND-PROCESS
      *> Opens the file, reads every record, classifies it,
      *> and accumulates totals.
      *> -------------------------------------------------------
       READ-AND-PROCESS.
           OPEN INPUT TRANSACTION-FILE

           PERFORM UNTIL WS-EOF = "Y"
               READ TRANSACTION-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESS-TRANSACTION
               END-READ
           END-PERFORM

           CLOSE TRANSACTION-FILE.

      *> -------------------------------------------------------
      *> PROCESS-TRANSACTION
      *> Classifies one transaction and updates accumulators.
      *> -------------------------------------------------------
       PROCESS-TRANSACTION.
           ADD 1 TO WS-TOTAL-COUNT

      *> Format the detail line.
           MOVE TXN-DATE   TO WS-DL-DATE
           MOVE TXN-AMOUNT TO WS-DL-AMOUNT

      *> Classify as credit or debit.
           EVALUATE TXN-TYPE
               WHEN "C"
                   MOVE "CREDIT" TO WS-DL-TYPE
                   ADD 1 TO WS-CREDIT-COUNT
                   ADD TXN-AMOUNT TO WS-CREDIT-TOTAL
               WHEN "D"
                   MOVE "DEBIT " TO WS-DL-TYPE
                   ADD 1 TO WS-DEBIT-COUNT
                   ADD TXN-AMOUNT TO WS-DEBIT-TOTAL
               WHEN OTHER
                   MOVE "OTHER " TO WS-DL-TYPE
           END-EVALUATE

           DISPLAY WS-DETAIL-LINE.

      *> -------------------------------------------------------
      *> PRINT-SUMMARY
      *> Computes the net balance and displays totals.
      *> -------------------------------------------------------
       PRINT-SUMMARY.
           DISPLAY "--------------------------------------------"
           DISPLAY " "

           MOVE WS-CREDIT-TOTAL TO WS-CREDIT-DISP
           MOVE WS-DEBIT-TOTAL  TO WS-DEBIT-DISP

           SUBTRACT WS-DEBIT-TOTAL FROM WS-CREDIT-TOTAL
               GIVING WS-NET-BALANCE
           MOVE WS-NET-BALANCE TO WS-NET-DISP

           DISPLAY "Total transactions: " WS-TOTAL-COUNT
           DISPLAY " "
           DISPLAY "Credits  (" WS-CREDIT-COUNT
                   "): " WS-CREDIT-DISP
           DISPLAY "Debits   (" WS-DEBIT-COUNT
                   "): " WS-DEBIT-DISP
           DISPLAY "                    ----------"
           DISPLAY "Net balance     : " WS-NET-DISP.
```

## Walkthrough

### How the pieces fit together

This lesson combines skills from four earlier lessons into one complete program:

- **File reading** (lesson 09) -- OPEN, READ with AT END, CLOSE, and the end-of-file flag pattern.
- **Formatted output** (lesson 07) -- edited PIC fields like `ZZ,ZZ9.99` for display, and FILLER fields for column spacing.
- **EVALUATE** (lesson 05) -- classifying each transaction as a credit or debit based on the type code.
- **Paragraphs** (lesson 06) -- separating the program into PRINT-HEADER, READ-AND-PROCESS, PROCESS-TRANSACTION, and PRINT-SUMMARY for clean structure.

The result is a program that reads a data file, processes every record, and produces a formatted report -- the most common task in COBOL's 60+ year history.

### Paragraph structure -- clean separation of concerns

```cobol
       PROCEDURE DIVISION.
           PERFORM PRINT-HEADER
           PERFORM READ-AND-PROCESS
           PERFORM PRINT-SUMMARY

           STOP RUN.
```

The main logic reads like an outline: print the header, read and process the file, print the summary. Each step is a separate paragraph. This is the COBOL approach to program organization -- the PROCEDURE DIVISION tells you **what** the program does, and each paragraph tells you **how** it does one piece.

`PRINT-HEADER` handles all report header output. `READ-AND-PROCESS` handles the entire file I/O lifecycle (open, read loop, close). `PROCESS-TRANSACTION` handles one record at a time. `PRINT-SUMMARY` computes and displays the final totals. No paragraph tries to do more than one job.

### The detail line layout -- group-level item with FILLER

```cobol
       01 WS-DETAIL-LINE.
           05 WS-DL-DATE      PIC X(10).
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-TYPE       PIC X(6).
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-AMOUNT     PIC ZZ,ZZ9.99.
```

This is the same technique from lesson 07 -- a group-level item whose subordinate fields form a single line of output. The FILLER fields insert three spaces between columns, creating consistent alignment. When the program executes `DISPLAY WS-DETAIL-LINE`, COBOL concatenates all the subordinate fields (including the FILLER spaces) into one string and displays it as a single line.

The amount field uses `PIC ZZ,ZZ9.99` -- an edited numeric picture that replaces leading zeros with spaces and inserts a comma and decimal point. This is why `250.00` appears as `    250.00` (right-aligned with leading spaces) rather than the raw `0025000` stored in the file.

### EVALUATE TXN-TYPE -- classifying records

```cobol
           EVALUATE TXN-TYPE
               WHEN "C"
                   MOVE "CREDIT" TO WS-DL-TYPE
                   ADD 1 TO WS-CREDIT-COUNT
                   ADD TXN-AMOUNT TO WS-CREDIT-TOTAL
               WHEN "D"
                   MOVE "DEBIT " TO WS-DL-TYPE
                   ADD 1 TO WS-DEBIT-COUNT
                   ADD TXN-AMOUNT TO WS-DEBIT-TOTAL
               WHEN OTHER
                   MOVE "OTHER " TO WS-DL-TYPE
           END-EVALUATE
```

The `EVALUATE` statement (from lesson 05) works like a `switch` in modern languages. Each `WHEN` branch handles one transaction type. The `WHEN OTHER` branch catches any record that is neither "C" nor "D" -- a defensive programming practice that ensures unexpected data does not cause silent errors.

Each branch does three things: sets the display label, increments the type-specific counter, and adds the amount to the type-specific accumulator. This is the classify step in the read-classify-accumulate-report pattern.

### Multiple accumulators -- separate tracking for credits and debits

```cobol
      *> Counters.
       01 WS-TOTAL-COUNT      PIC 99     VALUE 0.
       01 WS-CREDIT-COUNT     PIC 99     VALUE 0.
       01 WS-DEBIT-COUNT      PIC 99     VALUE 0.

      *> Accumulators.
       01 WS-CREDIT-TOTAL     PIC 9(7)V99 VALUE 0.
       01 WS-DEBIT-TOTAL      PIC 9(7)V99 VALUE 0.
       01 WS-NET-BALANCE      PIC S9(7)V99 VALUE 0.
```

The program maintains six running totals: three counters (total, credits, debits) and three amount accumulators (credit total, debit total, net balance). Each is initialized to zero with `VALUE 0`. As the program reads each record, the appropriate counter and accumulator are updated inside the EVALUATE branches.

This multi-accumulator pattern is extremely common in COBOL reporting. Real-world programs might track dozens of accumulators -- totals by region, by product, by department -- all updated record by record in a single pass through the file.

### PIC S9(7)V99 -- signed numeric fields

```cobol
       01 WS-NET-BALANCE      PIC S9(7)V99 VALUE 0.
```

The `S` at the beginning of the PIC clause means this field can hold negative values. The net balance is computed as credits minus debits -- if debits exceed credits, the result is negative. Without the `S`, a negative result would lose its sign and produce an incorrect positive number.

The other accumulators (`WS-CREDIT-TOTAL`, `WS-DEBIT-TOTAL`) do not need the `S` because they can never be negative -- they only accumulate positive amounts.

### PIC -Z,ZZ9.99 -- displaying signed values

```cobol
       01 WS-NET-DISP         PIC -Z,ZZ9.99.
```

The `-` at the beginning of this edited PIC clause is the sign display character. When the value is negative, the minus sign appears in the output. When the value is positive or zero, a space appears instead. Combined with `Z` for zero suppression, this gives clean output like `    710.00` for positive values and `-   710.00` for negative values.

Compare this with the unsigned display fields like `PIC ZZ,ZZ9.99` used for credits and debits -- those never show a sign because those totals are always positive.

### The read-classify-accumulate-report pattern

This program follows the most fundamental pattern in COBOL batch processing:

1. **Read** -- open the file and read records one at a time.
2. **Classify** -- determine what kind of record it is (credit, debit, or other).
3. **Accumulate** -- update the appropriate counters and totals.
4. **Report** -- after all records are processed, display the accumulated results.

This pattern has been the backbone of business data processing for over 60 years. Millions of programs in banking, insurance, payroll, and government follow exactly this structure. The data files and report formats change, but the pattern remains the same.

### Comparison to modern languages

In a modern language, you might accomplish the same task like this:

- **Python**: read a CSV with `pandas`, use `groupby("type").sum()`, format with f-strings.
- **SQL**: `SELECT type, COUNT(*), SUM(amount) FROM transactions GROUP BY type`.
- **JavaScript**: use `reduce()` to accumulate totals by type.

The key difference is that COBOL processes one record at a time in a single pass through the file. It never loads the entire dataset into memory. For the small file in this lesson, that distinction does not matter. For a file with 50 million records -- common in banking -- it matters enormously. COBOL's record-at-a-time approach uses constant memory regardless of file size.

## How to compile and run

```bash
cobc -x -o transaction_report main.cob
./transaction_report
```

Make sure the `data/transactions.dat` file exists relative to the directory where you run the program.

## Expected output

```text
============================================
       BANK TRANSACTION REPORT
============================================

Date         Type     Amount
--------------------------------------------
2026-01-15   CREDIT      250.00
2026-01-16   DEBIT       125.00
2026-01-18   CREDIT      500.00
2026-01-20   DEBIT        80.00
2026-01-22   CREDIT      315.00
2026-01-25   DEBIT       150.00
--------------------------------------------

Total transactions: 06

Credits  (03):   1,065.00
Debits   (03):     355.00
                    ----------
Net balance     :     710.00
```

The detail section lists every transaction with its date, type label, and formatted amount. The summary section shows the total count, credit and debit subtotals with their counts, and the net balance (credits minus debits). All amounts are formatted with commas and decimal points thanks to the edited PIC fields.

## Exercises

1. **Add the largest transaction.** Track the highest amount (and its date) during the read loop. Add two WORKING-STORAGE fields: `WS-MAX-AMOUNT PIC 9(5)V99 VALUE 0` and `WS-MAX-DATE PIC X(10)`. In `PROCESS-TRANSACTION`, after reading each record, compare `TXN-AMOUNT` to `WS-MAX-AMOUNT`. If the current amount is larger, update both the max amount and the max date. Display the result in the summary section as `"Largest transaction: [date] [amount]"`.

2. **Write the report to a file.** Add a second `SELECT`/`FD` for an output report file (e.g., `data/report.txt`). Replace `DISPLAY` statements with `WRITE` statements that send each line to the output file. This combines the file-writing skills from lesson 10 with the reporting logic from this lesson. After running the program, open `data/report.txt` to verify the output matches.

3. **Add a new transaction type "T" for transfers.** Update the `EVALUATE` to handle three types: "C" for credits, "D" for debits, and "T" for transfers. Add a transfer counter (`WS-TRANSFER-COUNT`) and a transfer total (`WS-TRANSFER-TOTAL`). Display them in the summary alongside the credit and debit totals. Add some "T" records to `transactions.dat` to test it.

## What comes next

In the next lesson you will apply everything you have learned across lessons 01-11 in a set of larger, self-contained programs -- see [12 - Mini Projects](../12_mini_projects/).
