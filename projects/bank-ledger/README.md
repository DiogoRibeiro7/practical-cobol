# Bank Ledger Summarizer

A mini project that reads bank transactions from a data file, classifies each as a deposit or withdrawal, maintains a running balance, and produces a formatted account statement.

This is the second end-to-end project in the repository. While the payroll processor (the first project) focuses on computing values per record, this project focuses on **maintaining state across records** — the running balance changes with every transaction, and the final report reflects the cumulative effect of all transactions.

## Project objective

Build a COBOL program that:

1. Reads transaction records from a sequential file
2. Classifies each transaction as a deposit (D) or withdrawal (W)
3. Maintains a running balance starting from a fixed opening balance
4. Displays a formatted detail line for every transaction with the updated balance
5. Prints a summary with total deposits, total withdrawals, and closing balance

## What is a ledger?

A **ledger** is a list of financial transactions in order. Each entry records a date, a description, an amount, and the running balance after that transaction. Ledgers are the foundation of accounting and banking. COBOL has processed ledgers since the 1960s — the read-classify-accumulate pattern used here runs in thousands of production banking systems today.

## Input file format

The input file is `data/transactions.dat`. Each line is a fixed-width record of 40 characters:

```text
TXN0012026-03-01D0100000SALARY DEPOSIT
TXN0022026-03-03W0004500GROCERY STORE
TXN0032026-03-05W0012000ELECTRIC BILL
TXN0042026-03-10D0025000FREELANCE WORK
TXN0052026-03-12W0008000RESTAURANT
TXN0062026-03-15D0100000SALARY DEPOSIT
TXN0072026-03-18W0035000RENT PAYMENT
TXN0082026-03-20W0006500PHONE BILL
TXN0092026-03-25D0005000REFUND
TXN0102026-03-28W0015000INSURANCE
```

Record layout:

| Positions | Length | Field | PIC | Example | Meaning |
| --------- | ------ | ----- | --- | ------- | ------- |
| 1-6 | 6 | Transaction ID | X(6) | TXN001 | Unique identifier |
| 7-16 | 10 | Date | X(10) | 2026-03-01 | Transaction date |
| 17 | 1 | Type | X(1) | D | D = deposit, W = withdrawal |
| 18-24 | 7 | Amount | 9(5)V99 | 0100000 | Amount with 2 implied decimals (1000.00) |
| 25-40 | 16 | Description | X(16) | SALARY DEPOSIT | Transaction description |

The amount field uses `PIC 9(5)V99` — five integer digits and two implied decimal digits. `0100000` means 1000.00. `0004500` means 45.00.

## Business rules

1. **Opening balance**: 1000.00 (hardcoded in WORKING-STORAGE)
2. **Deposit (D)**: adds the transaction amount to the running balance
3. **Withdrawal (W)**: subtracts the transaction amount from the running balance
4. **Running balance**: updated after every transaction and displayed on the detail line
5. **Summary**: totals for deposits and withdrawals, counts of each type, opening and closing balance

**Example — first three transactions:**

| # | Type | Amount | Calculation | Running balance |
| - | ---- | ------ | ----------- | --------------- |
| — | Opening | — | — | 1,000.00 |
| 1 | Deposit | 1,000.00 | 1,000.00 + 1,000.00 | 2,000.00 |
| 2 | Withdraw | 45.00 | 2,000.00 - 45.00 | 1,955.00 |
| 3 | Withdraw | 120.00 | 1,955.00 - 120.00 | 1,835.00 |

## Program structure

```text
PROCEDURE DIVISION
    PERFORM PRINT-STATEMENT-HEADER     → account info, column headings
    PERFORM READ-ALL-TRANSACTIONS      → open file, loop, close
        PERFORM PROCESS-TRANSACTION    → classify, update balance, display
    PERFORM PRINT-STATEMENT-SUMMARY    → totals and closing balance
    STOP RUN
```

Four paragraphs, each with one clear job. The main flow reads like a business description: print the header, read all transactions, print the summary.

## Code

