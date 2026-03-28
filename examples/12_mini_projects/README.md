# 12 - Mini Projects

## Objective

Use the lessons as building blocks for larger, business-style COBOL programs. This folder is not a single runnable lesson. It is the bridge between the guided examples and the standalone projects in [`projects/`](../../projects/).

## What changes at this stage

Up to lesson 11, the repository teaches one main idea at a time. The mini-project stage changes the goal:

- fewer isolated concepts
- more complete programs
- more realistic input files
- more report-style output
- more responsibility placed on the learner to read and connect ideas

If the earlier lessons taught the pieces, the projects show how those pieces work together.

## Suggested project order

1. **Payroll Processor**  
   Start here if you want the smoothest step up from the lessons. It combines file input, arithmetic, conditions, paragraphs, and formatted report output in a familiar batch-processing pattern.

2. **Bank Ledger Summarizer**  
   Take this next. It introduces a running balance, which is an important step beyond simple per-record calculations.

3. **Student Records Report**  
   Use this as a guided build if you want more repetition around tables, averages, and pass/fail classification.

4. **Inventory Summary**  
   Use this when you want more practice with stock totals, thresholds, and reporting structure.

## Project map

| Project | Focus | Best after lessons |
| ------- | ----- | ------------------ |
| `projects/payroll/` | overtime, pay calculation, totals, formatted report | 04, 05, 06, 07, 09, 11 |
| `projects/bank-ledger/` | running balance, transaction classification, report summary | 05, 06, 07, 09, 11 |
| `projects/student-records/` | averages, classification, small report logic | 05, 08, 11 |
| `projects/inventory-summary/` | accumulation, thresholds, stock reporting | 05, 08, 11 |

## Readiness checklist

Before you start the projects, you should be comfortable with:

- defining fields with `PIC`
- moving and displaying values
- using `IF` or `EVALUATE` for business rules
- organizing logic with paragraphs and `PERFORM`
- reading sequential files with the end-of-file flag pattern
- reading report output without getting lost in the formatting fields

If one of those still feels shaky, revisit the matching lesson first. That is faster than forcing your way through a project too early.

## What to expect from the project folders

The project folders are intentionally less hand-held than the lesson folders. They are still instructional, but they expect you to:

- read longer programs
- trace several paragraphs
- follow data from input record to output report
- reason about totals and control checks

That is the right level for a first public release. The projects are substantial enough to feel real, but still small enough to study in one sitting.

## Next step

Go to [`projects/README.md`](../../projects/README.md) for the project hub, then start with [`projects/payroll/README.md`](../../projects/payroll/README.md).
