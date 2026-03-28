      *> -------------------------------------------------------
      *> Lesson 04 - Arithmetic Operations
      *> Demonstrates ADD, SUBTRACT, MULTIPLY, and DIVIDE.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ARITHMETIC-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-A         PIC 999 VALUE 15.
       01 WS-B         PIC 999 VALUE 05.
      *> WS-RESULT stores the output of each operation.
       01 WS-RESULT    PIC 999 VALUE 0.

       PROCEDURE DIVISION.
      *> GIVING puts the result in WS-RESULT without
      *> changing WS-A or WS-B.
           ADD WS-A TO WS-B GIVING WS-RESULT.
           DISPLAY "ADD RESULT      : " WS-RESULT.

           SUBTRACT WS-B FROM WS-A GIVING WS-RESULT.
           DISPLAY "SUBTRACT RESULT : " WS-RESULT.

           MULTIPLY WS-A BY WS-B GIVING WS-RESULT.
           DISPLAY "MULTIPLY RESULT : " WS-RESULT.

           DIVIDE WS-A BY WS-B GIVING WS-RESULT.
           DISPLAY "DIVIDE RESULT   : " WS-RESULT.

           STOP RUN.
