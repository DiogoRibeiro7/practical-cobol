      *> -------------------------------------------------------
      *> Lesson 05 - IF, Nested IF, and EVALUATE
      *> Comprehensive control flow in COBOL.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONTROL-FLOW.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> Student score to classify (hardcoded so every branch
      *> can be demonstrated in a single run).
       01 WS-SCORE            PIC 999 VALUE 0.

      *> Result fields for each demonstration.
       01 WS-PASS-FAIL        PIC X(6)  VALUE SPACES.
       01 WS-GRADE-IF         PIC X(12) VALUE SPACES.
       01 WS-GRADE-EVAL       PIC X(12) VALUE SPACES.

      *> -------------------------------------------------------
      *> PART 1 — Simple IF / ELSE
      *> -------------------------------------------------------
       PROCEDURE DIVISION.

           DISPLAY "========================================".
           DISPLAY " PART 1: Simple IF / ELSE".
           DISPLAY "========================================".

           MOVE 72 TO WS-SCORE.

           IF WS-SCORE >= 50
               MOVE "PASSED" TO WS-PASS-FAIL
           ELSE
               MOVE "FAILED" TO WS-PASS-FAIL
           END-IF.

           DISPLAY "Score : " WS-SCORE.
           DISPLAY "Result: " WS-PASS-FAIL.

      *> -------------------------------------------------------
      *> PART 2 — Nested IF for detailed classification
      *> -------------------------------------------------------
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 2: Nested IF".
           DISPLAY "========================================".

           MOVE 85 TO WS-SCORE.

           IF WS-SCORE >= 90
               MOVE "EXCELLENT" TO WS-GRADE-IF
           ELSE
               IF WS-SCORE >= 75
                   MOVE "GOOD" TO WS-GRADE-IF
               ELSE
                   IF WS-SCORE >= 50
                       MOVE "AVERAGE" TO WS-GRADE-IF
                   ELSE
                       MOVE "POOR" TO WS-GRADE-IF
                   END-IF
               END-IF
           END-IF.

           DISPLAY "Score : " WS-SCORE.
           DISPLAY "Grade : " WS-GRADE-IF.

      *> -------------------------------------------------------
      *> PART 3 — EVALUATE (the cleaner way)
      *> -------------------------------------------------------
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 3: EVALUATE".
           DISPLAY "========================================".

           MOVE 42 TO WS-SCORE.

           EVALUATE TRUE
               WHEN WS-SCORE >= 90
                   MOVE "EXCELLENT" TO WS-GRADE-EVAL
               WHEN WS-SCORE >= 75
                   MOVE "GOOD" TO WS-GRADE-EVAL
               WHEN WS-SCORE >= 50
                   MOVE "AVERAGE" TO WS-GRADE-EVAL
               WHEN OTHER
                   MOVE "POOR" TO WS-GRADE-EVAL
           END-EVALUATE.

           DISPLAY "Score : " WS-SCORE.
           DISPLAY "Grade : " WS-GRADE-EVAL.

      *> -------------------------------------------------------
      *> PART 4 — EVALUATE with exact values
      *> -------------------------------------------------------
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 4: EVALUATE with exact values".
           DISPLAY "========================================".

           MOVE 3 TO WS-SCORE.

           EVALUATE WS-SCORE
               WHEN 1
                   DISPLAY "Quarter: Q1 (Jan-Mar)"
               WHEN 2
                   DISPLAY "Quarter: Q2 (Apr-Jun)"
               WHEN 3
                   DISPLAY "Quarter: Q3 (Jul-Sep)"
               WHEN 4
                   DISPLAY "Quarter: Q4 (Oct-Dec)"
               WHEN OTHER
                   DISPLAY "Quarter: INVALID"
           END-EVALUATE.

           STOP RUN.
