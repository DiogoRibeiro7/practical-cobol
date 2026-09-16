      *> =============================================================
      *> LESSON 16 - INDEXED FILES AND DIRECT KEYED LOOKUP
      *> =============================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INDEXED-CUSTOMER-MASTER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTOMER-FILE
               ASSIGN TO "data/customer-master.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS CUSTOMER-ID
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD CUSTOMER-FILE.
       01 CUSTOMER-RECORD.
           05 CUSTOMER-ID           PIC X(5).
           05 CUSTOMER-NAME         PIC X(20).
           05 CUSTOMER-STATUS       PIC X.
           05 CUSTOMER-BALANCE      PIC S9(7)V99.

       WORKING-STORAGE SECTION.
       01 WS-FILE-STATUS            PIC XX VALUE SPACES.
       01 WS-BALANCE-DISPLAY        PIC -ZZ,ZZ9.99.

       PROCEDURE DIVISION.
           PERFORM BUILD-CUSTOMER-MASTER
           PERFORM LOOKUP-EXISTING-CUSTOMER
           PERFORM LOOKUP-MISSING-CUSTOMER
           STOP RUN.

       BUILD-CUSTOMER-MASTER.
           OPEN OUTPUT CUSTOMER-FILE
           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "OPEN OUTPUT FAILED STATUS=" WS-FILE-STATUS
               STOP RUN
           END-IF

           MOVE "C0001" TO CUSTOMER-ID
           MOVE "ANA COSTA" TO CUSTOMER-NAME
           MOVE "A" TO CUSTOMER-STATUS
           MOVE 1250.75 TO CUSTOMER-BALANCE
           WRITE CUSTOMER-RECORD

           MOVE "C0002" TO CUSTOMER-ID
           MOVE "BRUNO SILVA" TO CUSTOMER-NAME
           MOVE "A" TO CUSTOMER-STATUS
           MOVE 875.25 TO CUSTOMER-BALANCE
           WRITE CUSTOMER-RECORD

           MOVE "C0003" TO CUSTOMER-ID
           MOVE "CARLA SOUSA" TO CUSTOMER-NAME
           MOVE "I" TO CUSTOMER-STATUS
           MOVE 40.00 TO CUSTOMER-BALANCE
           WRITE CUSTOMER-RECORD

           CLOSE CUSTOMER-FILE
           DISPLAY "Indexed customer master created: 03 records".

       LOOKUP-EXISTING-CUSTOMER.
           OPEN INPUT CUSTOMER-FILE
           MOVE "C0002" TO CUSTOMER-ID

           READ CUSTOMER-FILE KEY IS CUSTOMER-ID
               INVALID KEY
                   DISPLAY "Customer C0002 not found"
               NOT INVALID KEY
                   MOVE CUSTOMER-BALANCE TO WS-BALANCE-DISPLAY
                   DISPLAY "Lookup C0002: " CUSTOMER-NAME
                           " status=" CUSTOMER-STATUS
                           " balance=" WS-BALANCE-DISPLAY
           END-READ

           CLOSE CUSTOMER-FILE.

       LOOKUP-MISSING-CUSTOMER.
           OPEN INPUT CUSTOMER-FILE
           MOVE "C9999" TO CUSTOMER-ID

           READ CUSTOMER-FILE KEY IS CUSTOMER-ID
               INVALID KEY
                   DISPLAY "Lookup C9999: not found, file status="
                           WS-FILE-STATUS
               NOT INVALID KEY
                   DISPLAY "Unexpected record found for C9999"
           END-READ

           CLOSE CUSTOMER-FILE.
