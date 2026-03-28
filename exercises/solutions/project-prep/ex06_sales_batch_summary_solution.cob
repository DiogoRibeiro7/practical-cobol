      *> -------------------------------------------------------
      *> EX06 solution - Sales Batch Summary
      *> Demonstrates the standard read/process/close pattern.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. EX06-SALES-BATCH.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALES-FILE ASSIGN TO "data/ex06_sales_batch.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD SALES-FILE.
       01 SALES-RECORD.
           05 SR-REGION         PIC X(2).
           05 SR-REP-NAME       PIC X(12).
           05 SR-UNITS-SOLD     PIC 9(3).
           05 SR-UNIT-PRICE     PIC 9(4).

       WORKING-STORAGE SECTION.
       01 WS-END-OF-FILE        PIC X      VALUE "N".
       01 WS-LINE-REVENUE       PIC 9(7)   VALUE 0.
       01 WS-GRAND-TOTAL        PIC 9(9)   VALUE 0.
       01 WS-RECORD-COUNT       PIC 9(4)   VALUE 0.
       01 WS-HIGH-COUNT         PIC 9(4)   VALUE 0.
       01 WS-STANDARD-COUNT     PIC 9(4)   VALUE 0.
       01 WS-CATEGORY           PIC X(8)   VALUE SPACES.

       PROCEDURE DIVISION.
           OPEN INPUT SALES-FILE

           PERFORM UNTIL WS-END-OF-FILE = "Y"
               READ SALES-FILE
                   AT END
                       MOVE "Y" TO WS-END-OF-FILE
                   NOT AT END
                       PERFORM PROCESS-RECORD
               END-READ
           END-PERFORM

           CLOSE SALES-FILE

           DISPLAY " "
           DISPLAY "SALES BATCH SUMMARY"
           DISPLAY "Records read : " WS-RECORD-COUNT
           DISPLAY "Grand total  : " WS-GRAND-TOTAL
           DISPLAY "High value   : " WS-HIGH-COUNT
           DISPLAY "Standard     : " WS-STANDARD-COUNT

           STOP RUN.

       PROCESS-RECORD.
           MULTIPLY SR-UNITS-SOLD BY SR-UNIT-PRICE
               GIVING WS-LINE-REVENUE

           ADD 1 TO WS-RECORD-COUNT
           ADD WS-LINE-REVENUE TO WS-GRAND-TOTAL

           IF WS-LINE-REVENUE >= 5000
               MOVE "HIGH" TO WS-CATEGORY
               ADD 1 TO WS-HIGH-COUNT
           ELSE
               MOVE "STANDARD" TO WS-CATEGORY
               ADD 1 TO WS-STANDARD-COUNT
           END-IF

      *> This detail line is useful while testing the file layout.
           DISPLAY SR-REGION
                   " "
                   SR-REP-NAME
                   " "
                   WS-LINE-REVENUE
                   " "
                   WS-CATEGORY.
