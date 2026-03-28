# EX05 - Training Scores Table

## Matches lessons

- Lesson 08 - OCCURS and Tables
- Lesson 05 - IF, Nested IF, and EVALUATE

## Objective

Create a small in-memory report that stores trainee data in a table, classifies each score, and prints a summary. The goal is to practice `OCCURS`, subscripts, and loop-based reporting.

## Prompt

Create a program that stores exactly 5 trainee records in a table. Each record should include:

- trainee name
- assessment score

Populate the table with your own sample data in WORKING-STORAGE. Then loop through the table and display each trainee with one of these labels:

- `DISTINCTION` for score 85 and above
- `PASS` for score 60 to 84
- `RETRY` for score below 60

Also compute and display:

- total score
- average score
- distinction count
- pass count
- retry count

## Input assumptions

- Each trainee name fits in 20 characters.
- Each score fits in `PIC 999`.
- Average may use integer division for this exercise.

## Expected learner outcome

By finishing this exercise, you should be able to:

- declare a group-level table with `OCCURS`
- iterate over a table with `PERFORM VARYING`
- combine table access with classification logic
- produce both detail rows and summary totals from the same loop

## Hints

- A table of groups is easier to manage than separate parallel tables for this exercise.
- Use one subscript field such as `WS-IDX`.
- `EVALUATE TRUE` is a good fit for the three score bands.
- Keep the summary counters separate so the final report is easy to read.
