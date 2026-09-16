# 15 - Copybooks and Shared Record Layouts

## Objective

Use a COBOL copybook as a shared data contract for a fixed-width transaction file, then process the records with explicit validation and control totals.

This lesson is the first step from self-contained examples toward the structure of larger COBOL systems, where multiple programs often need to agree on exactly the same record layout.

## Concepts covered

- `COPY` and copybook inclusion
- shared fixed-width record definitions
- separating record contracts from program logic
- transaction classification with `EVALUATE`
- accepted and rejected record counts
- deposit, withdrawal, and closing-balance control totals
- why shared layouts reduce drift between programs

## Files

```text
15_copybooks/
├── copybooks/
│   └── transaction-record.cpy
├── data/
│   └── transactions.dat
├── expected_output.txt
├── main.cob
├── notes.md
└── README.md
```

The important file is `copybooks/transaction-record.cpy`. It owns the transaction record layout:

```cobol
       01 TXN-RECORD.
           05 TXN-ID                PIC X(6).
           05 TXN-TYPE              PIC X.
           05 TXN-AMOUNT            PIC 9(5)V99.
           05 TXN-DESCRIPTION       PIC X(20).
```

`main.cob` imports that definition in the `FILE SECTION`:

```cobol
       FD TRANSACTION-FILE.
       COPY "copybooks/transaction-record.cpy".
```

The compiler processes the copybook as source text at compile time. A second program reading the same file can import the same layout instead of duplicating the field definitions.

## Input contract

Each input record contains:

| Field | Width | Meaning |
| --- | ---: | --- |
| `TXN-ID` | 6 | Transaction identifier |
| `TXN-TYPE` | 1 | `D` for deposit, `W` for withdrawal |
| `TXN-AMOUNT` | 7 | Five integer digits and two implied decimal digits |
| `TXN-DESCRIPTION` | 20 | Free-text business description |

The fixture intentionally includes one record with an unsupported transaction type. The program counts it as rejected and excludes it from the financial totals.

## Compile and run

From this directory:

```bash
cobc -x -o copybook-demo main.cob
./copybook-demo
```

Or from the repository root:

```bash
./scripts/run_example.sh examples/15_copybooks
```

## What to notice

The lesson has two separate responsibilities:

1. The copybook defines the shape of the external record.
2. The program defines what the business process does with that record.

That separation matters. If the transaction record changes, programs that consume it should update against one shared definition rather than maintaining independent copies of the same layout.

The summary also introduces simple batch controls:

- records read
- accepted transactions
- rejected transactions
- deposit and withdrawal counts
- deposit and withdrawal totals
- closing balance

These controls make the batch result easier to audit than a program that only prints transformed records.

## Try it yourself

1. Add a new valid transaction and verify the closing balance changes.
2. Add another invalid transaction type and verify only the rejected count changes.
3. Create a second COBOL program in this folder that imports the same copybook and prints only transaction IDs and descriptions.
4. Change the description width in the copybook and observe how that single contract change affects every importing program.

## Next step

The natural next step is to use the same copybook across multiple programs in a capstone: one program produces a transaction file, another validates it, and another reconciles totals. That moves copybooks from a lesson feature into a real inter-program data contract.
