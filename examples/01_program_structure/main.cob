      *> -------------------------------------------------------
      *> Lesson 01 - Program Structure
      *> Shows the main divisions of a COBOL program.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. STRUCTURE-DEMO.

      *> DATA DIVISION is where you define all variables.
       DATA DIVISION.
      *> WORKING-STORAGE holds variables that live for the
      *> entire duration of the program.
       WORKING-STORAGE SECTION.
       01 WS-MESSAGE PIC X(30) VALUE "This is a structured program.".

      *> PROCEDURE DIVISION contains the executable logic.
       PROCEDURE DIVISION.
           DISPLAY WS-MESSAGE.
           STOP RUN.
