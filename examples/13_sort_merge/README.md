# 13 - Sort and Merge Processing

## Objective

Learn COBOL `SORT` and `MERGE` verbs with sequential files: sort an unsorted file and merge two presorted files.

## Concepts covered

- `SORT` verb with `INPUT PROCEDURE` and `OUTPUT PROCEDURE`
- `MERGE` verb with multiple input files and one output file
- `RELEASE` and `RETURN` in sort/merge procedures
- `ON ASCENDING KEY` sorting key evaluation
- Sequential file structure and layout for batch processing
- File processing patterns from lessons 09 and 11 with explicit sort/merge steps

## Data files

- `data/sort_input.dat`: unsorted names with numeric keys
- `data/merge_a.dat` and `data/merge_b.dat`: pre-sorted key/name pairs

## Code

See `main.cob` for the full implementation.

## Walkthrough

1. `SORT-PROCESS` calls `SORT` on `SORT-FILE` using key `SORT-FILE-ID`.
2. `SORT-INPUT` reads the unsorted source file and issues `RELEASE` for each record.
3. `SORT-OUTPUT` uses `RETURN` to get sorted records and writes to `sorted_output.dat`.
4. `MERGE-PROCESS` calls `MERGE` on `MERGE-FILE` with the same key.
5. `MERGE-INPUT` reads both source files and releases records.
6. `MERGE-OUTPUT` returns merged output into `merged_output.dat`.

## How to compile and run

From the repository root:

```bash
cobc -x -o examples/13_sort_merge/sortmerge examples/13_sort_merge/main.cob
cd examples/13_sort_merge
./sortmerge
```

## Expected output

See `expected_output.txt`.

## Exercises

1. Add an additional field `balance` to each record and adjust sorting to use `ID` as primary key and `balance` as secondary key.
2. Add validation to `MERGE-INPUT` that skips records with empty names and logs a message.
3. Modify the program to generate an on-screen preview of the first 5 lines of `sorted_output.dat` after sort completes.

## What comes next

Continue with `examples/12_mini_projects/` to practice full project workflows and longer batch-processing examples.
