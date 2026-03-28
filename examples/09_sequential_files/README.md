# 09 - Sequential Files

This lesson introduces one of the most practical parts of COBOL: reading records from a sequential file and computing totals.

## Goal

Learn how to:

- declare an input file
- define a file record structure
- open a sequential file
- read records until end-of-file
- accumulate a total
- close the file cleanly

## Program idea

The program reads a simple sales file with one record per line. Each line contains:

- product code
- quantity sold
- unit price

The program computes the total revenue across all records.

## File used in this lesson

`data/sales.dat`

Example lines:

```text
P100100050
P200300125
P300200250
```

Interpretation:

- `P100` -> product code
- `10` -> quantity
- `0050` -> unit price

In this teaching example, the unit price is stored as an integer amount to keep the first file example simple.

## How to run

```bash
cobc -x -o sales_report main.cob
./sales_report
```

## What this lesson prepares you for

- batch processing
- record-by-record transformations
- file summaries
- business reports