```cobol
      *> =============================================================
      *> BANK LEDGER SUMMARIZER
      *> Reads deposit and withdrawal transactions from a file,
      *> maintains a running balance, and produces a formatted
      *> bank account statement.
      *>
      *> Business rules:
      *>   - Opening balance is a fixed starting value
      *>   - D = deposit (adds to balance)
      *>   - W = withdrawal (subtracts from balance)
      *>   - Running balance is updated after every transaction
      *>   - Summary shows total deposits, total withdrawals,
      *>     number of each, and closing balance
      *>
      *> Concepts used from earlier lessons:
      *>   - PIC clauses and edited fields (lessons 02, 07)
      *>   - Arithmetic with COMPUTE (lesson 04)
      *>   - IF and EVALUATE (lesson 05)
      *>   - Paragraph-based structure (lesson 06)
      *>   - Group-level display lines (lesson 07)
      *>   - Sequential file reading (lesson 09)
      *>   - Accumulators and report formatting (lesson 11)
      *> =============================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANK-LEDGER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANSACTION-FILE
               ASSIGN TO "data/transactions.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

      *> =============================================================
      *> FILE SECTION — input record layout (40 chars per line)
      *> =============================================================
       FILE SECTION.
       FD TRANSACTION-FILE.
       01 TXN-RECORD.
           05 TXN-ID           PIC X(6).
           05 TXN-DATE         PIC X(10).
           05 TXN-TYPE         PIC X(1).
           05 TXN-AMOUNT       PIC 9(5)V99.
           05 TXN-DESC         PIC X(16).

      *> =============================================================
      *> WORKING-STORAGE SECTION
      *> =============================================================
       WORKING-STORAGE SECTION.

      *> --- End-of-file flag ---
       01 WS-EOF               PIC X VALUE "N".

      *> --- Account info ---
       01 WS-ACCOUNT-HOLDER    PIC X(20)
                               VALUE "MARIA SANTOS".
       01 WS-ACCOUNT-NUMBER    PIC X(12)
                               VALUE "ACC-20260101".
       01 WS-OPENING-BALANCE   PIC 9(7)V99 VALUE 1000.00.

      *> --- Running balance (signed to allow overdraft) ---
       01 WS-BALANCE           PIC S9(7)V99 VALUE 0.

      *> --- Accumulators ---
       01 WS-DEPOSIT-TOTAL     PIC 9(7)V99 VALUE 0.
       01 WS-WITHDRAW-TOTAL    PIC 9(7)V99 VALUE 0.
       01 WS-DEPOSIT-COUNT     PIC 99      VALUE 0.
       01 WS-WITHDRAW-COUNT    PIC 99      VALUE 0.
       01 WS-TOTAL-COUNT       PIC 99      VALUE 0.

      *> --- Edited display fields ---
       01 WS-OPEN-BAL-DISP     PIC ZZ,ZZ9.99.
       01 WS-DEP-TOTAL-DISP    PIC ZZ,ZZ9.99.
       01 WS-WDR-TOTAL-DISP    PIC ZZ,ZZ9.99.
       01 WS-CLOSE-BAL-DISP    PIC ZZ,ZZ9.99.

      *> --- Detail line layout ---
       01 WS-DETAIL-LINE.
           05 WS-DL-DATE       PIC X(10).
           05 FILLER            PIC X(3) VALUE "   ".
           05 WS-DL-ID         PIC X(6).
           05 FILLER            PIC X(2) VALUE "  ".
           05 WS-DL-TYPE       PIC X(8).
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-AMOUNT     PIC Z,ZZ9.99.
           05 FILLER            PIC X(2) VALUE "  ".
           05 WS-DL-BALANCE    PIC ZZ,ZZ9.99.
           05 FILLER            PIC X(2) VALUE "  ".
           05 WS-DL-DESC       PIC X(16).

      *> =============================================================
      *> PROCEDURE DIVISION — main flow
      *> =============================================================
       PROCEDURE DIVISION.
           PERFORM PRINT-STATEMENT-HEADER
           PERFORM READ-ALL-TRANSACTIONS
           PERFORM PRINT-STATEMENT-SUMMARY

           STOP RUN.

      *> -------------------------------------------------------------
      *> PRINT-STATEMENT-HEADER
      *> Displays account info, opening balance, and column headings.
      *> -------------------------------------------------------------
       PRINT-STATEMENT-HEADER.
           DISPLAY "============================================"
                   "========================="
           DISPLAY "              BANK ACCOUNT STATEMENT"
           DISPLAY "============================================"
                   "========================="
           DISPLAY " "
           DISPLAY "Account holder : " WS-ACCOUNT-HOLDER
           DISPLAY "Account number : " WS-ACCOUNT-NUMBER

           MOVE WS-OPENING-BALANCE TO WS-OPEN-BAL-DISP
           DISPLAY "Opening balance: " WS-OPEN-BAL-DISP

           DISPLAY " "
           DISPLAY "Date         ID      Type"
                   "      Amount    Balance   Description"
           DISPLAY "--------------------------------------------"
                   "-------------------------".

      *> -------------------------------------------------------------
      *> READ-ALL-TRANSACTIONS
      *> Opens the file, initializes the running balance,
      *> and loops through every record.
      *> -------------------------------------------------------------
       READ-ALL-TRANSACTIONS.
           MOVE WS-OPENING-BALANCE TO WS-BALANCE

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

      *> -------------------------------------------------------------
      *> PROCESS-TRANSACTION
      *> Classifies the transaction, updates the running balance,
      *> and displays a formatted detail line.
      *> -------------------------------------------------------------
       PROCESS-TRANSACTION.
           ADD 1 TO WS-TOTAL-COUNT

      *> --- Update balance based on transaction type ---
           EVALUATE TXN-TYPE
               WHEN "D"
                   ADD TXN-AMOUNT TO WS-BALANCE
                   ADD TXN-AMOUNT TO WS-DEPOSIT-TOTAL
                   ADD 1 TO WS-DEPOSIT-COUNT
                   MOVE "DEPOSIT " TO WS-DL-TYPE
               WHEN "W"
                   SUBTRACT TXN-AMOUNT FROM WS-BALANCE
                   ADD TXN-AMOUNT TO WS-WITHDRAW-TOTAL
                   ADD 1 TO WS-WITHDRAW-COUNT
                   MOVE "WITHDRAW" TO WS-DL-TYPE
               WHEN OTHER
                   MOVE "UNKNOWN " TO WS-DL-TYPE
           END-EVALUATE

      *> --- Build and display the detail line ---
           MOVE TXN-DATE    TO WS-DL-DATE
           MOVE TXN-ID      TO WS-DL-ID
           MOVE TXN-AMOUNT  TO WS-DL-AMOUNT
           MOVE WS-BALANCE  TO WS-DL-BALANCE
           MOVE TXN-DESC    TO WS-DL-DESC

           DISPLAY WS-DETAIL-LINE.

      *> -------------------------------------------------------------
      *> PRINT-STATEMENT-SUMMARY
      *> Displays totals, counts, and closing balance.
      *> -------------------------------------------------------------
       PRINT-STATEMENT-SUMMARY.
           DISPLAY "--------------------------------------------"
                   "-------------------------"
           DISPLAY " "

           MOVE WS-DEPOSIT-TOTAL  TO WS-DEP-TOTAL-DISP
           MOVE WS-WITHDRAW-TOTAL TO WS-WDR-TOTAL-DISP
           MOVE WS-BALANCE        TO WS-CLOSE-BAL-DISP

           DISPLAY "ACCOUNT SUMMARY"
           DISPLAY " "
           DISPLAY "  Total deposits     ("
                   WS-DEPOSIT-COUNT
                   "):  " WS-DEP-TOTAL-DISP
           DISPLAY "  Total withdrawals  ("
                   WS-WITHDRAW-COUNT
                   "):  " WS-WDR-TOTAL-DISP
           DISPLAY "                          ----------"
           DISPLAY "  Opening balance       :  "
                   WS-OPEN-BAL-DISP
           DISPLAY "  Closing balance       :  "
                   WS-CLOSE-BAL-DISP
           DISPLAY " "
           DISPLAY "  Transactions processed: "
                   WS-TOTAL-COUNT
           DISPLAY "============================================"
                   "=========================".
```

