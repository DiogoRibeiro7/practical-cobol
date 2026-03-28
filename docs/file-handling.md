# File Handling

One of COBOL's most practical strengths is processing records from files. In this repository, file handling appears after variables, arithmetic, conditions, and loops because file programs combine all of those skills at once.

The core pattern is:

1. declare the file
2. describe one record
3. open the file
4. read one record at a time
5. process each record
6. detect end-of-file
7. close the file

That pattern shows up again and again in business COBOL.

## A minimal sequential-file example

```cobol
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALES-FILE ASSIGN TO "data/sales.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD SALES-FILE.
       01 SALES-RECORD.
           05 SR-CODE      PIC X(4).
           05 SR-QUANTITY  PIC 99.
           05 SR-PRICE     PIC 9(4).

       WORKING-STORAGE SECTION.
       01 WS-END-OF-FILE   PIC X VALUE "N".

       PROCEDURE DIVISION.
           OPEN INPUT SALES-FILE
           PERFORM UNTIL WS-END-OF-FILE = "Y"
               READ SALES-FILE
                   AT END
                       MOVE "Y" TO WS-END-OF-FILE
                   NOT AT END
                       DISPLAY SR-CODE
               END-READ
           END-PERFORM
           CLOSE SALES-FILE
           STOP RUN.
```

## `SELECT ... ASSIGN TO`

This connects a COBOL file name to a physical file path:

```cobol
           SELECT SALES-FILE ASSIGN TO "data/sales.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
```

`SALES-FILE` is the logical name used inside the program. `"data/sales.dat"` is the actual file path.

For beginner examples, `LINE SEQUENTIAL` is the easiest format to understand because each record is one text line.

## `FD` and the record layout

The `FD` entry describes what one record looks like:

```cobol
       FD SALES-FILE.
       01 SALES-RECORD.
           05 SR-CODE      PIC X(4).
           05 SR-QUANTITY  PIC 99.
           05 SR-PRICE     PIC 9(4).
```

When COBOL reads a line, it maps the characters into those fields. You do not manually split the string the way you might in Python.

That is a big part of COBOL's style: define the data shape first, then process named fields.

## `OPEN`, `READ`, `CLOSE`

These verbs form the standard file lifecycle.

### `OPEN INPUT`

Use this when you want to read an existing file.

### `READ`

Use this to fetch the next record.

### `CLOSE`

Use this when processing is finished.

Even in small teaching programs, it is good practice to show the full lifecycle clearly.

## End-of-file handling

Most beginner COBOL programs use a simple flag:

```cobol
       01 WS-END-OF-FILE PIC X VALUE "N".
```

Then inside the `READ`:

```cobol
               READ SALES-FILE
                   AT END
                       MOVE "Y" TO WS-END-OF-FILE
                   NOT AT END
                       PERFORM PROCESS-RECORD
               END-READ
```

This is a standard COBOL pattern. It is worth learning early because it appears in many real programs.

## Why paragraphs help file programs

A good file program usually keeps the loop small:

```cobol
           PERFORM UNTIL WS-END-OF-FILE = "Y"
               READ SALES-FILE
                   AT END
                       MOVE "Y" TO WS-END-OF-FILE
                   NOT AT END
                       PERFORM PROCESS-RECORD
               END-READ
           END-PERFORM
```

Then the detailed logic lives in `PROCESS-RECORD`.

That separation makes the program easier to read:

- the loop handles file control
- the paragraph handles business logic

## Comparison with modern languages

In Python, you often read a line as plain text and then split it:

```python
for line in file:
    code = line[:4]
```

In COBOL, you usually declare the record layout once and let the runtime populate named fields. The benefit is clarity for fixed-format business data.

## Practical advice for this repository

- Start with the lessons in order. File handling is easier after `PERFORM`, `IF`, and arithmetic.
- Pay attention to the record layout widths. One wrong width can break every field after it.
- If a file example behaves strangely, check the working directory first. Relative paths matter.
- Display intermediate values when debugging. A single `DISPLAY` inside `PROCESS-RECORD` often reveals the problem quickly.

## Related lessons

- Lesson 09 - reading sequential files
- Lesson 10 - writing sequential files
- Lesson 11 - file-based summary reports

These docs are a reference. The step-by-step teaching still happens in the lesson folders.
