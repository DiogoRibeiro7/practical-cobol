      *> =============================================================
      *> LESSON 17 - RELATIVE FILES AND RECORD SLOTS
      *> =============================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. RELATIVE-CUSTOMER-SLOTS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-SLOT-FILE
               ASSIGN TO "data/customer-slots.dat"
               ORGANIZATION IS RELATIVE
               ACCESS MODE IS DYNAMIC
               RELATIVE KEY IS WS-RELATIVE-KEY
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD CUSTOMER-SLOT-FILE.
       01 CUSTOMER-SLOT-RECORD.
           05 CUSTOMER-ID             PIC X(6).
           05 CUSTOMER-NAME           PIC X(20).
           05 CUSTOMER-STATUS         PIC X.

       WORKING-STORAGE SECTION.
       01 WS-FILE-STATUS              PIC XX VALUE SPACES.
       01 WS-RELATIVE-KEY             PIC 9(4) VALUE 0.

       PROCEDURE DIVISION.
           PERFORM BUILD-RELATIVE-FILE
           PERFORM DEMONSTRATE-DIRECT-READS
           STOP RUN.

       BUILD-RELATIVE-FILE.
           OPEN OUTPUT CUSTOMER-SLOT-FILE

           MOVE 1 TO WS-RELATIVE-KEY
           MOVE "C00001" TO CUSTOMER-ID
           MOVE "ANA MARTINS" TO CUSTOMER-NAME
           MOVE "A" TO CUSTOMER-STATUS
           WRITE CUSTOMER-SLOT-RECORD

           MOVE 3 TO WS-RELATIVE-KEY
           MOVE "C00003" TO CUSTOMER-ID
           MOVE "BRUNO SILVA" TO CUSTOMER-NAME
           MOVE "A" TO CUSTOMER-STATUS
           WRITE CUSTOMER-SLOT-RECORD

           MOVE 5 TO WS-RELATIVE-KEY
           MOVE "C00005" TO CUSTOMER-ID
           MOVE "CARLA SOUSA" TO CUSTOMER-NAME
           MOVE "I" TO CUSTOMER-STATUS
           WRITE CUSTOMER-SLOT-RECORD

           CLOSE CUSTOMER-SLOT-FILE.

       DEMONSTRATE-DIRECT-READS.
           OPEN INPUT CUSTOMER-SLOT-FILE

           DISPLAY "RELATIVE CUSTOMER FILE"
           DISPLAY "========================================"

           MOVE 3 TO WS-RELATIVE-KEY
           READ CUSTOMER-SLOT-FILE
               INVALID KEY
                   DISPLAY "RRN 0003 -> NOT FOUND, STATUS "
                           WS-FILE-STATUS
               NOT INVALID KEY
                   DISPLAY "RRN 0003 -> " CUSTOMER-ID " "
                           CUSTOMER-NAME " STATUS=" CUSTOMER-STATUS
                           " FILE-STATUS=" WS-FILE-STATUS
           END-READ

           MOVE 2 TO WS-RELATIVE-KEY
           READ CUSTOMER-SLOT-FILE
               INVALID KEY
                   DISPLAY "RRN 0002 -> EMPTY SLOT, FILE-STATUS="
                           WS-FILE-STATUS
               NOT INVALID KEY
                   DISPLAY "RRN 0002 -> " CUSTOMER-ID " "
                           CUSTOMER-NAME
           END-READ

           MOVE 5 TO WS-RELATIVE-KEY
           READ CUSTOMER-SLOT-FILE
               INVALID KEY
                   DISPLAY "RRN 0005 -> NOT FOUND, STATUS "
                           WS-FILE-STATUS
               NOT INVALID KEY
                   DISPLAY "RRN 0005 -> " CUSTOMER-ID " "
                           CUSTOMER-NAME " STATUS=" CUSTOMER-STATUS
                           " FILE-STATUS=" WS-FILE-STATUS
           END-READ

           DISPLAY "========================================"

           CLOSE CUSTOMER-SLOT-FILE.
