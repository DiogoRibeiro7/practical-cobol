# Notes — Lesson 10

## Key terminology

- **OPEN OUTPUT** — opens a file for writing; creates the file if it does not exist, or overwrites it if it does (contrast with OPEN INPUT for reading)
- **WRITE** — sends one record to an open output file; unlike READ which names the file, WRITE names the record (e.g., `WRITE BONUS-RECORD`, not `WRITE BONUS-FILE`)
- **Output FD** — a File Description for a file that will be written to; its record layout defines the structure of each line in the output file, independent of the input FD's layout
- **Read-transform-write pattern** — the fundamental batch processing cycle: read a record from an input file, compute or transform the data, populate an output record, and write it to an output file; this pattern repeats until end-of-file
- **FILLER** — a reserved word used for unnamed fields in a record layout; commonly used to insert literal spaces, separators, or padding between data fields in output records

## Common beginner mistakes

- **Forgetting OPEN OUTPUT** — if the output file is not opened (or is opened with OPEN INPUT instead of OPEN OUTPUT), any WRITE statement will fail with a runtime error; OPEN OUTPUT is required before writing
- **WRITE uses the record name, not the file name** — writing `WRITE BONUS-FILE` instead of `WRITE BONUS-RECORD` causes a compilation error; READ names the file, but WRITE names the 01-level record under the FD
- **Forgetting to CLOSE the output file** — unlike input files where data loss is unlikely, failing to CLOSE an output file can cause buffered records to never be flushed to disk, resulting in a truncated or empty output file
- **Mixing up input and output FD names** — with two FDs in the program, it is easy to accidentally MOVE data into the input record's fields instead of the output record's fields, or to WRITE the wrong record name; use clear, distinct prefixes (e.g., EMP- for input, BR- for output) to avoid confusion
- **Forgetting to populate the output record before WRITE** — the WRITE statement sends whatever is currently in the record buffer; if you forget to MOVE values into the output fields, the record will contain leftover or initial data

## Comparison with modern languages

- The overall pattern is equivalent to opening one file for reading and another for writing: `open("r")` + `open("w")` in Python, `FileReader` + `FileWriter` in Java, or `fopen("r")` + `fopen("w")` in C
- In Python you might write `for line in infile: outfile.write(transform(line))`; the COBOL equivalent is the PERFORM UNTIL loop with READ, followed by MOVEs into the output record, followed by WRITE
- The key COBOL difference is that WRITE uses the **structured record layout** rather than raw strings -- you populate named fields (BR-NAME, BR-SALARY, BR-BONUS, BR-NET-PAY) and the runtime assembles them into a fixed-width line including FILLER spaces, rather than manually concatenating strings
- OPEN OUTPUT is destructive (like Python's `"w"` mode) -- it always creates a fresh file; there is no append behavior unless you use OPEN EXTEND

## Where this pattern appears

- **Batch processing** — reading transaction files, applying business rules, and writing processed output files is the core of mainframe COBOL workloads
- **Data transformation pipelines** — converting data from one format to another (e.g., reading raw sales data and writing enriched records with computed fields) follows the read-transform-write pattern exactly
- **Report file generation** — producing formatted output files (payroll summaries, account statements, inventory reports) that are later printed or sent downstream
- **Payroll output files** — reading employee master records, computing pay, bonuses, and deductions, and writing payroll output files for further processing or direct deposit; this lesson's example is a simplified version of real payroll batch jobs
