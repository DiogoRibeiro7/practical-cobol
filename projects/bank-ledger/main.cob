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
