      *> =============================================================
      *> LESSON 15 - COPYBOOKS AND SHARED RECORD LAYOUTS
      *> =============================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. COPYBOOK-TRANSACTION-SUMMARY.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANSACTION-FILE
               ASSIGN TO "data/transactions.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD TRANSACTION-FILE.
       COPY "copybooks/transaction-record.cpy".

       WORKING-STORAGE SECTION.
       01 WS-EOF                    PIC X VALUE "N".

       01 WS-OPENING-BALANCE        PIC 9(7)V99 VALUE 1000.00.
       01 WS-CLOSING-BALANCE        PIC S9(7)V99 VALUE 0.

       01 WS-RECORD-COUNT           PIC 99 VALUE 0.
       01 WS-ACCEPTED-COUNT         PIC 99 VALUE 0.
       01 WS-REJECTED-COUNT         PIC 99 VALUE 0.
       01 WS-DEPOSIT-COUNT          PIC 99 VALUE 0.
       01 WS-WITHDRAWAL-COUNT       PIC 99 VALUE 0.

       01 WS-DEPOSIT-TOTAL          PIC 9(7)V99 VALUE 0.
       01 WS-WITHDRAWAL-TOTAL       PIC 9(7)V99 VALUE 0.

       01 WS-DEPOSIT-DISPLAY        PIC ZZ,ZZ9.99.
       01 WS-WITHDRAWAL-DISPLAY     PIC ZZ,ZZ9.99.
       01 WS-BALANCE-DISPLAY        PIC -ZZ,ZZ9.99.

       PROCEDURE DIVISION.
           MOVE WS-OPENING-BALANCE TO WS-CLOSING-BALANCE

           OPEN INPUT TRANSACTION-FILE

           PERFORM UNTIL WS-EOF = "Y"
               READ TRANSACTION-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESS-TRANSACTION
               END-READ
           END-PERFORM

           CLOSE TRANSACTION-FILE

           PERFORM DISPLAY-SUMMARY

           STOP RUN.

       PROCESS-TRANSACTION.
           ADD 1 TO WS-RECORD-COUNT

           EVALUATE TXN-TYPE
               WHEN "D"
                   ADD 1 TO WS-ACCEPTED-COUNT
                   ADD 1 TO WS-DEPOSIT-COUNT
                   ADD TXN-AMOUNT TO WS-DEPOSIT-TOTAL
                   ADD TXN-AMOUNT TO WS-CLOSING-BALANCE
               WHEN "W"
                   ADD 1 TO WS-ACCEPTED-COUNT
                   ADD 1 TO WS-WITHDRAWAL-COUNT
                   ADD TXN-AMOUNT TO WS-WITHDRAWAL-TOTAL
                   SUBTRACT TXN-AMOUNT FROM WS-CLOSING-BALANCE
               WHEN OTHER
                   ADD 1 TO WS-REJECTED-COUNT
           END-EVALUATE.

       DISPLAY-SUMMARY.
           MOVE WS-DEPOSIT-TOTAL TO WS-DEPOSIT-DISPLAY
           MOVE WS-WITHDRAWAL-TOTAL TO WS-WITHDRAWAL-DISPLAY
           MOVE WS-CLOSING-BALANCE TO WS-BALANCE-DISPLAY

           DISPLAY "COPYBOOK TRANSACTION SUMMARY"
           DISPLAY "========================================"
           DISPLAY "Records read          : " WS-RECORD-COUNT
           DISPLAY "Accepted transactions : " WS-ACCEPTED-COUNT
           DISPLAY "Rejected transactions : " WS-REJECTED-COUNT
           DISPLAY "Deposits              : " WS-DEPOSIT-COUNT
           DISPLAY "Withdrawals           : " WS-WITHDRAWAL-COUNT
           DISPLAY "Total deposits        : " WS-DEPOSIT-DISPLAY
           DISPLAY "Total withdrawals     : " WS-WITHDRAWAL-DISPLAY
           DISPLAY "Closing balance       : " WS-BALANCE-DISPLAY
           DISPLAY "========================================".
