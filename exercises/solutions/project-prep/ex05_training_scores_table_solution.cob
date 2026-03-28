      *> -------------------------------------------------------
      *> EX05 solution - Training Scores Table
      *> Uses OCCURS, PERFORM VARYING, and summary counters.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. EX05-TRAINING-TABLE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-TRAINEE-TABLE.
           05 WS-TRAINEE OCCURS 5 TIMES.
               10 WS-TRAINEE-NAME   PIC X(20).
               10 WS-TRAINEE-SCORE  PIC 999.

       01 WS-IDX               PIC 9    VALUE 0.
       01 WS-TOTAL-SCORE       PIC 9(4) VALUE 0.
       01 WS-AVERAGE-SCORE     PIC 999  VALUE 0.
       01 WS-DISTINCTION-COUNT PIC 9    VALUE 0.
       01 WS-PASS-COUNT        PIC 9    VALUE 0.
       01 WS-RETRY-COUNT       PIC 9    VALUE 0.
       01 WS-STATUS            PIC X(12) VALUE SPACES.
       01 WS-TRAINEE-COUNT     PIC 9    VALUE 5.

       PROCEDURE DIVISION.
           PERFORM LOAD-TABLE

           DISPLAY "TRAINING SCORE REPORT"
           DISPLAY "---------------------"

           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > WS-TRAINEE-COUNT
               PERFORM DISPLAY-TRAINEE
           END-PERFORM

           DIVIDE WS-TOTAL-SCORE BY WS-TRAINEE-COUNT
               GIVING WS-AVERAGE-SCORE

           DISPLAY "---------------------"
           DISPLAY "Total score : " WS-TOTAL-SCORE
           DISPLAY "Average     : " WS-AVERAGE-SCORE
           DISPLAY "Distinction : " WS-DISTINCTION-COUNT
           DISPLAY "Pass        : " WS-PASS-COUNT
           DISPLAY "Retry       : " WS-RETRY-COUNT

           STOP RUN.

       LOAD-TABLE.
           MOVE "ANA SILVA"    TO WS-TRAINEE-NAME(1)
           MOVE 091            TO WS-TRAINEE-SCORE(1)
           MOVE "BRUNO LIMA"   TO WS-TRAINEE-NAME(2)
           MOVE 073            TO WS-TRAINEE-SCORE(2)
           MOVE "CARLA REIS"   TO WS-TRAINEE-NAME(3)
           MOVE 058            TO WS-TRAINEE-SCORE(3)
           MOVE "DIANA COSTA"  TO WS-TRAINEE-NAME(4)
           MOVE 087            TO WS-TRAINEE-SCORE(4)
           MOVE "ELIAS SOUSA"  TO WS-TRAINEE-NAME(5)
           MOVE 064            TO WS-TRAINEE-SCORE(5).

       DISPLAY-TRAINEE.
           EVALUATE TRUE
               WHEN WS-TRAINEE-SCORE(WS-IDX) >= 85
                   MOVE "DISTINCTION" TO WS-STATUS
                   ADD 1 TO WS-DISTINCTION-COUNT
               WHEN WS-TRAINEE-SCORE(WS-IDX) >= 60
                   MOVE "PASS" TO WS-STATUS
                   ADD 1 TO WS-PASS-COUNT
               WHEN OTHER
                   MOVE "RETRY" TO WS-STATUS
                   ADD 1 TO WS-RETRY-COUNT
           END-EVALUATE

           DISPLAY WS-TRAINEE-NAME(WS-IDX)
                   "  "
                   WS-TRAINEE-SCORE(WS-IDX)
                   "  "
                   WS-STATUS

           ADD WS-TRAINEE-SCORE(WS-IDX) TO WS-TOTAL-SCORE.
