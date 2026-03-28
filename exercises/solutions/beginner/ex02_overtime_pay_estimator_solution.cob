      *> -------------------------------------------------------
      *> EX02 solution - Overtime Pay Estimator
      *> Separates hours, pay components, and final total.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. EX02-OVERTIME-PAY.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-EMPLOYEE-NAME     PIC X(20) VALUE SPACES.
       01 WS-HOURLY-RATE       PIC 9(3)  VALUE 0.
       01 WS-TOTAL-HOURS       PIC 99    VALUE 0.
       01 WS-REGULAR-HOURS     PIC 99    VALUE 0.
       01 WS-OVERTIME-HOURS    PIC 99    VALUE 0.
       01 WS-REGULAR-PAY       PIC 9(5)  VALUE 0.
       01 WS-OVERTIME-RATE     PIC 9(4)  VALUE 0.
       01 WS-OVERTIME-PAY      PIC 9(5)  VALUE 0.
       01 WS-TOTAL-PAY         PIC 9(6)  VALUE 0.

       PROCEDURE DIVISION.
           DISPLAY "Enter employee name:"
           ACCEPT WS-EMPLOYEE-NAME

           DISPLAY "Enter hourly rate:"
           ACCEPT WS-HOURLY-RATE

           DISPLAY "Enter total hours worked:"
           ACCEPT WS-TOTAL-HOURS

      *> First decide how many hours belong to each category.
           IF WS-TOTAL-HOURS > 40
               MOVE 40 TO WS-REGULAR-HOURS
               SUBTRACT 40 FROM WS-TOTAL-HOURS
                   GIVING WS-OVERTIME-HOURS
           ELSE
               MOVE WS-TOTAL-HOURS TO WS-REGULAR-HOURS
               MOVE 0 TO WS-OVERTIME-HOURS
           END-IF

      *> Then compute each pay component using separate fields.
           MULTIPLY WS-REGULAR-HOURS BY WS-HOURLY-RATE
               GIVING WS-REGULAR-PAY

           MULTIPLY WS-HOURLY-RATE BY 2
               GIVING WS-OVERTIME-RATE

           MULTIPLY WS-OVERTIME-HOURS BY WS-OVERTIME-RATE
               GIVING WS-OVERTIME-PAY

           ADD WS-REGULAR-PAY TO WS-OVERTIME-PAY
               GIVING WS-TOTAL-PAY

           DISPLAY " "
           DISPLAY "PAY SUMMARY"
           DISPLAY "Name          : " WS-EMPLOYEE-NAME
           DISPLAY "Regular hours : " WS-REGULAR-HOURS
           DISPLAY "Overtime hours: " WS-OVERTIME-HOURS
           DISPLAY "Regular pay   : " WS-REGULAR-PAY
           DISPLAY "Overtime pay  : " WS-OVERTIME-PAY
           DISPLAY "Total pay     : " WS-TOTAL-PAY

           STOP RUN.
