       IDENTIFICATION DIVISION.
       PROGRAM-ID. PERFORM-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-FIRST-NUMBER   PIC 9(4) VALUE 0.
       01 WS-SECOND-NUMBER  PIC 9(4) VALUE 0.
       01 WS-TOTAL          PIC 9(5) VALUE 0.

       PROCEDURE DIVISION.
           PERFORM GET-INPUT
           PERFORM CALCULATE-TOTAL
           PERFORM SHOW-RESULT
           STOP RUN.

       GET-INPUT.
           DISPLAY "Enter the first number: "
           ACCEPT WS-FIRST-NUMBER
           DISPLAY "Enter the second number: "
           ACCEPT WS-SECOND-NUMBER.

       CALCULATE-TOTAL.
           ADD WS-FIRST-NUMBER TO WS-SECOND-NUMBER
               GIVING WS-TOTAL.

       SHOW-RESULT.
           DISPLAY "The total is: " WS-TOTAL.
