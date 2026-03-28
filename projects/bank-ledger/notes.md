# Notes — Bank Ledger Summarizer

## Design decisions

**Why a bank ledger?** A ledger is the simplest example of stateful record processing. Unlike the payroll project where each record is processed independently, every transaction in a ledger depends on the cumulative result of all previous transactions. The running balance teaches learners that WORKING-STORAGE variables can carry meaning across records, not just accumulate totals.

**Why 10 transactions?** Enough to see the pattern clearly (multiple deposits and withdrawals, the balance rising and falling), but few enough to trace by hand. Hand-tracing the running balance is an important exercise — it builds confidence that the program is doing what the learner expects.

**Why a signed balance (PIC S9(7)V99)?** The sample data never produces a negative balance, but a real account could go into overdraft. Using a signed field from the start is defensive programming. It also teaches learners about PIC S, which they first saw in lesson 11. The exercises ask learners to add overdraft detection, which only makes sense if the balance can go negative.

**Why EVALUATE instead of IF?** The classification logic (`D` for deposit, `W` for withdrawal) is a natural fit for EVALUATE. It is cleaner than `IF TXN-TYPE = "D" ... ELSE IF TXN-TYPE = "W"`, and the `WHEN OTHER` branch catches unexpected data — a habit that prevents silent bugs in production systems.

**Why no output file?** Keeping the output as DISPLAY statements makes the project easier to run and debug. Writing to a file is left as an exercise (exercise 5) so learners can practice the OPEN OUTPUT / WRITE pattern from lesson 10 on their own.

## Key patterns in this project

- **Running state** — `WS-BALANCE` is not reset between records; it carries forward, modified by each transaction; this is the defining characteristic of a ledger
- **Classify-and-dispatch** — EVALUATE routes each transaction to different logic (ADD for deposits, SUBTRACT for withdrawals); the same pattern handles transaction types, department codes, and status flags in real systems
- **Multiple accumulators** — separate totals for deposits and withdrawals, plus separate counts; the summary uses all four to produce a complete picture
- **Control total cross-check** — opening + deposits - withdrawals must equal closing; if it does not, there is a bug; control totals are a standard audit technique in financial COBOL
- **Group-level detail line with running balance** — each detail line includes the balance after that transaction, making the output a true ledger rather than just a list of amounts

## How this differs from the payroll project

| Aspect | Payroll | Bank Ledger |
| ------ | ------- | ----------- |
| Record independence | Each employee is processed independently | Each transaction depends on the previous balance |
| Key calculation | Gross = hours x rate (per-record formula) | Balance += amount (cumulative state) |
| Classification | Overtime vs regular (IF) | Deposit vs withdrawal (EVALUATE) |
| Output style | One line per employee + totals | One line per transaction + running balance + totals |
| New concept | COMPUTE with complex expressions | Running state across records |

Both projects use the same structural pattern (header / read-loop / footer), but the ledger adds the dimension of **state that flows between records**.

## Common mistakes when building this kind of program

- **Forgetting to initialize WS-BALANCE** — if you do not MOVE the opening balance before the loop, the running balance starts at zero and every subsequent value is wrong
- **Using unsigned PIC for the balance** — if a withdrawal exceeds the balance, an unsigned field wraps to a large positive number instead of going negative; always use PIC S for any field that might become negative
- **Swapping ADD and SUBTRACT** — adding a withdrawal or subtracting a deposit produces plausible-looking but wrong numbers; the control total cross-check catches this immediately
- **Not handling WHEN OTHER** — if a record has an unexpected type code (neither D nor W), the balance is not updated but the record is still counted; without WHEN OTHER, the program silently ignores it; with WHEN OTHER, it labels the transaction as UNKNOWN, making the problem visible

## Where this pattern appears in real systems

- **Banking** — daily account statements, transaction reconciliation, balance tracking across millions of accounts
- **Accounting** — general ledger processing, trial balance computation, journal entry posting
- **Inventory** — stock-in / stock-out tracking, running quantity on hand
- **Insurance** — premium payment tracking, claim processing with running policy balances
- **Any system with sequential state** — wherever the result of processing one record depends on the accumulated effect of all records before it
