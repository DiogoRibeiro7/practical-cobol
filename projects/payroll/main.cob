      *> =============================================================
      *> PAYROLL PROCESSOR
      *> Reads employee records from a data file, computes gross pay
      *> (with overtime at 1.5x for hours above 40), calculates
      *> a 15% flat tax, and produces a formatted payroll report.
      *>
      *> This project combines concepts from lessons 01 through 11:
      *>   - Variables and PIC clauses (lesson 02)
      *>   - Arithmetic with COMPUTE (lesson 04)
      *>   - Conditionals with IF (lesson 05)
      *>   - Paragraph-based structure (lesson 06)
      *>   - Formatted output with edited PIC and groups (lesson 07)
      *>   - Sequential file reading (lesson 09)
      *>   - Accumulators and report totals (lesson 11)
      *> =============================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYROLL-PROCESSOR.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMPLOYEE-FILE
               ASSIGN TO "data/employees.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

      *> =============================================================
      *> FILE SECTION — input record layout (36 chars per line)
      *> =============================================================
       FILE SECTION.
       FD EMPLOYEE-FILE.
       01 EMP-RECORD.
           05 EMP-ID           PIC X(5).
           05 EMP-NAME         PIC X(20).
           05 EMP-DEPT         PIC X(4).
           05 EMP-HOURS        PIC 99V9.
           05 EMP-RATE         PIC 99V99.

      *> =============================================================
      *> WORKING-STORAGE SECTION
      *> =============================================================
       WORKING-STORAGE SECTION.

      *> --- End-of-file flag ---
       01 WS-EOF               PIC X VALUE "N".

      *> --- Overtime threshold ---
       01 WS-OT-THRESHOLD      PIC 99V9 VALUE 40.0.

      *> --- Per-employee calculation fields ---
       01 WS-REGULAR-HOURS     PIC 99V9    VALUE 0.
       01 WS-OT-HOURS          PIC 99V9    VALUE 0.
       01 WS-REGULAR-PAY       PIC 9(5)V99 VALUE 0.
       01 WS-OT-PAY            PIC 9(5)V99 VALUE 0.
       01 WS-GROSS             PIC 9(5)V99 VALUE 0.
       01 WS-TAX               PIC 9(5)V99 VALUE 0.
       01 WS-NET               PIC 9(5)V99 VALUE 0.

      *> --- Report accumulators ---
       01 WS-TOTAL-GROSS       PIC 9(7)V99 VALUE 0.
       01 WS-TOTAL-TAX         PIC 9(7)V99 VALUE 0.
       01 WS-TOTAL-NET         PIC 9(7)V99 VALUE 0.
       01 WS-EMP-COUNT         PIC 99      VALUE 0.
       01 WS-OT-COUNT          PIC 99      VALUE 0.

      *> --- Edited display fields (per-employee) ---
       01 WS-HOURS-DISP        PIC Z9.9.
       01 WS-GROSS-DISP        PIC Z,ZZ9.99.
       01 WS-TAX-DISP          PIC Z,ZZ9.99.
       01 WS-NET-DISP          PIC Z,ZZ9.99.
       01 WS-OT-HOURS-DISP     PIC Z9.9.

      *> --- Edited display fields (totals) ---
       01 WS-TOTAL-GROSS-DISP  PIC ZZ,ZZ9.99.
       01 WS-TOTAL-TAX-DISP    PIC ZZ,ZZ9.99.
       01 WS-TOTAL-NET-DISP    PIC ZZ,ZZ9.99.

      *> --- Detail line layout ---
      *> This group-level item formats one employee row.
       01 WS-DETAIL-LINE.
           05 WS-DL-ID         PIC X(5).
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-NAME       PIC X(20).
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-DEPT       PIC X(4).
           05 FILLER            PIC X(2) VALUE "  ".
           05 WS-DL-HOURS      PIC Z9.9.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-GROSS      PIC Z,ZZ9.99.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-TAX        PIC Z,ZZ9.99.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-DL-NET        PIC Z,ZZ9.99.

      *> --- Totals line layout ---
       01 WS-TOTALS-LINE.
           05 FILLER            PIC X(34) VALUE
              "TOTALS                            ".
           05 WS-TL-GROSS      PIC ZZ,ZZ9.99.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-TL-TAX        PIC ZZ,ZZ9.99.
           05 FILLER            PIC X(1) VALUE " ".
           05 WS-TL-NET        PIC ZZ,ZZ9.99.

      *> =============================================================
      *> PROCEDURE DIVISION — main flow
      *> =============================================================
       PROCEDURE DIVISION.
           PERFORM PRINT-REPORT-HEADER
           PERFORM READ-ALL-EMPLOYEES
           PERFORM PRINT-REPORT-FOOTER

           STOP RUN.

      *> -------------------------------------------------------------
      *> PRINT-REPORT-HEADER
      *> Displays the report title and column headings.
      *> -------------------------------------------------------------
       PRINT-REPORT-HEADER.
           DISPLAY "============================================"
                   "======================"
           DISPLAY "                     PAYROLL REPORT"
           DISPLAY "============================================"
                   "======================"
           DISPLAY " "
           DISPLAY "ID    Name                  Dept"
                   "  Hours    Gross       Tax   Net Pay"
           DISPLAY "--------------------------------------------"
                   "----------------------".

      *> -------------------------------------------------------------
      *> READ-ALL-EMPLOYEES
      *> Opens the file and loops through every record.
      *> -------------------------------------------------------------
       READ-ALL-EMPLOYEES.
           OPEN INPUT EMPLOYEE-FILE

           PERFORM UNTIL WS-EOF = "Y"
               READ EMPLOYEE-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESS-EMPLOYEE
               END-READ
           END-PERFORM

           CLOSE EMPLOYEE-FILE.

      *> -------------------------------------------------------------
      *> PROCESS-EMPLOYEE
      *> Computes pay for one employee and displays the detail line.
      *>
      *> Business rules:
      *>   - Regular pay: hours (up to 40) * hourly rate
      *>   - Overtime pay: hours above 40 * hourly rate * 1.5
      *>   - Gross pay: regular pay + overtime pay
      *>   - Tax: 15% of gross pay (flat rate)
      *>   - Net pay: gross pay - tax
      *> -------------------------------------------------------------
       PROCESS-EMPLOYEE.
           ADD 1 TO WS-EMP-COUNT

      *> --- Compute regular and overtime hours ---
           IF EMP-HOURS > WS-OT-THRESHOLD
               COMPUTE WS-REGULAR-HOURS = WS-OT-THRESHOLD
               COMPUTE WS-OT-HOURS =
                   EMP-HOURS - WS-OT-THRESHOLD
               ADD 1 TO WS-OT-COUNT
           ELSE
               MOVE EMP-HOURS TO WS-REGULAR-HOURS
               MOVE 0 TO WS-OT-HOURS
           END-IF

      *> --- Compute pay amounts ---
           COMPUTE WS-REGULAR-PAY =
               WS-REGULAR-HOURS * EMP-RATE
           COMPUTE WS-OT-PAY =
               WS-OT-HOURS * EMP-RATE * 1.5
           COMPUTE WS-GROSS =
               WS-REGULAR-PAY + WS-OT-PAY
           COMPUTE WS-TAX =
               WS-GROSS * 0.15
           COMPUTE WS-NET =
               WS-GROSS - WS-TAX

      *> --- Build the detail line ---
           MOVE EMP-ID    TO WS-DL-ID
           MOVE EMP-NAME  TO WS-DL-NAME
           MOVE EMP-DEPT  TO WS-DL-DEPT
           MOVE EMP-HOURS TO WS-DL-HOURS
           MOVE WS-GROSS  TO WS-DL-GROSS
           MOVE WS-TAX    TO WS-DL-TAX
           MOVE WS-NET    TO WS-DL-NET

           DISPLAY WS-DETAIL-LINE

      *> --- Show overtime note if applicable ---
           IF WS-OT-HOURS > 0
               MOVE WS-OT-HOURS TO WS-OT-HOURS-DISP
               DISPLAY "       ("
                       WS-OT-HOURS-DISP
                       " overtime hours at 1.5x rate)"
           END-IF

      *> --- Accumulate totals ---
           ADD WS-GROSS TO WS-TOTAL-GROSS
           ADD WS-TAX   TO WS-TOTAL-TAX
           ADD WS-NET   TO WS-TOTAL-NET.

      *> -------------------------------------------------------------
      *> PRINT-REPORT-FOOTER
      *> Displays the separator, totals, and employee counts.
      *> -------------------------------------------------------------
       PRINT-REPORT-FOOTER.
           DISPLAY "--------------------------------------------"
                   "----------------------"

      *> --- Format and display totals ---
           MOVE WS-TOTAL-GROSS TO WS-TL-GROSS
           MOVE WS-TOTAL-TAX   TO WS-TL-TAX
           MOVE WS-TOTAL-NET   TO WS-TL-NET
           DISPLAY WS-TOTALS-LINE

           DISPLAY " "
           DISPLAY "Employees processed: " WS-EMP-COUNT
           DISPLAY "Overtime employees : " WS-OT-COUNT
           DISPLAY "============================================"
                   "======================".
