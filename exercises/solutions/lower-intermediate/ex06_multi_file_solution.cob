       IDENTIFICATION DIVISION.
       PROGRAM-ID. MULTI-FILE-SALES-SOLUTION.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALES-Q1-FILE ASSIGN TO "data/sales_q1.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT SALES-Q2-FILE ASSIGN TO "data/sales_q2.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD SALES-Q1-FILE.
       01 Q1-RECORD.
           05 Q1-PROD-CODE   PIC X(4).
           05 Q1-QUANTITY    PIC 99.
           05 Q1-UNIT-PRICE  PIC 9(4).

       FD SALES-Q2-FILE.
       01 Q2-RECORD.
           05 Q2-PROD-CODE   PIC X(4).
           05 Q2-QUANTITY    PIC 99.
           05 Q2-UNIT-PRICE  PIC 9(4).

       WORKING-STORAGE SECTION.
       01 WS-Q1-EOF           PIC X VALUE "N".
       01 WS-Q2-EOF           PIC X VALUE "N".

       01 WS-Q1-RECORD-COUNT  PIC 9(4) VALUE 0.
       01 WS-Q2-RECORD-COUNT  PIC 9(4) VALUE 0.
       01 WS-Q1-TOTAL         PIC 9(8) VALUE 0.
       01 WS-Q2-TOTAL         PIC 9(8) VALUE 0.
       01 WS-GRAND-TOTAL      PIC 9(9) VALUE 0.
       01 WS-EXTENDED-PRICE   PIC 9(8) VALUE 0.

       PROCEDURE DIVISION.
           OPEN INPUT SALES-Q1-FILE SALES-Q2-FILE

           PERFORM UNTIL WS-Q1-EOF = "Y" AND WS-Q2-EOF = "Y"

               IF WS-Q1-EOF = "N"
                   READ SALES-Q1-FILE
                       AT END
                           MOVE "Y" TO WS-Q1-EOF
                       NOT AT END
                           PERFORM PROCESS-Q1-RECORD
                   END-READ
               END-IF

               IF WS-Q2-EOF = "N"
                   READ SALES-Q2-FILE
                       AT END
                           MOVE "Y" TO WS-Q2-EOF
                       NOT AT END
                           PERFORM PROCESS-Q2-RECORD
                   END-READ
               END-IF

           END-PERFORM

           CLOSE SALES-Q1-FILE SALES-Q2-FILE
           PERFORM PRINT-SUMMARY
           STOP RUN.

       PROCESS-Q1-RECORD.
       MULTIPLY Q1-QUANTITY BY Q1-UNIT-PRICE GIVING WS-EXTENDED-PRICE
       ADD WS-EXTENDED-PRICE TO WS-Q1-TOTAL
           ADD WS-EXTENDED-PRICE TO WS-GRAND-TOTAL
           ADD 1 TO WS-Q1-RECORD-COUNT
           DISPLAY "Q1 " Q1-PROD-CODE.
           DISPLAY "      qty=" Q1-QUANTITY.
           DISPLAY "      price=" Q1-UNIT-PRICE.
           DISPLAY "      ext=" WS-EXTENDED-PRICE.

       PROCESS-Q2-RECORD.
       MULTIPLY Q2-QUANTITY BY Q2-UNIT-PRICE GIVING WS-EXTENDED-PRICE
       ADD WS-EXTENDED-PRICE TO WS-Q2-TOTAL
           ADD WS-EXTENDED-PRICE TO WS-GRAND-TOTAL
           ADD 1 TO WS-Q2-RECORD-COUNT
           DISPLAY "Q2 " Q2-PROD-CODE.
           DISPLAY "      qty=" Q2-QUANTITY.
           DISPLAY "      price=" Q2-UNIT-PRICE.
           DISPLAY "      ext=" WS-EXTENDED-PRICE.

       PRINT-SUMMARY.
           DISPLAY "-------------------------------------------"
           DISPLAY "Q1 records: " WS-Q1-RECORD-COUNT.
           DISPLAY "Q1 subtotal: " WS-Q1-TOTAL.
           DISPLAY "Q2 records: " WS-Q2-RECORD-COUNT.
           DISPLAY "Q2 subtotal: " WS-Q2-TOTAL.
           DISPLAY "Grand total: " WS-GRAND-TOTAL.