## How to compile and run

```bash
cd projects/bank-ledger
cobc -x -o ledger main.cob
./ledger
```

Make sure `data/transactions.dat` exists relative to where you run the program.

## Expected output

```text
=====================================================================
              BANK ACCOUNT STATEMENT
=====================================================================

Account holder : MARIA SANTOS
Account number : ACC-20260101
Opening balance:  1,000.00

Date         ID      Type      Amount    Balance   Description
---------------------------------------------------------------------
2026-03-01   TXN001  DEPOSIT  1,000.00   2,000.00  SALARY DEPOSIT
2026-03-03   TXN002  WITHDRAW    45.00   1,955.00  GROCERY STORE
2026-03-05   TXN003  WITHDRAW   120.00   1,835.00  ELECTRIC BILL
2026-03-10   TXN004  DEPOSIT    250.00   2,085.00  FREELANCE WORK
2026-03-12   TXN005  WITHDRAW    80.00   2,005.00  RESTAURANT
2026-03-15   TXN006  DEPOSIT  1,000.00   3,005.00  SALARY DEPOSIT
2026-03-18   TXN007  WITHDRAW   350.00   2,655.00  RENT PAYMENT
2026-03-20   TXN008  WITHDRAW    65.00   2,590.00  PHONE BILL
2026-03-25   TXN009  DEPOSIT     50.00   2,640.00  REFUND
2026-03-28   TXN010  WITHDRAW   150.00   2,490.00  INSURANCE
---------------------------------------------------------------------

ACCOUNT SUMMARY

  Total deposits     (04):   2,300.00
  Total withdrawals  (06):     810.00
                          ----------
  Opening balance       :   1,000.00
  Closing balance       :   2,490.00

  Transactions processed: 10
=====================================================================
```

