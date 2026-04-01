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

- `data/sort_input.dat`: unsorted key/name rows (3-digit ID + fixed 20-char name)
- `data/merge_a.dat`, `data/merge_b.dat`: pre-sorted key/name rows
- `data/sorted_output.dat`: generated sorted output from `SORT` run
- `data/merged_output.dat`: generated merged output from `MERGE` run

Example record format (fixed width 23 chars):

```
001 Alice               
003 Charlie            
002 Bob                
```

## Code

See `main.cob` for the full implementation.

## Walkthrough

1. `SORT-PROCESS` calls `SORT` on `SORT-FILE` using key `SORT-FILE-ID`.
2. `SORT-INPUT` reads `data/sort_input.dat` and issues `RELEASE` for each record.
3. `SORT-OUTPUT` uses `RETURN` to read sorted records and writes `data/sorted_output.dat`.
4. `MERGE-PROCESS` calls `MERGE` on `MERGE-FILE` keyed by `MERGE-FILE-ID`.
5. `MERGE-INPUT` reads `data/merge_a.dat` and `data/merge_b.dat` and releases each record.
6. `MERGE-OUTPUT` uses `RETURN` to write to `data/merged_output.dat`.

## How to compile and run

From the repository root:

```bash
cobc -x -o examples/13_sort_merge/sortmerge examples/13_sort_merge/main.cob
cd examples/13_sort_merge
./sortmerge
```

## Validation and tests

1. Compile and run as above.
2. Confirm output messages in the terminal:

```txt
SORT complete: data/sorted_output.dat
MERGE complete: data/merged_output.dat
```

3. Verify output files are created:

```bash
cat data/sorted_output.dat
cat data/merged_output.dat
```

4. Compare against expected baseline results:

```bash
diff -u examples/13_sort_merge/expected_output.txt <(printf "%s\n" "SORT complete: data/sorted_output.dat" "MERGE complete: data/merged_output.dat")
```

## Expected output

`examples/13_sort_merge/expected_output.txt`:

```
SORT complete: data/sorted_output.dat
MERGE complete: data/merged_output.dat
```

## Exercises

1. Add an additional field `balance` to each record and adjust sorting to use `ID` as primary key and `balance` as secondary key.
2. Add validation to `MERGE-INPUT` that skips records with empty names and logs a message.
3. Modify the program to generate an on-screen preview of the first 5 lines of `sorted_output.dat` after sort completes.

## What comes next

Continue with `examples/12_mini_projects/` to practice full project workflows and longer batch-processing examples.
