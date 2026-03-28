       IDENTIFICATION DIVISION.
       PROGRAM-ID. MULTIPLY-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-A              PIC 9(3) VALUE 0.
       01 WS-B              PIC 9(3) VALUE 0.
       01 WS-RESULT         PIC 9(6) VALUE 0.

       PROCEDURE DIVISION.
           PERFORM READ-VALUES
           PERFORM CALCULATE-VALUES
           PERFORM PRINT-VALUES
           STOP RUN.

       READ-VALUES.
           DISPLAY "Enter A: "
           ACCEPT WS-A
           DISPLAY "Enter B: "
           ACCEPT WS-B.

       CALCULATE-VALUES.
           MULTIPLY WS-A BY WS-B GIVING WS-RESULT.

       PRINT-VALUES.
           DISPLAY "Result: " WS-RESULT.
