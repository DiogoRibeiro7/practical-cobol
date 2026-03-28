# Notes — Lesson 11

## Key terminology

- **Summary report** — a report that reads a set of records and presents aggregated totals (counts, sums, averages) rather than just listing individual records
- **Detail line** — one line of output in a report that corresponds to a single input record, showing its key fields in a formatted layout
- **Accumulator** — a WORKING-STORAGE variable that accumulates a running total by having values added to it as each record is processed (e.g., `WS-CREDIT-TOTAL`)
- **Classification** — the process of examining a field in each record (e.g., `TXN-TYPE`) and routing it to different processing logic based on its value
- **Control total** — a total computed during processing that can be used to verify correctness (e.g., credit total + debit total should account for all transactions)
- **Signed field (PIC S)** — a numeric field whose PIC clause begins with `S`, allowing it to store negative values; without `S`, COBOL treats the field as unsigned and discards any negative sign
- **Report header** — the title and column headings displayed at the top of a report before the detail lines
- **Report footer / summary** — the totals and summary information displayed at the bottom of a report after all detail lines

## Common beginner mistakes

- **Forgetting to initialize all counters and accumulators** — if you add a new accumulator (e.g., for a third transaction type) but forget to give it `VALUE 0`, it may contain garbage data and produce incorrect totals
- **Displaying raw numeric fields instead of edited fields** — displaying `WS-CREDIT-TOTAL` directly shows `000106500` instead of `1,065.00`; always MOVE a numeric value into an edited display field (like `PIC ZZ,ZZ9.99`) before displaying it
- **Not handling unknown record types** — always include `WHEN OTHER` in an EVALUATE that classifies records; without it, a record with an unexpected type code is silently ignored and the counters will not add up
- **Mixing up credit and debit logic** — swapping the ADD targets so that credit amounts are added to the debit total (or vice versa); this produces reports where the numbers look plausible but the net balance is wrong
- **Forgetting the S in PIC S9 for signed fields** — if `WS-NET-BALANCE` is `PIC 9(7)V99` instead of `PIC S9(7)V99`, a negative net balance wraps around to a large positive number or is silently truncated
- **Using the wrong display PIC for signed values** — `PIC ZZ,ZZ9.99` cannot show a minus sign; you need `PIC -Z,ZZ9.99` (with a leading `-`) to display negative values correctly

## How file processing shaped COBOL

The read-classify-accumulate-report pattern demonstrated in this lesson is the most common pattern in 60+ years of COBOL batch processing. It is not an academic exercise — it is the actual structure of millions of programs running today in banking, insurance, and government.

COBOL was designed for exactly this workflow. The language's features — fixed-length records, PIC clauses for data layout, EVALUATE for classification, edited fields for formatting — all exist because this pattern was the primary use case from the beginning. When Grace Hopper and the CODASYL committee designed COBOL in 1959, the goal was to process business transactions stored in files and produce formatted reports. This lesson's program would be immediately recognizable to a COBOL programmer from any decade since.

The pattern scales naturally. A program that processes six transactions in a teaching example uses the identical structure to process 50 million transactions in a production bank. The only differences are the number of classification categories, the number of accumulators, and the complexity of the report layout. The fundamental loop — read a record, classify it, update accumulators, repeat until EOF, then print summaries — does not change.

## Comparison with modern languages

The same result this program produces could be achieved in modern languages with higher-level abstractions:

- **pandas**: `df.groupby("type").agg({"amount": ["count", "sum"]})` loads the entire file into memory and computes grouped aggregates in one call.
- **SQL**: `SELECT type, COUNT(*), SUM(amount) FROM transactions GROUP BY type` lets the database engine handle the grouping and aggregation.
- **JavaScript**: `transactions.reduce((acc, txn) => { ... }, {})` accumulates totals in a single pass, similar to COBOL but with dynamic objects instead of pre-declared fields.

The COBOL approach processes one record at a time rather than loading everything into memory. This is not a limitation — it is a design choice that makes COBOL programs work reliably on files of any size. A pandas DataFrame holding 50 million bank transactions requires gigabytes of RAM. The COBOL program uses the same few bytes of WORKING-STORAGE whether the file has 6 records or 50 million.

The trade-off is verbosity. What pandas or SQL accomplish in one line, COBOL spells out over dozens of lines — declaring every field, every accumulator, every display format. But that verbosity is also clarity: every step is explicit, every data transformation is visible, and there are no hidden memory allocations or implicit type conversions.

## Where this pattern appears

- **Bank statements** — reading daily transactions, classifying them by type (deposits, withdrawals, fees, interest), and producing a statement with a running balance
- **Monthly billing summaries** — reading usage records, grouping by service type, computing subtotals and taxes, and generating an invoice
- **Inventory reports** — reading stock movement records, classifying as receipts or shipments, and producing a current-stock report with reorder alerts
- **Payroll summaries** — reading employee pay records, accumulating gross pay, deductions, and net pay, then producing department-level and company-level totals
- **Audit trails** — reading system event logs, classifying by event type, counting occurrences, and producing a summary for compliance review
- **Regulatory reports** — reading transaction data, applying classification rules mandated by regulators, and producing reports in legally required formats (common in banking and insurance)
