      *> -------------------------------------------------------
      *> Lesson 13 - Sort and Merge Processing
      *> Demonstrates COBOL SORT and MERGE verbs with sequential files.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SORT-MERGE-EXAMPLE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SORT-IN-FILE
               ASSIGN TO "data/sort_input.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT MERGE-A-FILE
               ASSIGN TO "data/merge_a.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT MERGE-B-FILE
               ASSIGN TO "data/merge_b.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT SORT-OUT-FILE
               ASSIGN TO "data/sorted_output.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT MERGE-OUT-FILE
               ASSIGN TO "data/merged_output.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT SORT-FILE
               ASSIGN TO "SORT-TEMP"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT MERGE-FILE
               ASSIGN TO "MERGE-TEMP"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD SORT-IN-FILE.
       01 SORT-IN-REC.
           05 SORT-ID     PIC 9(3).
           05 SORT-NAME   PIC X(20).

       FD MERGE-A-FILE.
       01 MERGE-A-REC.
           05 MERGE-ID    PIC 9(3).
           05 MERGE-NAME  PIC X(20).

       FD MERGE-B-FILE.
       01 MERGE-B-REC.
           05 MERGE-B-ID  PIC 9(3).
           05 MERGE-B-NAME PIC X(20).

       FD SORT-OUT-FILE.
       01 SORT-OUT-REC.
           05 SORT-OUT-ID   PIC 9(3).
           05 SORT-OUT-NAME PIC X(20).

       FD MERGE-OUT-FILE.
       01 MERGE-OUT-REC.
           05 MERGE-OUT-ID   PIC 9(3).
           05 MERGE-OUT-NAME PIC X(20).

       FD SORT-FILE.
       01 SORT-REC.
           05 SORT-FILE-ID   PIC 9(3).
           05 SORT-FILE-NAME PIC X(20).

       FD MERGE-FILE.
       01 MERGE-REC.
           05 MERGE-FILE-ID   PIC 9(3).
           05 MERGE-FILE-NAME PIC X(20).

       WORKING-STORAGE SECTION.

       01 WS-EOF.
           05 WS-EOF-SORT       PIC X VALUE "N".
           05 WS-EOF-MERGE-A    PIC X VALUE "N".
           05 WS-EOF-MERGE-B    PIC X VALUE "N".
           05 WS-EOF-SORT-OUT   PIC X VALUE "N".
           05 WS-EOF-MERGE-OUT  PIC X VALUE "N".

       PROCEDURE DIVISION.
           PERFORM SORT-PROCESS
           PERFORM MERGE-PROCESS
           STOP RUN.

       SORT-PROCESS.
           SORT SORT-FILE
               ON ASCENDING KEY SORT-FILE-ID
               INPUT PROCEDURE IS SORT-INPUT
               OUTPUT PROCEDURE IS SORT-OUTPUT.

       SORT-INPUT.
           OPEN INPUT SORT-IN-FILE
           PERFORM UNTIL WS-EOF-SORT = "Y"
               READ SORT-IN-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-SORT
                   NOT AT END
                       MOVE SORT-IN-REC TO SORT-REC
                       RELEASE SORT-REC
               END-READ
           END-PERFORM
           CLOSE SORT-IN-FILE.

       SORT-OUTPUT.
           OPEN OUTPUT SORT-OUT-FILE
           PERFORM UNTIL WS-EOF-SORT-OUT = "Y"
               RETURN SORT-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-SORT-OUT
                   NOT AT END
                       MOVE SORT-REC TO SORT-OUT-REC
                       WRITE SORT-OUT-REC
               END-RETURN
           END-PERFORM
           CLOSE SORT-OUT-FILE
           DISPLAY "SORT complete: data/sorted_output.dat".

       MERGE-PROCESS.
           MERGE MERGE-FILE
               ON ASCENDING KEY MERGE-FILE-ID
               INPUT PROCEDURE IS MERGE-INPUT
               OUTPUT PROCEDURE IS MERGE-OUTPUT.

       MERGE-INPUT.
           OPEN INPUT MERGE-A-FILE MERGE-B-FILE
           PERFORM UNTIL WS-EOF-MERGE-A = "Y" AND WS-EOF-MERGE-B = "Y"
               IF WS-EOF-MERGE-A = "N"
                   READ MERGE-A-FILE
                       AT END
                           MOVE "Y" TO WS-EOF-MERGE-A
                       NOT AT END
                           MOVE MERGE-A-REC TO MERGE-REC
                           RELEASE MERGE-REC
                   END-READ
               END-IF
               IF WS-EOF-MERGE-B = "N"
                   READ MERGE-B-FILE
                       AT END
                           MOVE "Y" TO WS-EOF-MERGE-B
                       NOT AT END
                           MOVE MERGE-B-REC TO MERGE-REC
                           RELEASE MERGE-REC
                   END-READ
               END-IF
           END-PERFORM
           CLOSE MERGE-A-FILE MERGE-B-FILE.

       MERGE-OUTPUT.
           OPEN OUTPUT MERGE-OUT-FILE
           PERFORM UNTIL WS-EOF-MERGE-OUT = "Y"
               RETURN MERGE-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-MERGE-OUT
                   NOT AT END
                       MOVE MERGE-REC TO MERGE-OUT-REC
                       WRITE MERGE-OUT-REC
               END-RETURN
           END-PERFORM
           CLOSE MERGE-OUT-FILE
           DISPLAY "MERGE complete: data/merged_output.dat".
