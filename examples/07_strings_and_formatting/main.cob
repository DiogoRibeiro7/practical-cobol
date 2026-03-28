      *> -------------------------------------------------------
      *> Lesson 07 - Strings, Formatting, and Report Output
      *> Demonstrates aligned labels, edited PIC clauses,
      *> group-level display lines, and receipt-style output.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. FORMAT-DEMO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> -------------------------------------------------------
      *> Part 1: Customer summary fields
      *> -------------------------------------------------------
       01 WS-ACCOUNT-NO       PIC 9(8)  VALUE 10045782.
       01 WS-CUSTOMER-NAME    PIC X(20) VALUE "ANA SILVA".
       01 WS-STATUS           PIC X(10) VALUE "ACTIVE".
       01 WS-BALANCE          PIC 9(5)V99 VALUE 152340.
       01 WS-BALANCE-DISP     PIC $Z,ZZ9.99.

      *> -------------------------------------------------------
      *> Part 2: Receipt detail line layout
      *> A group-level item defines one output line.
      *> Each 05-level field occupies a fixed column position.
      *> -------------------------------------------------------
       01 WS-DETAIL-LINE.
           05 WS-DL-ITEM      PIC X(22).
           05 WS-DL-QTY       PIC Z9.
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-PRICE     PIC ZZ9.99.
           05 FILLER           PIC X(3) VALUE "   ".
           05 WS-DL-AMOUNT    PIC Z,ZZ9.99.

      *> Working fields for line calculations
       01 WS-ITEM-NAME        PIC X(22).
       01 WS-QTY              PIC 99    VALUE 0.
       01 WS-PRICE            PIC 999V99 VALUE 0.
       01 WS-LINE-AMT         PIC 9(5)V99 VALUE 0.

      *> -------------------------------------------------------
      *> Part 3: Totals
      *> -------------------------------------------------------
       01 WS-SUBTOTAL         PIC 9(5)V99 VALUE 0.
       01 WS-TAX              PIC 9(5)V99 VALUE 0.
       01 WS-GRAND-TOTAL      PIC 9(5)V99 VALUE 0.

       01 WS-SUBTOTAL-DISP    PIC Z,ZZ9.99.
       01 WS-TAX-DISP         PIC Z,ZZ9.99.
       01 WS-TOTAL-DISP       PIC Z,ZZ9.99.

       PROCEDURE DIVISION.

      *> =====================================================
      *> PART 1: Customer summary with aligned labels
      *> =====================================================
           DISPLAY "============================================"
           DISPLAY "       CUSTOMER ACCOUNT SUMMARY"
           DISPLAY "============================================"
           DISPLAY " "
           DISPLAY "Account : " WS-ACCOUNT-NO
           DISPLAY "Name    : " WS-CUSTOMER-NAME
           DISPLAY "Status  : " WS-STATUS

           MOVE WS-BALANCE TO WS-BALANCE-DISP
           DISPLAY "Balance : " WS-BALANCE-DISP

      *> =====================================================
      *> PART 2: Receipt with columnar detail lines
      *> =====================================================
           DISPLAY " "
           DISPLAY "============================================"
           DISPLAY "       PURCHASE RECEIPT"
           DISPLAY "============================================"
           DISPLAY " "
           DISPLAY "Item                  Qty   Price"
                   "     Amount"
           DISPLAY "--------------------------------------------"

      *> --- Line 1: Office Supplies ---
           MOVE "Office Supplies"  TO WS-ITEM-NAME
           MOVE 3                  TO WS-QTY
           MOVE 12.50              TO WS-PRICE
           PERFORM FORMAT-AND-PRINT-LINE

      *> --- Line 2: Printer Paper ---
           MOVE "Printer Paper"    TO WS-ITEM-NAME
           MOVE 10                 TO WS-QTY
           MOVE 8.75               TO WS-PRICE
           PERFORM FORMAT-AND-PRINT-LINE

      *> --- Line 3: Toner Cartridge ---
           MOVE "Toner Cartridge"  TO WS-ITEM-NAME
           MOVE 2                  TO WS-QTY
           MOVE 45.00              TO WS-PRICE
           PERFORM FORMAT-AND-PRINT-LINE

      *> =====================================================
      *> PART 3: Totals with formatted currency
      *> =====================================================
           DISPLAY "--------------------------------------------"

           MOVE WS-SUBTOTAL TO WS-SUBTOTAL-DISP
           DISPLAY "                         Subtotal: "
                   WS-SUBTOTAL-DISP

      *> Calculate 8% tax
           MULTIPLY WS-SUBTOTAL BY 0.08
               GIVING WS-TAX
           MOVE WS-TAX TO WS-TAX-DISP
           DISPLAY "                         Tax (8%): "
                   WS-TAX-DISP

           ADD WS-SUBTOTAL TO WS-TAX
               GIVING WS-GRAND-TOTAL
           MOVE WS-GRAND-TOTAL TO WS-TOTAL-DISP
           DISPLAY "                         TOTAL  : "
                   WS-TOTAL-DISP

           DISPLAY " "
           DISPLAY "Thank you for your purchase!"

           STOP RUN.

      *> -------------------------------------------------------
      *> FORMAT-AND-PRINT-LINE
      *> Computes the line amount, populates the group-level
      *> detail line, displays it, and adds to the subtotal.
      *> -------------------------------------------------------
       FORMAT-AND-PRINT-LINE.
           MULTIPLY WS-QTY BY WS-PRICE
               GIVING WS-LINE-AMT
           MOVE WS-ITEM-NAME  TO WS-DL-ITEM
           MOVE WS-QTY        TO WS-DL-QTY
           MOVE WS-PRICE      TO WS-DL-PRICE
           MOVE WS-LINE-AMT   TO WS-DL-AMOUNT
           DISPLAY WS-DETAIL-LINE
           ADD WS-LINE-AMT TO WS-SUBTOTAL.
