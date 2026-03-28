# 09 - Sequential Files

## Objective

Learn how to read records from a sequential file, process them one at a time, and accumulate totals -- the fundamental pattern behind COBOL batch processing.

## Concepts covered

- `ENVIRONMENT DIVISION` and the `FILE-CONTROL` paragraph
- `SELECT ... ASSIGN TO` for binding a logical file name to a physical file
- `ORGANIZATION IS LINE SEQUENTIAL` for text-based record files
- `FILE SECTION` and the `FD` (File Description) entry
- Group-level record layout with subordinate fields
- `OPEN INPUT`, `READ`, and `CLOSE` as the file I/O lifecycle
- `AT END` / `NOT AT END` clauses for detecting end-of-file
- `PERFORM UNTIL` for looping until a condition is met
- End-of-file flag pattern using a working-storage switch

## Data file

The program reads `data/sales.dat`. Each line is a fixed-length record of 10 characters with no delimiters:

```text
P100100050
P200300125
P300200250
P400150075
```

The layout is:

| Positions | Length | Field        | PIC     | Example | Meaning         |
|-----------|--------|--------------|---------|---------|-----------------|
| 1-4       | 4      | Product code | X(4)    | P100    | Product ID      |
| 5-6       | 2      | Quantity     | 99      | 10      | Units sold      |
| 7-10      | 4      | Unit price   | 9(4)    | 0050    | Price per unit  |

For example, the first line `P100100050` means: product P100, quantity 10, unit price 50. The line total is 10 x 50 = 500. In this teaching example the unit price is stored as a whole number to keep the first file lesson simple.

## Code

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SALES-REPORT.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALES-FILE ASSIGN TO "data/sales.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD SALES-FILE.
       01 SALES-RECORD.
           05 SR-PRODUCT-CODE    PIC X(4).
           05 SR-QUANTITY        PIC 99.
           05 SR-UNIT-PRICE      PIC 9(4).

       WORKING-STORAGE SECTION.
       01 WS-END-OF-FILE         PIC X VALUE "N".
       01 WS-LINE-TOTAL          PIC 9(6) VALUE 0.
       01 WS-GRAND-TOTAL         PIC 9(8) VALUE 0.
       01 WS-RECORD-COUNT        PIC 9(4) VALUE 0.

       PROCEDURE DIVISION.
           OPEN INPUT SALES-FILE
           PERFORM UNTIL WS-END-OF-FILE = "Y"
               READ SALES-FILE
                   AT END
                       MOVE "Y" TO WS-END-OF-FILE
                   NOT AT END
                       PERFORM PROCESS-RECORD
               END-READ
           END-PERFORM
           CLOSE SALES-FILE

           DISPLAY "Records read : " WS-RECORD-COUNT
           DISPLAY "Grand total  : " WS-GRAND-TOTAL
           STOP RUN.

       PROCESS-RECORD.
           MULTIPLY SR-QUANTITY BY SR-UNIT-PRICE
               GIVING WS-LINE-TOTAL
           ADD 1 TO WS-RECORD-COUNT
           ADD WS-LINE-TOTAL TO WS-GRAND-TOTAL.
```

## Walkthrough

### ENVIRONMENT DIVISION and FILE-CONTROL

```cobol
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALES-FILE ASSIGN TO "data/sales.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
```

This is the first time the program uses the `ENVIRONMENT DIVISION`. Its purpose is to connect the program to external resources -- in this case, a file on disk.

The `SELECT` statement creates a logical file name (`SALES-FILE`) that the rest of the program will use. The `ASSIGN TO` clause binds that logical name to a physical file path (`data/sales.dat`). `ORGANIZATION IS LINE SEQUENTIAL` tells the compiler that each record occupies one line of text, terminated by a newline character. This is the most common organization for simple data files processed with GnuCOBOL.

Think of `SELECT ... ASSIGN TO` as a declaration: "this program will use a file, and here is where to find it." The actual opening and reading happen later in the PROCEDURE DIVISION.

### FILE SECTION and the FD entry

```cobol
       FILE SECTION.
       FD SALES-FILE.
       01 SALES-RECORD.
           05 SR-PRODUCT-CODE    PIC X(4).
           05 SR-QUANTITY        PIC 99.
           05 SR-UNIT-PRICE      PIC 9(4).
