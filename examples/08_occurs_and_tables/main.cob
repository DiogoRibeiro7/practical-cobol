      *> -------------------------------------------------------
      *> Lesson 08 - OCCURS and Tables
      *> Stores student records in a table, iterates with
      *> PERFORM VARYING, and computes totals and averages.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TABLE-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> -------------------------------------------------------
      *> A table of 5 student records.
      *> Each entry is a group with a name and a grade.
      *> OCCURS creates 5 copies of this group in memory.
      *> -------------------------------------------------------
       01 WS-CLASS-TABLE.
           05 WS-STUDENT OCCURS 5 TIMES.
               10 WS-STU-NAME   PIC X(15).
               10 WS-STU-GRADE  PIC 999.

      *> Loop counter for PERFORM VARYING.
       01 WS-IDX              PIC 9  VALUE 0.

      *> Accumulators and results.
       01 WS-TOTAL-GRADE      PIC 9(4) VALUE 0.
       01 WS-AVERAGE          PIC 999  VALUE 0.
       01 WS-PASS-COUNT       PIC 9    VALUE 0.
       01 WS-STUDENT-COUNT    PIC 9    VALUE 5.

      *> Display line for formatted output.
       01 WS-DETAIL-LINE.
           05 WS-DL-NUM       PIC 9.
           05 FILLER           PIC X(2) VALUE ". ".
           05 WS-DL-NAME      PIC X(15).
           05 FILLER           PIC X(2) VALUE "  ".
           05 WS-DL-GRADE     PIC ZZ9.
           05 FILLER           PIC X(2) VALUE "  ".
           05 WS-DL-STATUS    PIC X(6).

       PROCEDURE DIVISION.

      *> =====================================================
      *> STEP 1: Populate the table with student data.
      *> =====================================================
           PERFORM LOAD-STUDENTS

      *> =====================================================
      *> STEP 2: Display all students with pass/fail status.
      *> =====================================================
           DISPLAY "==========================================="
           DISPLAY " CLASS GRADE REPORT"
           DISPLAY "==========================================="
           DISPLAY " "
           DISPLAY "#  Name             Grade  Status"
           DISPLAY "-------------------------------------------"

           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > WS-STUDENT-COUNT
               PERFORM DISPLAY-STUDENT
           END-PERFORM

      *> =====================================================
      *> STEP 3: Compute and display summary statistics.
      *> =====================================================
           DISPLAY "-------------------------------------------"

           DIVIDE WS-TOTAL-GRADE BY WS-STUDENT-COUNT
               GIVING WS-AVERAGE

           DISPLAY " "
           DISPLAY "Total grades : " WS-TOTAL-GRADE
           DISPLAY "Average grade: " WS-AVERAGE
           DISPLAY "Students who passed (>= 50): " WS-PASS-COUNT
           DISPLAY " of " WS-STUDENT-COUNT

           STOP RUN.

      *> -------------------------------------------------------
      *> LOAD-STUDENTS
      *> Populates each table entry with a name and grade.
      *> In a real program, this data would come from a file.
      *> -------------------------------------------------------
       LOAD-STUDENTS.
           MOVE "ALICE JOHNSON" TO WS-STU-NAME(1)
           MOVE 082             TO WS-STU-GRADE(1)

           MOVE "BOB MARTINEZ"  TO WS-STU-NAME(2)
           MOVE 045             TO WS-STU-GRADE(2)

           MOVE "CAROL DAVIS"   TO WS-STU-NAME(3)
           MOVE 091             TO WS-STU-GRADE(3)

           MOVE "DAVID CHEN"    TO WS-STU-NAME(4)
           MOVE 067             TO WS-STU-GRADE(4)

           MOVE "EVA KOWALSKI"  TO WS-STU-NAME(5)
           MOVE 038             TO WS-STU-GRADE(5).

      *> -------------------------------------------------------
      *> DISPLAY-STUDENT
      *> Formats and displays one student row.
      *> Also accumulates the total and counts passes.
      *> -------------------------------------------------------
       DISPLAY-STUDENT.
      *> Build the display line.
           MOVE WS-IDX              TO WS-DL-NUM
           MOVE WS-STU-NAME(WS-IDX) TO WS-DL-NAME
           MOVE WS-STU-GRADE(WS-IDX) TO WS-DL-GRADE

      *> Determine pass or fail.
           IF WS-STU-GRADE(WS-IDX) >= 50
               MOVE "PASS" TO WS-DL-STATUS
               ADD 1 TO WS-PASS-COUNT
           ELSE
               MOVE "FAIL" TO WS-DL-STATUS
           END-IF

      *> Display the formatted line and accumulate.
           DISPLAY WS-DETAIL-LINE
           ADD WS-STU-GRADE(WS-IDX) TO WS-TOTAL-GRADE.
