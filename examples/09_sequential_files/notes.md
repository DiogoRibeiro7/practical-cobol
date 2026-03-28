# Notes — Lesson 09

## Key terminology

- **SELECT** — associates a logical file name used in the program with an external file (in the ENVIRONMENT DIVISION)
- **ASSIGN** — specifies the physical file name or path that a SELECT refers to
- **FD** (File Description) — describes the structure of a file's records in the DATA DIVISION FILE SECTION
- **FILE SECTION** — the section within DATA DIVISION where file record layouts are defined (separate from WORKING-STORAGE)
- **OPEN** — makes a file available for processing (OPEN INPUT for reading, OPEN OUTPUT for writing)
- **READ** — retrieves the next record from an open input file into the record buffer
- **CLOSE** — releases a file after processing is complete, ensuring all buffers are flushed
- **AT END** — a clause on the READ statement that specifies what to do when there are no more records (end-of-file)
- **LINE SEQUENTIAL** — a file organization where each record is a text line terminated by a newline character (common on Unix/Windows; contrast with fixed-length record files on mainframes)
- **Record** — a single unit of data in a file, described by the FD's record layout (one READ retrieves one record)
- **End-of-file flag** — a WORKING-STORAGE variable (e.g., PIC X VALUE 'N') used to track whether the last READ hit the end of the file

## Common beginner mistakes

- Forgetting to CLOSE the file — while the program may appear to work, not closing files can cause data loss (unflushed buffers) or resource leaks
- Not initializing the EOF flag — if the flag is not set to 'N' (or equivalent) before the read loop begins, the loop may never execute or may behave unpredictably
- Trying to READ after end-of-file — once AT END triggers, further READs are undefined; the loop must stop immediately when the EOF flag is set
- Forgetting the ENVIRONMENT DIVISION — SELECT and ASSIGN go in the INPUT-OUTPUT SECTION of the ENVIRONMENT DIVISION, which beginners sometimes omit entirely

## Comparison with modern languages

- The overall pattern is like `open()` / `readline()` / `close()` in Python, `BufferedReader` in Java, `fs.readFileSync()` or streams in Node.js, or `fopen()` / `fgets()` / `fclose()` in C
- The key difference is the formal record structure defined in the DATA DIVISION — modern languages typically read raw strings or bytes and parse them in code, while COBOL maps file data directly into named fields
- SELECT/ASSIGN is like specifying a file path, FD is like defining a schema or struct for each line, and READ automatically populates the struct

## Where this pattern appears

- This is the classic COBOL batch pattern — read records from an input file, process each one, accumulate totals, and produce a report or updated output file
- Banking — processing daily transaction files, generating account statements, reconciling batches
- Payroll — reading employee records, computing pay, generating checks or direct deposit files
- Inventory — reading stock movement files, updating quantities, producing reorder reports
- The read-process-write loop is the most fundamental pattern in mainframe COBOL and has been running in production since the 1960s
