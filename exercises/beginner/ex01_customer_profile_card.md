# EX01 - Customer Profile Card

## Matches lessons

- Lesson 02 - Variables and PIC
- Lesson 03 - MOVE, ACCEPT, DISPLAY

## Objective

Build a small COBOL program that reads fixed-width customer information and prints a simple profile card. The goal is to practice choosing sensible `PIC` clauses and moving input into well-named working-storage fields.

## Prompt

Create a program that asks for:

- customer name
- city
- account tier code
- years as a customer

Then display a formatted summary like this:

```text
CUSTOMER PROFILE
Name : ANA SILVA
City : PORTO
Tier : GOLD
Years: 07
```

You should store each input in its own field and choose `PIC` clauses that fit the data cleanly.

## Input assumptions

- The customer name fits in 20 characters.
- The city fits in 15 characters.
- The tier code fits in 6 characters, such as `SILVER` or `GOLD`.
- Years as a customer is a whole number from 0 to 99.

## Expected learner outcome

By finishing this exercise, you should be able to:

- declare text and numeric fields with appropriate `PIC` clauses
- use `ACCEPT` to gather user input
- understand how fixed-width fields affect displayed output
- produce readable output with multiple `DISPLAY` statements

## Hints

- `PIC X(n)` is the right starting point for name, city, and tier code.
- `PIC 99` is enough for a two-digit whole number.
- If the output looks misaligned, inspect the field widths rather than immediately changing the `DISPLAY` text.
- Keep the program simple; this exercise is about data definition discipline.
