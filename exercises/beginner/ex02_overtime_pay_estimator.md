# EX02 - Overtime Pay Estimator

## Matches lessons

- Lesson 04 - Arithmetic Operations

## Objective

Write a payroll-style calculator that separates regular hours from overtime hours and computes a final pay amount. The goal is to practice arithmetic verbs and intermediate working fields instead of squeezing all logic into one step.

## Prompt

Create a program that accepts:

- employee name
- hourly rate
- total hours worked this week

Business rules:

- Up to 40 hours are paid at the regular rate.
- Any hours above 40 are overtime hours.
- Overtime is paid at double rate to keep the arithmetic lesson focused on whole numbers.

Display:

- regular hours
- overtime hours
- regular pay
- overtime pay
- total pay

## Input assumptions

- Employee name fits in 20 characters.
- Hourly rate is a whole number from 1 to 999.
- Hours worked is a whole number from 0 to 99.
- You do not need decimal arithmetic for this exercise.

## Expected learner outcome

By finishing this exercise, you should be able to:

- separate a calculation into multiple arithmetic steps
- use `ADD`, `SUBTRACT`, and `MULTIPLY` with working-storage result fields
- preserve source values while calculating derived totals
- think in business rules instead of only in formulas

## Hints

- Create separate fields for `WS-REGULAR-HOURS` and `WS-OVERTIME-HOURS`.
- Use an `IF` to decide whether overtime exists before you do the overtime calculation.
- A clean design is: determine hours first, then compute pay amounts, then display the summary.
- If you use `GIVING`, your original input fields stay unchanged.
