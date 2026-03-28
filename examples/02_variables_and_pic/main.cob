      *> -------------------------------------------------------
      *> Lesson 02 - Variables and PIC
      *> Demonstrates how COBOL defines data with PIC clauses.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VARIABLE-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *> PIC X(20) reserves 20 characters for text.
       01 WS-NAME     PIC X(20) VALUE "ALICE".
      *> PIC 999 reserves exactly 3 numeric digits.
       01 WS-AGE      PIC 999   VALUE 27.
      *> Another 3-digit numeric field.
       01 WS-SCORE    PIC 999   VALUE 095.

       PROCEDURE DIVISION.
           DISPLAY "NAME  : " WS-NAME.
           DISPLAY "AGE   : " WS-AGE.
           DISPLAY "SCORE : " WS-SCORE.
           STOP RUN.
