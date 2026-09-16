# Notes - Copybooks and Shared Record Layouts

## Copybooks are source-level reuse

A copybook is not a runtime library. `COPY` tells the COBOL compiler to include external source text at the point where the statement appears.

That makes copybooks particularly useful for definitions that several programs must share:

- file record layouts
- working-storage groups
- common constants
- communication areas
- repeated report structures

## Why record layouts matter

In file-oriented systems, the record layout is a contract. A producer and a consumer must agree on field order, width, type, and numeric representation.

Duplicating that layout in several programs creates a simple failure mode:

1. one program changes a field;
2. another program keeps the old definition;
3. both programs still compile;
4. the consumer interprets bytes using the wrong schema.

A shared copybook reduces that form of drift.

## Modern analogy

A copybook is closest to a shared schema or struct definition, but the mechanism is simpler: source text is inserted at compile time.

Useful analogies include:

- a shared C header containing struct definitions
- a schema module used by several data-processing jobs
- an interface-definition file that keeps producer and consumer layouts aligned

The analogy is not exact because a copybook can contain many forms of COBOL source, not only data declarations.

## Engineering caution

Copybooks reduce duplication, but they also create coupling. A widely used copybook should therefore be treated as a versioned contract.

For larger systems, useful practices include:

- documenting record lengths and field semantics
- keeping backwards compatibility in mind
- reviewing every consumer before changing field widths
- distinguishing additive changes from breaking changes
- validating control totals after a record-layout migration

## Why this lesson counts rejected records

Batch programs should make silent data loss difficult. An unsupported transaction type is not included in the financial totals, but it is counted explicitly.

That gives a basic invariant:

```text
records read = accepted transactions + rejected transactions
```

For the committed fixture:

```text
05 = 04 + 01
```

The same principle scales to more serious reconciliation pipelines.
