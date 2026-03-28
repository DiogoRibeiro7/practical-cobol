# EX06 - Sales Batch Summary

## Matches lessons

- Lesson 09 - Sequential Files
- Lesson 10 - Writing Sequential Files
- Lesson 11 - Summary Report

## Objective

Build a small batch-processing program that reads sequential sales records, classifies them, and produces a final summary. The goal is to practice the record-at-a-time style used in real COBOL reporting work.

## Prompt

Create a program that reads a line-sequential file of sales records. Each record contains:

- region code: 2 characters
- sales representative name: 12 characters
- units sold: 3 digits
- unit price: 4 digits

For every record:

1. Compute the line revenue as `units sold * unit price`.
2. Add the line revenue to a grand total.
3. Count the record.
4. Classify the record as:
   - `HIGH` if line revenue is 5000 or more
   - `STANDARD` otherwise

At the end, display:

- record count
- grand total revenue
- number of high-value records
- number of standard records

You may also display each processed record if you want extra verification.

## Input assumptions

- The file is line sequential.
- The file path can be a relative path such as `data/ex06_sales_batch.dat`.
- Units sold fits in `PIC 9(3)`.
- Unit price fits in `PIC 9(4)`.
- Grand total should allow several records, so use a larger field such as `PIC 9(8)` or wider.

## Expected learner outcome

By finishing this exercise, you should be able to:

- define a file layout in the `FILE SECTION`
- read to end-of-file using the standard flag pattern
- separate record processing into a paragraph
- mix arithmetic, conditions, and totals inside a batch loop

## Hints

- Keep one `WS-END-OF-FILE` flag in working storage and change it only inside `AT END`.
- A dedicated `PROCESS-RECORD` paragraph keeps the read loop readable.
- Test with a very small data file first so you can predict the totals by hand.
- If the grand total looks wrong, display the current line revenue after each read and check the file layout carefully.
