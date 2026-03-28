       IDENTIFICATION DIVISION.
       PROGRAM-ID. AGE-GROUP.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-AGE            PIC 999 VALUE 0.
       01 WS-LABEL          PIC X(10) VALUE SPACES.

       PROCEDURE DIVISION.
           DISPLAY "Enter age: "
           ACCEPT WS-AGE

           IF WS-AGE < 13
               MOVE "CHILD" TO WS-LABEL
           ELSE
               IF WS-AGE < 18
                   MOVE "TEENAGER" TO WS-LABEL
               ELSE
                   MOVE "ADULT" TO WS-LABEL
               END-IF
           END-IF

           DISPLAY "Group: " WS-LABEL
           STOP RUN.
