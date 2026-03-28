      *> -------------------------------------------------------
      *> Lesson 10 - Writing a Sequential File
      *> Reads employee records, computes a 10% bonus,
      *> and writes the results to an output file.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BONUS-WRITER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *> Input file: employee names and salaries.
           SELECT EMPLOYEE-FILE ASSIGN TO "data/employees.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
      *> Output file: payroll with bonus calculations.
           SELECT BONUS-FILE ASSIGN TO "data/bonuses.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

      *> -------------------------------------------------------
      *> FILE SECTION — one FD per file.
      *> -------------------------------------------------------
       FILE SECTION.

      *> Input record: 15-char name + 5-digit salary = 20 chars.
       FD EMPLOYEE-FILE.
       01 EMP-RECORD.
           05 EMP-NAME         PIC X(15).
           05 EMP-SALARY       PIC 9(5).

      *> Output record: name + salary + bonus + net pay.
       FD BONUS-FILE.
       01 BONUS-RECORD.
           05 BR-NAME          PIC X(15).
           05 FILLER           PIC X(1) VALUE " ".
           05 BR-SALARY        PIC 9(5).
           05 FILLER           PIC X(1) VALUE " ".
           05 BR-BONUS         PIC 9(5).
           05 FILLER           PIC X(1) VALUE " ".
           05 BR-NET-PAY       PIC 9(5).

       WORKING-STORAGE SECTION.
       01 WS-EOF              PIC X     VALUE "N".
       01 WS-BONUS            PIC 9(5)  VALUE 0.
       01 WS-NET-PAY          PIC 9(5)  VALUE 0.
       01 WS-RECORD-COUNT     PIC 99    VALUE 0.
       01 WS-TOTAL-PAID       PIC 9(6)  VALUE 0.

       PROCEDURE DIVISION.
           OPEN INPUT  EMPLOYEE-FILE
           OPEN OUTPUT BONUS-FILE

           PERFORM UNTIL WS-EOF = "Y"
               READ EMPLOYEE-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESS-EMPLOYEE
               END-READ
           END-PERFORM

           CLOSE EMPLOYEE-FILE
           CLOSE BONUS-FILE

           DISPLAY "Records written: " WS-RECORD-COUNT
           DISPLAY "Total paid out : " WS-TOTAL-PAID
           DISPLAY " "
           DISPLAY "Output saved to data/bonuses.dat"

           STOP RUN.

      *> -------------------------------------------------------
      *> PROCESS-EMPLOYEE
      *> Computes a 10% bonus, builds the output record,
      *> and writes it to the bonus file.
      *> -------------------------------------------------------
       PROCESS-EMPLOYEE.
      *> Calculate bonus (10% of salary).
           MULTIPLY EMP-SALARY BY 10
               GIVING WS-BONUS
           DIVIDE WS-BONUS BY 100
               GIVING WS-BONUS
           ADD EMP-SALARY TO WS-BONUS
               GIVING WS-NET-PAY

      *> Populate the output record.
           MOVE EMP-NAME    TO BR-NAME
           MOVE EMP-SALARY  TO BR-SALARY
           MOVE WS-BONUS    TO BR-BONUS
           MOVE WS-NET-PAY  TO BR-NET-PAY

      *> Write one line to the output file.
           WRITE BONUS-RECORD

      *> Display progress and accumulate.
           DISPLAY EMP-NAME " | "
                   EMP-SALARY " | "
                   WS-BONUS " | "
                   WS-NET-PAY
           ADD 1 TO WS-RECORD-COUNT
           ADD WS-NET-PAY TO WS-TOTAL-PAID.
