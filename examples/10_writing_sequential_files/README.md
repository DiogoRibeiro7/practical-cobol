# 10 - Writing a Sequential File

## Objective

Learn how to read records from one file, transform the data, and write the results to a second file -- the classic read-transform-write pattern that powers most COBOL batch processing.

## Concepts covered

- Declaring **two SELECT statements** in FILE-CONTROL (one for input, one for output)
- Defining **two FD entries** with distinct record layouts in the FILE SECTION
- `OPEN INPUT` vs `OPEN OUTPUT` -- reading mode vs writing mode
- `WRITE` statement -- writes one record to an output file (contrast with `READ`)
- The **read-transform-write** pattern: read from input, compute, populate output record, write
- `FILLER` fields in a record layout to insert literal spaces between data fields
- Accumulating counts and totals across records
- Output files are created fresh each time the program runs

## Data file

The program reads `data/employees.dat`. Each line is a fixed-length record of 20 characters with no delimiters:

```text
ALICE JOHNSON  03500
BOB MARTINEZ   02800
CAROL DAVIS    04200
DAVID CHEN     03100
EVA KOWALSKI   03800
```

The layout is:

| Positions | Length | Field  | PIC   | Example         | Meaning          |
|-----------|--------|--------|-------|-----------------|------------------|
| 1-15      | 15     | Name   | X(15) | ALICE JOHNSON   | Employee name    |
| 16-20     | 5      | Salary | 9(5)  | 03500           | Monthly salary   |

Each record is exactly 20 characters: a 15-character name (padded with spaces) followed by a 5-digit salary.

## Code

```cobol
      *> -------------------------------------------------------
      *> Lesson 10 - Writing a Sequential File
      *> Reads employee records, computes a 10% bonus,
      *> and writes the results to an output file.
      *> -------------------------------------------------------
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BONUS-WRITER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *> Input file: employee names and salaries.
           SELECT EMPLOYEE-FILE ASSIGN TO "data/employees.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
      *> Output file: payroll with bonus calculations.
           SELECT BONUS-FILE ASSIGN TO "data/bonuses.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

      *> -------------------------------------------------------
      *> FILE SECTION — one FD per file.
      *> -------------------------------------------------------
       FILE SECTION.

      *> Input record: 15-char name + 5-digit salary = 20 chars.
       FD EMPLOYEE-FILE.
       01 EMP-RECORD.
           05 EMP-NAME         PIC X(15).
           05 EMP-SALARY       PIC 9(5).

      *> Output record: name + salary + bonus + net pay.
       FD BONUS-FILE.
       01 BONUS-RECORD.
           05 BR-NAME          PIC X(15).
           05 FILLER           PIC X(1) VALUE " ".
           05 BR-SALARY        PIC 9(5).
           05 FILLER           PIC X(1) VALUE " ".
           05 BR-BONUS         PIC 9(5).
           05 FILLER           PIC X(1) VALUE " ".
           05 BR-NET-PAY       PIC 9(5).

       WORKING-STORAGE SECTION.
       01 WS-EOF              PIC X     VALUE "N".
       01 WS-BONUS            PIC 9(5)  VALUE 0.
       01 WS-NET-PAY          PIC 9(5)  VALUE 0.
       01 WS-RECORD-COUNT     PIC 99    VALUE 0.
       01 WS-TOTAL-PAID       PIC 9(6)  VALUE 0.

       PROCEDURE DIVISION.
           OPEN INPUT  EMPLOYEE-FILE
           OPEN OUTPUT BONUS-FILE

           PERFORM UNTIL WS-EOF = "Y"
               READ EMPLOYEE-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESS-EMPLOYEE
               END-READ
           END-PERFORM

           CLOSE EMPLOYEE-FILE
           CLOSE BONUS-FILE

           DISPLAY "Records written: " WS-RECORD-COUNT
           DISPLAY "Total paid out : " WS-TOTAL-PAID
           DISPLAY " "
           DISPLAY "Output saved to data/bonuses.dat"

           STOP RUN.

      *> -------------------------------------------------------
      *> PROCESS-EMPLOYEE
      *> Computes a 10% bonus, builds the output record,
      *> and writes it to the bonus file.
      *> -------------------------------------------------------
       PROCESS-EMPLOYEE.
      *> Calculate bonus (10% of salary).
           MULTIPLY EMP-SALARY BY 10
               GIVING WS-BONUS
           DIVIDE WS-BONUS BY 100
               GIVING WS-BONUS
           ADD EMP-SALARY TO WS-BONUS
               GIVING WS-NET-PAY

      *> Populate the output record.
           MOVE EMP-NAME    TO BR-NAME
           MOVE EMP-SALARY  TO BR-SALARY
           MOVE WS-BONUS    TO BR-BONUS
           MOVE WS-NET-PAY  TO BR-NET-PAY

      *> Write one line to the output file.
           WRITE BONUS-RECORD

      *> Display progress and accumulate.
           DISPLAY EMP-NAME " | "
                   EMP-SALARY " | "
                   WS-BONUS " | "
                   WS-NET-PAY
           ADD 1 TO WS-RECORD-COUNT
           ADD WS-NET-PAY TO WS-TOTAL-PAID.
```

