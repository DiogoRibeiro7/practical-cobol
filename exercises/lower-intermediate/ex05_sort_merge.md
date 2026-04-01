# EX05 - Sort and Merge (lower-intermediate)

## Matches lessons

- Lesson 13 - SORT and MERGE Processing

## Objective

Create a batch program that demonstrates both `SORT` and `MERGE` with sequential files, starting from a sample data set.

## Prompt

Construct a COBOL program that:

- Reads `examples/13_sort_merge/data/sort_input.dat`, sorts by numeric `ID`, writes to `examples/13_sort_merge/data/sorted_output.dat`.
- Reads `examples/13_sort_merge/data/merge_a.dat` and `examples/13_sort_merge/data/merge_b.dat`, merges by numeric `ID`, writes to `examples/13_sort_merge/data/merged_output.dat`.
- Prints status messages after each stage.

Reuse the same file layout as the lesson: `PIC 9(3)` for `ID`, `PIC X(20)` for `NAME`.

## Input assumptions

- Each record has a 3-digit key and 20-character name.
- Input files are line sequential and already sorted for merge files.

## Expected learner outcome

By finishing this exercise, you should be able to:

- implement `SORT` with `INPUT PROCEDURE` / `OUTPUT PROCEDURE`
- implement `MERGE` with multiple input files
- use `RELEASE` and `RETURN` correctly
- manage EOF flags and sequential output files.

## Testing

- Run the lesson program in `examples/13_sort_merge`.
- Check that output messages match `examples/13_sort_merge/expected_output.txt`.
- Check that `sorted_output.dat` and `merged_output.dat` are created and ordered.
