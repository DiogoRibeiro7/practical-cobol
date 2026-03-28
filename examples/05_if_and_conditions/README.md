# 05 - IF and Conditions

This lesson introduces decision making in COBOL.

## Goal

Learn how to:

- compare values
- branch with `IF`
- use `ELSE`
- build simple business rules

## Program idea

The program reads a student's numeric grade and decides whether the student passed.

## Main concepts

- `IF ... ELSE ... END-IF`
- numeric comparison with `>=`
- moving text into a result field
- displaying a final classification

## Expected behavior

If the grade is 10 or above, the student passes. Otherwise, the student fails.

## How to run

```bash
cobc -x -o lesson05 main.cob
./lesson05
```

## Small exercise

Change the program so that:

- grades below 10 are `FAILED`
- grades from 10 to 13 are `PASSED`
- grades from 14 to 17 are `GOOD`
- grades from 18 to 20 are `EXCELLENT`

That extended version can later be rewritten with `EVALUATE`.
