## Key terminology

- SORT: COBOL verb that orders records based on a key and writes them to an output procedure.
- MERGE: COBOL verb that merges two or more already-sorted inputs into one sorted output.
- RELEASE: puts a WORKING-STORAGE record into the sort/merge internal work area.
- RETURN: retrieves the next sorted/merged record from the internal work area.
- INPUT PROCEDURE: paragraph used by `SORT`/`MERGE` to obtain input records.
- OUTPUT PROCEDURE: paragraph that receives sorted/merged records from `SORT`/`MERGE`.

## Common beginner mistakes

- Forgetting to use `RELEASE` in the input procedure; then no records are sorted/merged.
- Forgetting to use `RETURN` in the output procedure; then nothing is written out.
- Using unsorted files in a `MERGE`, which can produce incorrect output.
- Not resetting the end-of-file flags before starting each step.

## Comparison with modern languages

- In Python, `sorted(data, key=lambda x: x[0])` is conceptually similar to COBOL `SORT ... ON ASCENDING KEY`.
- In SQL, `ORDER BY` sorts result rows; COBOL `SORT` writes sorted records to a file.
- `MERGE` mirrors `heapq.merge` or SQL `UNION ALL` + `ORDER BY` when inputs are already sorted.

## Where this pattern appears

- Batch payroll systems sorting employee records before tax calculations.
- Reports that merge separate regional files into a unified master list.
- Legacy mainframe jobs requiring stable and large-file sorting without full in-memory data.