```

The `FILE SECTION` sits inside the `DATA DIVISION`, before `WORKING-STORAGE SECTION`. It describes the structure of every file declared in `FILE-CONTROL`.

`FD` stands for File Description. The name after `FD` must match the name used in the `SELECT` statement. Under the `FD`, the `01` level record (`SALES-RECORD`) defines the layout of one line from the file. Each `READ` will fill this record with the next line's data, automatically splitting the 10 characters into the three subordinate fields.

This is a key difference from modern languages: COBOL does not give you a raw string that you then parse. Instead, you declare the structure up front, and the runtime maps the data into named fields for you.

### The OPEN / READ / CLOSE pattern

```cobol
           OPEN INPUT SALES-FILE
           ...
           CLOSE SALES-FILE
```

Every file must be opened before it can be read and closed when you are done. `OPEN INPUT` means the file is opened for reading only. Other modes include `OPEN OUTPUT` (writing a new file) and `OPEN I-O` (reading and writing). If you forget to open the file, any `READ` will fail at runtime. If you forget to close it, buffers may not be flushed and resources may leak.

In modern languages, this is equivalent to `open()` / `readline()` / `close()` -- or a `with open(...)` block in Python. The difference is that COBOL pairs the open/close with a formal record structure declared in the FILE SECTION, so every read automatically populates typed, named fields rather than returning a raw string.

### AT END and NOT AT END

```cobol
               READ SALES-FILE
                   AT END
                       MOVE "Y" TO WS-END-OF-FILE
                   NOT AT END
                       PERFORM PROCESS-RECORD
               END-READ
```

The `READ` statement fetches the next record from the file. When there are no more records, the `AT END` clause fires and the program sets the end-of-file flag to "Y". When a record is successfully read, the `NOT AT END` clause fires and the program processes it.

`END-READ` is the scope terminator that closes the `READ` statement, just as `END-IF` closes an `IF`. It keeps the AT END and NOT AT END branches clearly delimited.

### PERFORM UNTIL

```cobol
           PERFORM UNTIL WS-END-OF-FILE = "Y"
               ...
           END-PERFORM
```

This is an inline `PERFORM` loop. It repeats the enclosed statements until the condition `WS-END-OF-FILE = "Y"` becomes true. The condition is tested **before** each iteration (like a `while` loop in C or Python). Once the `AT END` clause sets the flag, the loop exits.

The end-of-file flag pattern -- declare a one-character switch in WORKING-STORAGE, initialize it to "N", and flip it to "Y" inside `AT END` -- is the standard COBOL idiom for reading a file to completion. You will see this pattern in virtually every COBOL batch program.

### The PROCESS-RECORD paragraph

```cobol
       PROCESS-RECORD.
           MULTIPLY SR-QUANTITY BY SR-UNIT-PRICE
               GIVING WS-LINE-TOTAL
           ADD 1 TO WS-RECORD-COUNT
           ADD WS-LINE-TOTAL TO WS-GRAND-TOTAL.
```

This paragraph is called once for every record that is successfully read. It computes the line total by multiplying the quantity by the unit price, increments the record counter, and adds the line total to the running grand total.

By placing this logic in a separate paragraph, the main read loop stays clean and focused on the open/read/close lifecycle. The processing logic can grow in complexity without cluttering the loop itself.

## How to compile and run

```bash
cobc -x -o sales_report main.cob
./sales_report
```

Make sure the `data/sales.dat` file exists relative to the directory where you run the program.

## Expected output

```text
Records read : 0004
Grand total  : 00001075
```

The program reads all four records and accumulates the grand total across them. The leading zeros appear because `WS-RECORD-COUNT` is `PIC 9(4)` and `WS-GRAND-TOTAL` is `PIC 9(8)` -- COBOL displays the full width of a numeric field by default.

## Exercises

1. **Display each line total.** Add a `DISPLAY` statement inside `PROCESS-RECORD` that shows the product code and its computed line total for every record. For example: `"Product P100: line total = 000500"`. This will help you verify that the record is being parsed correctly and that the arithmetic is right.

2. **Student records processor.** Create a new program that reads a file of student records. Each record contains a student name (`PIC X(10)`) followed by a grade (`PIC 99`). The program should read every record, count the total number of students, and count how many passed (grade >= 10). At the end, display both counts. Use the same OPEN / READ / CLOSE pattern and end-of-file flag from this lesson.

3. **Track the highest line total.** Modify the sales report program to also find and display the highest single line total across all records. Add a new WORKING-STORAGE field `WS-MAX-LINE-TOTAL` initialized to zero. In `PROCESS-RECORD`, after computing `WS-LINE-TOTAL`, add an `IF WS-LINE-TOTAL > WS-MAX-LINE-TOTAL` block that updates the maximum. Display the result after the grand total.

## What comes next

In the next lesson you will learn how to write data to a sequential output file — see [10 - Writing a Sequential File](../10_writing_sequential_files/).
