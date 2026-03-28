      *> -------------------------------------------------------
      *> EX03 solution - Loan Screening
      *> Uses EVALUATE TRUE to keep ordered business rules clear.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. EX03-LOAN-SCREENING.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-APPLICANT-NAME    PIC X(20) VALUE SPACES.
       01 WS-MONTHLY-INCOME    PIC 9(5)  VALUE 0.
       01 WS-REQUEST-AMOUNT    PIC 9(6)  VALUE 0.
       01 WS-LATE-COUNT        PIC 9     VALUE 0.
       01 WS-INCOME-LIMIT      PIC 9(6)  VALUE 0.
       01 WS-DECISION          PIC X(7)  VALUE SPACES.
       01 WS-REASON            PIC X(30) VALUE SPACES.

       PROCEDURE DIVISION.
           DISPLAY "Enter applicant name:"
           ACCEPT WS-APPLICANT-NAME

           DISPLAY "Enter monthly income:"
           ACCEPT WS-MONTHLY-INCOME

           DISPLAY "Enter requested loan amount:"
           ACCEPT WS-REQUEST-AMOUNT

           DISPLAY "Enter late-payment count:"
           ACCEPT WS-LATE-COUNT

      *> The second rule compares the request with five months
      *> of income, so compute that threshold once.
           MULTIPLY WS-MONTHLY-INCOME BY 5
               GIVING WS-INCOME-LIMIT

           EVALUATE TRUE
               WHEN WS-LATE-COUNT > 2
                   MOVE "REJECT" TO WS-DECISION
                   MOVE "TOO MANY LATE PAYMENTS" TO WS-REASON
               WHEN WS-REQUEST-AMOUNT > WS-INCOME-LIMIT
                   MOVE "REVIEW" TO WS-DECISION
                   MOVE "REQUEST TOO LARGE" TO WS-REASON
               WHEN WS-MONTHLY-INCOME >= 2000
                   MOVE "APPROVE" TO WS-DECISION
                   MOVE "MEETS BASIC INCOME RULE" TO WS-REASON
               WHEN OTHER
                   MOVE "REVIEW" TO WS-DECISION
                   MOVE "INCOME BELOW APPROVAL RULE" TO WS-REASON
           END-EVALUATE

           DISPLAY " "
           DISPLAY "LOAN SCREENING RESULT"
           DISPLAY "Applicant: " WS-APPLICANT-NAME
           DISPLAY "Decision : " WS-DECISION
           DISPLAY "Reason   : " WS-REASON

           STOP RUN.
