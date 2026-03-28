       IDENTIFICATION DIVISION.
       PROGRAM-ID. STUDENT-PASS-COUNT.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT STUDENT-FILE ASSIGN TO "students.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD STUDENT-FILE.
       01 STUDENT-RECORD.
           05 SR-NAME        PIC X(10).
           05 SR-GRADE       PIC 99.

       WORKING-STORAGE SECTION.
       01 WS-END            PIC X VALUE "N".
       01 WS-PASS-COUNT     PIC 9(4) VALUE 0.

       PROCEDURE DIVISION.
           OPEN INPUT STUDENT-FILE
           PERFORM UNTIL WS-END = "Y"
               READ STUDENT-FILE
                   AT END
                       MOVE "Y" TO WS-END
                   NOT AT END
                       IF SR-GRADE >= 10
                           ADD 1 TO WS-PASS-COUNT
                       END-IF
               END-READ
           END-PERFORM
           CLOSE STUDENT-FILE
           DISPLAY "Passed students: " WS-PASS-COUNT
           STOP RUN.
