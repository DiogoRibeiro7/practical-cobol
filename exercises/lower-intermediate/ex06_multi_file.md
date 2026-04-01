# Exercise 06 - Multi-file Sales Summary

## Objective

Create a COBOL program that reads two input files and produces a combined summary.

## Requirements

1. Read `data/sales_q1.dat` and `data/sales_q2.dat`.
2. Each file record is 10 characters long:
   - `ProductCode` (4 characters)
   - `Quantity` (2 digits)
   - `UnitPrice` (4 digits)
3. For each record, compute `ExtendedPrice = Quantity * UnitPrice`.
4. Track:
   - Count and subtotal for Q1 file
   - Count and subtotal for Q2 file
   - Grand total for both files.
5. Output:
   - One line per processed record: source, product code, quantity, unit price, extended price.
   - summary block with Q1 record count/subtotal, Q2 record count/subtotal, and grand total.

## Data sample

`data/sales_q1.dat`:
```
P00105120
P00208150
P00303100
```

`data/sales_q2.dat`:
```
P00404700
P00502550
```

## Learning outcome

- Open multiple input files in one run
- Maintain separate EOF flags and counters per input file
- Process records across two streams and aggregate totals

## Verification

- Use the provided `examples/14_multi_file/main.cob` as reference.
- Run `cobc -x -o lesson.out main.cob` in `examples/14_multi_file`, then `./lesson.out`.
- Expected grand total: 6000
