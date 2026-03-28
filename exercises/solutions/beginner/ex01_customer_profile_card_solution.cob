      *> -------------------------------------------------------
      *> EX01 solution - Customer Profile Card
      *> Demonstrates fixed-width text and numeric input.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. EX01-CUSTOMER-PROFILE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-CUSTOMER-NAME     PIC X(20) VALUE SPACES.
       01 WS-CITY              PIC X(15) VALUE SPACES.
       01 WS-TIER-CODE         PIC X(6)  VALUE SPACES.
       01 WS-YEARS             PIC 99    VALUE 0.

       PROCEDURE DIVISION.
           DISPLAY "Enter customer name:"
           ACCEPT WS-CUSTOMER-NAME

           DISPLAY "Enter city:"
           ACCEPT WS-CITY

           DISPLAY "Enter tier code:"
           ACCEPT WS-TIER-CODE

           DISPLAY "Enter years as a customer:"
           ACCEPT WS-YEARS

           DISPLAY " "
           DISPLAY "CUSTOMER PROFILE"
           DISPLAY "Name : " WS-CUSTOMER-NAME
           DISPLAY "City : " WS-CITY
           DISPLAY "Tier : " WS-TIER-CODE
           DISPLAY "Years: " WS-YEARS

           STOP RUN.
