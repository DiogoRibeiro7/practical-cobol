      *> -------------------------------------------------------
      *> Lesson 03 - MOVE, ACCEPT, and DISPLAY
      *> Reading user input and moving data between fields.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INPUT-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *> Field to receive raw keyboard input.
       01 WS-RAW-NAME     PIC X(20).
      *> Field to hold a copy after MOVE.
       01 WS-STORED-NAME  PIC X(20).

       PROCEDURE DIVISION.
           DISPLAY "ENTER YOUR NAME: ".
      *> ACCEPT reads one line from the terminal.
           ACCEPT WS-RAW-NAME.
      *> MOVE copies data from one field to another.
           MOVE WS-RAW-NAME TO WS-STORED-NAME.
           DISPLAY "YOU ENTERED: " WS-STORED-NAME.
           STOP RUN.
