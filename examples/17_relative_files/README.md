# 17 - Relative Files and Record Slots

## Objective

Use a relative file as a set of numbered record slots, then perform direct reads by relative record number.

This lesson is deliberately small. Lesson 16 introduced business-key lookup with an indexed file. Lesson 17 shows a different model: the application already knows the numeric slot it wants to address.

## Concepts covered

- `ORGANIZATION IS RELATIVE`
- `RELATIVE KEY`
- `ACCESS MODE IS DYNAMIC`
- writing records to explicit relative record numbers
- sparse record placement
- direct random reads by record number
- detecting an unused slot through `INVALID KEY` and `FILE STATUS`

## Record layout

Each slot stores a compact customer record:

```cobol
       01 CUSTOMER-SLOT-RECORD.
           05 CUSTOMER-ID             PIC X(6).
           05 CUSTOMER-NAME           PIC X(20).
           05 CUSTOMER-STATUS         PIC X.
```

The program writes records into relative record numbers 1, 3, and 5. Slots 2 and 4 are deliberately unused.

## Compile and run

From this directory:

```bash
cobc -x -o relative-demo main.cob
./relative-demo
```

Or from the repository root:

```bash
./scripts/run_example.sh examples/17_relative_files
```

The program recreates its data file on each run, so the result is deterministic.

## Indexed vs relative access

The distinction from lesson 16 is architectural.

With an indexed file, the application asks for a record using a meaningful business key such as a customer ID:

```text
customer ID C0002 -> indexed lookup -> customer record
```

With a relative file, the application addresses a numeric record slot:

```text
relative record 3 -> record stored in slot 3
```

Relative access is useful when the record number itself is meaningful or can be computed cheaply. Indexed access is more natural when applications work with business identifiers whose ordering and storage position should remain hidden behind an index.

## Sparse records

Relative files can contain gaps. This example writes slots 1, 3, and 5 and then deliberately reads slot 2.

That failed read is part of the lesson, not an error in the fixture. It demonstrates that a numeric address can be valid in range while still referring to an unoccupied record slot.

## What to notice

The program makes three direct reads:

- slot 3: occupied
- slot 2: empty
- slot 5: occupied

`FILE STATUS` makes the I/O result observable instead of assuming every requested slot exists.

## Next step

This completes the repository's file-organization survey. The next valuable step is not another isolated syntax lesson. It is a multi-program reconciliation system that combines the patterns already introduced: shared copybooks, fixed-width records, validation, accepted/rejected outputs, and control totals.