Verification: opening balance (1,000.00) + deposits (2,300.00) - withdrawals (810.00) = closing balance (2,490.00).

## How this project connects earlier lessons

| Lesson | Concept used here |
| ------ | ----------------- |
| 02 — Variables and PIC | `PIC X`, `PIC 9(5)V99`, `PIC S9(7)V99` for data definitions |
| 04 — Arithmetic | `ADD`, `SUBTRACT` for updating the running balance and accumulators |
| 05 — IF and EVALUATE | `EVALUATE TXN-TYPE` to classify deposits vs withdrawals |
| 06 — PERFORM and Paragraphs | Four paragraphs with clear separation: header, read loop, process, summary |
| 07 — Formatting | Group-level `WS-DETAIL-LINE` with FILLER, `PIC ZZ,ZZ9.99` for currency |
| 09 — Sequential Files | `SELECT`, `FD`, `OPEN INPUT`, `READ ... AT END`, `CLOSE` |
| 11 — Summary Report | Header/detail/footer pattern, multiple accumulators, formatted totals |

**New concept in this project:** The **running balance** — a value that changes with every record and carries its state from one transaction to the next. The payroll project computed each employee independently; here, each transaction depends on the cumulative result of all previous transactions.

## What to study in this project

1. **Running state vs independent records.** In the payroll project, each employee's pay is computed from scratch. Here, `WS-BALANCE` carries forward — each transaction modifies it. This is the difference between a calculation engine and a ledger.

2. **EVALUATE for dispatch.** The `EVALUATE TXN-TYPE` block handles "D" and "W" with different logic. The `WHEN OTHER` branch catches any unexpected transaction types — a defensive practice that prevents silent data corruption.

3. **PIC S9(7)V99 for the balance.** The `S` allows signed values. Even though this data set never drives the balance negative, a real ledger could. Using a signed field from the start is safer than assuming deposits will always exceed withdrawals.

4. **The detail line includes running balance.** Unlike a simple total-at-the-end report, each line shows the balance after that transaction. This is the hallmark of a ledger — every row is a snapshot of the account state.

5. **The summary is a cross-check.** Opening balance + total deposits - total withdrawals must equal closing balance. If it does not, there is a bug. This kind of control total is standard in financial COBOL programs.

## Exercises

1. **Overdraft warning.** After updating `WS-BALANCE` in `PROCESS-TRANSACTION`, check if it is less than zero. If so, display a warning line: `"  *** OVERDRAFT WARNING ***"` directly below the detail line. Test it by adding a large withdrawal to the data file that exceeds the balance.

2. **Average transaction amount.** After the loop, compute the average transaction amount by dividing the sum of all amounts (deposits + withdrawals) by the total transaction count. Display it in the summary section as `"  Average transaction  :  ZZ,ZZ9.99"`. Use `PIC 9(7)V99` for the sum and `PIC ZZ,ZZ9.99` for the display.

3. **Separate deposit and withdrawal counts.** This project already tracks `WS-DEPOSIT-COUNT` and `WS-WITHDRAW-COUNT`. Extend the summary to also show the percentage of transactions that are deposits vs withdrawals. Use `COMPUTE WS-DEP-PCT = (WS-DEPOSIT-COUNT / WS-TOTAL-COUNT) * 100` and display it as `"  Deposits: XX% of transactions"`.

4. **Highest and lowest balance.** Add two variables: `WS-HIGH-BALANCE` and `WS-LOW-BALANCE`. Initialize `WS-HIGH-BALANCE` to 0 and `WS-LOW-BALANCE` to the opening balance. After each balance update, check if the new balance is higher or lower than the current extremes. Display both in the summary.

5. **Write the statement to a file.** Add a second `SELECT`/`FD` for an output file `data/statement.txt`. Use `WRITE` instead of `DISPLAY` for every line of the report. This creates a printable statement file — exactly how real bank systems produce customer statements.

6. **Monthly sub-totals.** If all transactions in the data file happen in the same month, this exercise is about future-proofing. Modify the data file to span two or three months. Track a "current month" variable. When the month changes between transactions, display a subtotal line for the previous month before continuing. This is a preview of the **control break** pattern used in real COBOL reporting.
