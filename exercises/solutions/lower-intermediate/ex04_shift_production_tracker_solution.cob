      *> -------------------------------------------------------
      *> EX04 solution - Shift Production Tracker
      *> Shows paragraph-based structure with PERFORM UNTIL.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. EX04-SHIFT-TRACKER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-TOTAL-SHIFTS      PIC 9     VALUE 0.
       01 WS-CURRENT-SHIFT     PIC 9     VALUE 0.
       01 WS-UNITS-PRODUCED    PIC 9(4)  VALUE 0.
       01 WS-TOTAL-UNITS       PIC 9(5)  VALUE 0.
       01 WS-STRONG-SHIFTS     PIC 9     VALUE 0.

       PROCEDURE DIVISION.
           PERFORM INITIALIZE-PROGRAM
           PERFORM PROCESS-SHIFTS
           PERFORM DISPLAY-SUMMARY
           STOP RUN.

       INITIALIZE-PROGRAM.
           DISPLAY "Enter number of shifts to process:"
           ACCEPT WS-TOTAL-SHIFTS
           MOVE 1 TO WS-CURRENT-SHIFT
           MOVE 0 TO WS-TOTAL-UNITS
           MOVE 0 TO WS-STRONG-SHIFTS.

       PROCESS-SHIFTS.
           PERFORM UNTIL WS-CURRENT-SHIFT > WS-TOTAL-SHIFTS
               PERFORM READ-SHIFT
               PERFORM PROCESS-ONE-SHIFT
               ADD 1 TO WS-CURRENT-SHIFT
           END-PERFORM.

       READ-SHIFT.
           DISPLAY "Enter units for shift " WS-CURRENT-SHIFT ":"
           ACCEPT WS-UNITS-PRODUCED.

       PROCESS-ONE-SHIFT.
           ADD WS-UNITS-PRODUCED TO WS-TOTAL-UNITS

           IF WS-UNITS-PRODUCED >= 100
               ADD 1 TO WS-STRONG-SHIFTS
           END-IF.

       DISPLAY-SUMMARY.
           DISPLAY " "
           DISPLAY "SHIFT PRODUCTION SUMMARY"
           DISPLAY "Shifts entered : " WS-TOTAL-SHIFTS
           DISPLAY "Total units    : " WS-TOTAL-UNITS
           DISPLAY "Strong shifts  : " WS-STRONG-SHIFTS.