## Walkthrough

### Two SELECT statements -- first time with two files

```cobol
       FILE-CONTROL.
      *> Input file: employee names and salaries.
           SELECT EMPLOYEE-FILE ASSIGN TO "data/employees.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
      *> Output file: payroll with bonus calculations.
           SELECT BONUS-FILE ASSIGN TO "data/bonuses.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
```

In lesson 09 you declared one `SELECT` for one input file. This lesson introduces a second `SELECT` -- one for reading (`EMPLOYEE-FILE`) and one for writing (`BONUS-FILE`). Each `SELECT` gives the file a logical name and binds it to a physical path on disk. You can have as many `SELECT` statements as your program needs; just list them one after another in the `FILE-CONTROL` paragraph. Both files use `ORGANIZATION IS LINE SEQUENTIAL`, meaning each record is one line of text.

### Two FD entries -- input layout vs output layout

```cobol
       FD EMPLOYEE-FILE.
       01 EMP-RECORD.
           05 EMP-NAME         PIC X(15).
           05 EMP-SALARY       PIC 9(5).

       FD BONUS-FILE.
       01 BONUS-RECORD.
           05 BR-NAME          PIC X(15).
           05 FILLER           PIC X(1) VALUE " ".
           05 BR-SALARY        PIC 9(5).
           05 FILLER           PIC X(1) VALUE " ".
           05 BR-BONUS         PIC 9(5).
           05 FILLER           PIC X(1) VALUE " ".
           05 BR-NET-PAY       PIC 9(5).
```

Every `SELECT` needs a matching `FD` in the FILE SECTION. The input record (`EMP-RECORD`) has two fields totaling 20 characters -- it matches the physical layout of `employees.dat`. The output record (`BONUS-RECORD`) has four data fields plus three `FILLER` fields and is 33 characters wide. The two layouts are completely independent; the input file and output file do not need to have the same structure.

Notice the `FILLER` entries in the output record. Each `FILLER PIC X(1) VALUE " "` inserts a literal space between fields when the record is written. FILLER is a reserved word meaning "this field has no name and cannot be referenced in code." It exists solely to shape the physical layout of the record. Without the FILLER fields, the output columns would run together with no separation.

### OPEN INPUT vs OPEN OUTPUT

```cobol
           OPEN INPUT  EMPLOYEE-FILE
           OPEN OUTPUT BONUS-FILE
```

`OPEN INPUT` opens a file for reading -- the file must already exist on disk. `OPEN OUTPUT` opens a file for writing -- if the file does not exist, it is created; if it already exists, it is overwritten with a new empty file. This means `data/bonuses.dat` is created fresh every time the program runs. Any previous contents are replaced.

This is the same distinction as `open("r")` vs `open("w")` in Python, or `FileReader` vs `FileWriter` in Java. The mode tells the runtime what operations are allowed: you can only `READ` from an INPUT file, and you can only `WRITE` to an OUTPUT file.

### The read-transform-write pattern

```cobol
           PERFORM UNTIL WS-EOF = "Y"
               READ EMPLOYEE-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESS-EMPLOYEE
               END-READ
           END-PERFORM
```

The main loop follows the same structure as lesson 09: read a record, check for end-of-file, and process if successful. The difference is that `PROCESS-EMPLOYEE` now does more than accumulate totals -- it transforms the data and writes it to a second file.

This is the **read-transform-write** pattern, the workhorse of COBOL batch processing:

1. **Read** a record from the input file (`READ EMPLOYEE-FILE`).
2. **Transform** the data by computing new values (bonus and net pay).
3. **Populate** the output record by MOVEing values into the output FD's fields.
4. **Write** the output record to the output file (`WRITE BONUS-RECORD`).

In modern terms, this is like reading one file line by line, processing each line, and writing the result to another file with `open("w")`.

