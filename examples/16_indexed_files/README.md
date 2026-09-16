# 16 - Indexed Files and Direct Keyed Lookup

## Objective

Create an indexed customer master and retrieve records directly by primary key instead of scanning a sequential file from beginning to end.

This lesson introduces an architectural shift: the program is no longer only a batch stream processor. It can address a business record by key.

## Concepts covered

- `ORGANIZATION IS INDEXED`
- `RECORD KEY`
- `ACCESS MODE IS DYNAMIC`
- direct `READ ... KEY IS ...`
- `FILE STATUS`
- duplicate/key-not-found failure modes
- customer-master style record access
- sequential scan versus keyed retrieval

## Run

```bash
cd examples/16_indexed_files
cobc -x -o indexed-demo main.cob
./indexed-demo
```

The program first recreates a small customer master, then performs two direct reads:

1. `C0002`, which exists
2. `C9999`, which does not

The missing-key case demonstrates why indexed-file programs should inspect file status rather than silently assuming every key exists.

## Why this matters

With a sequential file, finding one customer generally means reading records until the target is found or the file ends. An indexed file maintains a key structure so the runtime can locate a record directly.

That changes the useful workload from only:

```text
read every record -> transform -> aggregate -> report
```

toward:

```text
business key -> direct record lookup -> business rule
```

Indexed files therefore fit master-data and transaction-processing patterns where random access matters.

## FILE STATUS

The `FILE STATUS` field is a two-character result code maintained by the runtime. The normal success code is `00`; a missing indexed key is typically reported as `23` by GnuCOBOL.

Treat file status as part of the program's control flow. A failed lookup is a business/system state to handle, not an exception to ignore.

## Engineering note

Indexed files are implementation-specific physical files. Do not commit the generated customer-master file to the repository. The example deliberately recreates it each time so the run is deterministic and repeatable.
