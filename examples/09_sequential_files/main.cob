       IDENTIFICATION DIVISION.
       PROGRAM-ID. SALES-REPORT.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALES-FILE ASSIGN TO "data/sales.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD SALES-FILE.
       01 SALES-RECORD.
           05 SR-PRODUCT-CODE    PIC X(4).
           05 SR-QUANTITY        PIC 99.
           05 SR-UNIT-PRICE      PIC 9(4).

       WORKING-STORAGE SECTION.
       01 WS-END-OF-FILE         PIC X VALUE "N".
       01 WS-LINE-TOTAL          PIC 9(6) VALUE 0.
       01 WS-GRAND-TOTAL         PIC 9(8) VALUE 0.
       01 WS-RECORD-COUNT        PIC 9(4) VALUE 0.

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

           DISPLAY "Records read : " WS-RECORD-COUNT
           DISPLAY "Grand total  : " WS-GRAND-TOTAL
           STOP RUN.

       PROCESS-RECORD.
           MULTIPLY SR-QUANTITY BY SR-UNIT-PRICE
               GIVING WS-LINE-TOTAL
           ADD 1 TO WS-RECORD-COUNT
           ADD WS-LINE-TOTAL TO WS-GRAND-TOTAL.
