      *> -------------------------------------------------------
      *> Lesson 06 - PERFORM and Paragraphs
      *> Demonstrates paragraph-based program flow, PERFORM,
      *> PERFORM N TIMES, and PERFORM UNTIL.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PERFORM-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> --- Part 1: employee data for paragraph demo ---
       01 WS-EMPLOYEE-NAME    PIC X(15) VALUE "MARIA SANTOS".
       01 WS-BASE-SALARY      PIC 9(5)  VALUE 03200.
       01 WS-BONUS            PIC 9(5)  VALUE 0.
       01 WS-NET-PAY          PIC 9(5)  VALUE 0.

      *> --- Part 2: counter for PERFORM TIMES ---
       01 WS-LINE-COUNT       PIC 9     VALUE 0.

      *> --- Part 3: counter and total for PERFORM UNTIL ---
       01 WS-COUNTER          PIC 99    VALUE 0.
       01 WS-RUNNING-TOTAL    PIC 9(4)  VALUE 0.

      *> =======================================================
      *> MAIN FLOW
      *> Read this section first. It is the table of contents
      *> for the entire program.
      *> =======================================================
       PROCEDURE DIVISION.

      *> --- Part 1: paragraph-based flow ---
           DISPLAY "========================================".
           DISPLAY " PART 1: Paragraph-based flow".
           DISPLAY "========================================".
           PERFORM COMPUTE-BONUS
           PERFORM SHOW-PAYSLIP

      *> --- Part 2: PERFORM N TIMES ---
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 2: PERFORM 3 TIMES".
           DISPLAY "========================================".
           PERFORM PRINT-SEPARATOR 3 TIMES

      *> --- Part 3: PERFORM UNTIL ---
           DISPLAY " ".
           DISPLAY "========================================".
           DISPLAY " PART 3: PERFORM UNTIL".
           DISPLAY "========================================".
           MOVE 1 TO WS-COUNTER
           MOVE 0 TO WS-RUNNING-TOTAL
           PERFORM ACCUMULATE-STEP
               UNTIL WS-COUNTER > 5
           DISPLAY "Final total: " WS-RUNNING-TOTAL

           STOP RUN.

      *> =======================================================
      *> PARAGRAPHS
      *> Each paragraph handles one clear task.
      *> =======================================================

      *> -------------------------------------------------------
      *> COMPUTE-BONUS
      *> Calculates a 15% bonus on the base salary.
      *> -------------------------------------------------------
       COMPUTE-BONUS.
           MULTIPLY WS-BASE-SALARY BY 15
               GIVING WS-BONUS
           DIVIDE WS-BONUS BY 100
               GIVING WS-BONUS
           ADD WS-BASE-SALARY TO WS-BONUS
               GIVING WS-NET-PAY.

      *> -------------------------------------------------------
      *> SHOW-PAYSLIP
      *> Displays the employee summary.
      *> -------------------------------------------------------
       SHOW-PAYSLIP.
           DISPLAY "Employee : " WS-EMPLOYEE-NAME
           DISPLAY "Base pay : " WS-BASE-SALARY
           DISPLAY "Bonus    : " WS-BONUS
           DISPLAY "Net pay  : " WS-NET-PAY.

      *> -------------------------------------------------------
      *> PRINT-SEPARATOR
      *> Prints a dashed line. Called multiple times by
      *> PERFORM ... TIMES to show repetition.
      *> -------------------------------------------------------
       PRINT-SEPARATOR.
           ADD 1 TO WS-LINE-COUNT
           DISPLAY "--- separator line " WS-LINE-COUNT
                   " ---".

      *> -------------------------------------------------------
      *> ACCUMULATE-STEP
      *> Adds the current counter to the running total,
      *> displays progress, and advances the counter.
      *> Called repeatedly by PERFORM UNTIL.
      *> -------------------------------------------------------
       ACCUMULATE-STEP.
           ADD WS-COUNTER TO WS-RUNNING-TOTAL
           DISPLAY "Step " WS-COUNTER
                   ": total is now " WS-RUNNING-TOTAL
           ADD 1 TO WS-COUNTER.
