# COBOL Structure

COBOL programs look unusual at first because they are organized into named sections called **divisions**. That structure is not decoration. It tells the reader where to look for identity, files, data, and executable logic.

For a beginner, the simplest mental model is:

- `IDENTIFICATION DIVISION` says what the program is
- `ENVIRONMENT DIVISION` says what outside resources it uses
- `DATA DIVISION` says what data exists
- `PROCEDURE DIVISION` says what the program does

## A tiny example

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-NAME PIC X(10) VALUE "COBOL".

       PROCEDURE DIVISION.
           DISPLAY "HELLO, " WS-NAME
           STOP RUN.
```

This is already enough to show COBOL's basic shape:

- identity first
- data definitions before logic
- executable statements last

## The four main divisions

## `IDENTIFICATION DIVISION`

This is where the program name lives:

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
```

You will see `PROGRAM-ID` in every example in this repository. Think of it as the label for the compiled program.

## `ENVIRONMENT DIVISION`

This division becomes important when a program works with files. For example:

```cobol
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALES-FILE ASSIGN TO "data/sales.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
```

Beginners often do not need this division until the file lessons. That is why the early examples leave it out.

## `DATA DIVISION`

This is where you declare variables, record layouts, counters, totals, and file records.

The most common early section is:

```cobol
       WORKING-STORAGE SECTION.
```

Example:

```cobol
       01 WS-TOTAL     PIC 9(4) VALUE 0.
       01 WS-NAME      PIC X(20) VALUE SPACES.
```

Unlike many modern languages, COBOL wants the program's data shape declared up front. That is why the course spends time on `PIC` and record layouts early.

## `PROCEDURE DIVISION`

This is the executable part of the program:

```cobol
       PROCEDURE DIVISION.
           ADD 1 TO WS-TOTAL
           DISPLAY WS-TOTAL
           STOP RUN.
```

In the early lessons, the `PROCEDURE DIVISION` is a short top-to-bottom script. Later, it becomes more structured with paragraphs and `PERFORM`.

## Sections you will see often

## `WORKING-STORAGE SECTION`

Used for program variables that live for the whole run:

- counters
- flags
- totals
- names
- rates
- result fields

## `FILE SECTION`

Used in file-based programs to describe one record from a file:

```cobol
       FILE SECTION.
       FD SALES-FILE.
       01 SALES-RECORD.
           05 SR-CODE      PIC X(4).
           05 SR-QUANTITY  PIC 99.
           05 SR-PRICE     PIC 9(4).
```

This appears in the sequential file lessons.

## Paragraphs

Inside the `PROCEDURE DIVISION`, COBOL often uses named paragraphs:

```cobol
       PROCEDURE DIVISION.
           PERFORM CALCULATE-TOTAL
           PERFORM DISPLAY-RESULT
           STOP RUN.

       CALCULATE-TOTAL.
           ADD WS-A TO WS-B GIVING WS-TOTAL.

       DISPLAY-RESULT.
           DISPLAY "TOTAL: " WS-TOTAL.
```

This is COBOL's basic structure for keeping logic readable. A good paragraph name tells the reader what business step is happening.

## How this compares to modern languages

In Python or JavaScript, you often start writing executable code immediately and define variables close to where they are used. COBOL usually does the opposite:

- define the data first
- describe the outside resources
- then write the processing steps

That feels verbose at first, but it becomes helpful when programs process business records, totals, and reports.

## What to focus on as a learner

Do not try to memorize every division and section at once. Focus on this progression:

1. Learn `IDENTIFICATION`, `DATA`, and `PROCEDURE`.
2. Get comfortable with `WORKING-STORAGE`.
3. Add paragraphs and `PERFORM`.
4. Add `ENVIRONMENT` and `FILE SECTION` when you reach file lessons.

That is the same order used by the examples in this repository.
