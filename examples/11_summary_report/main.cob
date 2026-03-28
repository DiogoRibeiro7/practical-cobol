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
