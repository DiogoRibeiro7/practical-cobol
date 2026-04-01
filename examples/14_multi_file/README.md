# 14 - Multi-file Sequential Input

## Objective

Read from two separate sequential input files in one COBOL program, process each record, and produce a combined summary.

## Concepts covered

- Opening multiple input files in the same program
- Parallel read control with separate EOF flags
- Reusing processing logic for multiple file streams
- Accumulating totals from two input sources

## Data files

- `data/sales_q1.dat` (first file)
- `data/sales_q2.dat` (second file)

Each record is fixed-length, containing a product code, quantity, and unit price, for example:

`P00105120` means product P001, quantity 05, unit price 120.

### Layout

| Positions | Length | Field       | PIC    | Meaning                        |
|-----------|--------|-------------|--------|--------------------------------|
| 1-4       | 4      | Product code| X(4)   | Product identifier             |
| 5-6       | 2      | Quantity    | 99     | Quantity sold                  |
| 7-10      | 4      | Unit price  | 9(4)   | Price per unit (integer cents) |

## Run

From repository root:

```bash
cd examples/14_multi_file
cobc -x -o lesson.out main.cob
./lesson.out
```

## Expected output

- 2 lines for each record read from both files (Q1 and Q2)
- totals for Q1, Q2, and grand total

See `expected_output.txt` for one sample result.
