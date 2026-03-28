       IDENTIFICATION DIVISION.
       PROGRAM-ID. GRADE-CHECK.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-GRADE          PIC 99 VALUE 0.
       01 WS-RESULT         PIC X(10) VALUE SPACES.

       PROCEDURE DIVISION.
           DISPLAY "Enter the student's grade (0-20): "
           ACCEPT WS-GRADE

           IF WS-GRADE >= 10
               MOVE "PASSED" TO WS-RESULT
           ELSE
               MOVE "FAILED" TO WS-RESULT
           END-IF

           DISPLAY "Final result: " WS-RESULT
           STOP RUN.
