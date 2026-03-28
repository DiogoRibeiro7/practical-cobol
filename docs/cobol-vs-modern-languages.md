# COBOL vs Modern Languages

COBOL is not hard because the core ideas are alien. It is hard because the language makes different things visible.

If you already know Python, Java, JavaScript, C, or Rust, many ideas in this repository will feel familiar:

- variables
- input and output
- arithmetic
- conditions
- loops
- reusable blocks
- file processing

The difference is emphasis.

## What COBOL emphasizes

COBOL puts extra weight on:

- data layout
- fixed-width records
- business-readable naming
- explicit processing steps
- batch-style file work

That is why the course keeps returning to field definitions, record layouts, totals, counters, and report logic.

## A small comparison

### Python

```python
name = "Ana"
score = 75
if score >= 50:
    print("PASS")
else:
    print("FAIL")
```

### COBOL

```cobol
       WORKING-STORAGE SECTION.
       01 WS-NAME   PIC X(10) VALUE "ANA".
       01 WS-SCORE  PIC 999   VALUE 75.

       PROCEDURE DIVISION.
           IF WS-SCORE >= 50
               DISPLAY "PASS"
           ELSE
               DISPLAY "FAIL"
           END-IF
           STOP RUN.
```

The logic is the same. The COBOL version simply makes the data shape explicit.

## Functions vs paragraphs

Modern languages often use functions with parameters and return values.

COBOL beginner programs usually use paragraphs with shared working storage:

```cobol
       PROCEDURE DIVISION.
           PERFORM CALCULATE-BONUS
           PERFORM DISPLAY-RESULT
           STOP RUN.
```

That can feel less flexible at first, but it matches COBOL's record-processing style. The program's fields represent the current business data, and paragraphs operate on those fields.

## Arrays vs `OCCURS`

If you know arrays or lists, `OCCURS` is the same general idea:

- Python list
- Java array
- C array
- COBOL table with `OCCURS`

The main beginner differences are:

- COBOL tables are usually fixed size
- COBOL subscripts start at 1, not 0

## Strings vs fixed-width text

Modern languages often treat strings as flexible sequences that grow and shrink easily.

COBOL commonly uses fixed-width text fields:

```cobol
       01 WS-CITY PIC X(15).
```

That means storage layout matters more. This is useful when building reports and files with strict field positions.

## File processing style

In many modern languages, you read raw text and parse it yourself. In COBOL, you often:

1. define the record layout
2. read one record
3. process named fields
4. update totals and counts

That makes COBOL especially readable for business reporting code.

## What not to do

It is easy to keep asking:

- why no curly braces?
- why no local variables?
- why not just use JSON?

Those questions are understandable, but they rarely help you learn the examples in this repository.

A better question is:

**What job is this COBOL program trying to do?**

Usually the answer is something like:

- process records
- apply business rules
- accumulate totals
- produce output that is easy to audit

Once you adopt that mindset, the design choices make more sense.

## A practical learner mindset

Use your modern-language experience, but do not force COBOL to behave like Python or JavaScript.

Instead:

- recognize the familiar programming ideas
- pay extra attention to data definitions
- treat record layout as part of the logic
- read paragraph names as business steps

That is enough to get value from the course without turning every lesson into a language debate.