### WRITE BONUS-RECORD -- writing to the output file

```cobol
           WRITE BONUS-RECORD
```

`WRITE` sends one record to the output file. Notice a critical difference from `READ`: the `READ` statement names the **file** (`READ EMPLOYEE-FILE`), but the `WRITE` statement names the **record** (`WRITE BONUS-RECORD`). This is a COBOL convention that catches many beginners off guard. Writing `WRITE BONUS-FILE` would cause a compilation error.

When `WRITE BONUS-RECORD` executes, COBOL takes the current contents of the `BONUS-RECORD` group item -- all its subordinate fields including the FILLER spaces -- and appends one line to `data/bonuses.dat`. Since the organization is LINE SEQUENTIAL, a newline character is added automatically at the end of each record.

### PROCESS-EMPLOYEE -- compute, populate, write

```cobol
       PROCESS-EMPLOYEE.
           MULTIPLY EMP-SALARY BY 10
               GIVING WS-BONUS
           DIVIDE WS-BONUS BY 100
               GIVING WS-BONUS
           ADD EMP-SALARY TO WS-BONUS
               GIVING WS-NET-PAY

           MOVE EMP-NAME    TO BR-NAME
           MOVE EMP-SALARY  TO BR-SALARY
           MOVE WS-BONUS    TO BR-BONUS
           MOVE WS-NET-PAY  TO BR-NET-PAY

           WRITE BONUS-RECORD

           DISPLAY EMP-NAME " | "
                   EMP-SALARY " | "
                   WS-BONUS " | "
                   WS-NET-PAY
           ADD 1 TO WS-RECORD-COUNT
           ADD WS-NET-PAY TO WS-TOTAL-PAID.
```

This paragraph brings the entire pattern together:

1. **Compute** the bonus as 10% of the salary using MULTIPLY and DIVIDE, then compute net pay by adding the salary and bonus.
2. **Populate** the output record by MOVEing each value into the corresponding field of `BONUS-RECORD`. The FILLER fields are already set to spaces by their VALUE clauses, so they do not need to be moved.
3. **Write** the populated record to the output file.
4. **Display** the same values to the console so the user can see progress.
5. **Accumulate** the record count and total paid.

### Closing both files

```cobol
           CLOSE EMPLOYEE-FILE
           CLOSE BONUS-FILE
```

Both files must be closed when processing is complete. Closing the output file is especially important -- it flushes any buffered data to disk. If you forget to close the output file, the last few records may not be written and your output file could be incomplete or corrupted.

## How to compile and run

```bash
cobc -x -o bonus_writer main.cob
./bonus_writer
```

Make sure the `data/employees.dat` file exists relative to the directory where you run the program. The output file `data/bonuses.dat` will be created automatically.

## Expected output

```text
ALICE JOHNSON   | 03500 | 00350 | 03850
BOB MARTINEZ    | 02800 | 00280 | 03080
CAROL DAVIS     | 04200 | 00420 | 04620
DAVID CHEN      | 03100 | 00310 | 03410
EVA KOWALSKI    | 03800 | 00380 | 04180
Records written: 05
Total paid out : 019140

Output saved to data/bonuses.dat
```

After running the program, the file `data/bonuses.dat` will contain the same five employee lines (without the summary lines), each formatted as: name, space, salary, space, bonus, space, net pay.

## Exercises

1. **Add a header line to the output file.** After the program runs, open `data/bonuses.dat` and verify its contents match the displayed output. Then modify the program to write a header line as the first record in the output file. Before the read loop begins, populate `BONUS-RECORD` with column labels (e.g., "NAME" in `BR-NAME`, "SALARY" in `BR-SALARY`, etc.) and execute a `WRITE BONUS-RECORD` to place the header at the top of the file.

2. **Add a deductions column.** Compute a 5% tax deduction for each employee: `deduction = salary * 5 / 100`. Subtract the deduction from the net pay. Add a new `BR-DEDUCTION` field (and its FILLER spacer) to the output record layout, and include the deduction in both the DISPLAY and the WRITE.

3. **Build a filter program.** Create a new program that reads a list of product names and prices from one file (e.g., 20-char name + 5-digit price per line) and writes only the products priced above 100 to a second file. This is a filter operation -- the output file will contain fewer records than the input. Use an `IF` inside the processing paragraph to decide whether to WRITE each record.

## What comes next

In the next lesson you will combine file reading and writing with accumulators and formatting to produce a complete summary report -- see [11 - File-Based Summary Report](../11_summary_report/).
