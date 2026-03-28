# EX04 - Shift Production Tracker

## Matches lessons

- Lesson 06 - PERFORM and Paragraphs

## Objective

Organize a repeated-entry program into paragraphs and use `PERFORM UNTIL` to process several production counts. The goal is to practice COBOL's structured flow rather than writing one large procedure block.

## Prompt

Create a program for a factory supervisor. The program should:

1. Ask how many shifts will be entered.
2. Repeatedly accept a units-produced value for each shift.
3. Keep a running total.
4. Count how many shifts produced at least 100 units.
5. Display the total shifts, total units, and count of strong shifts.

Your design must use named paragraphs for at least:

- initialization
- reading one shift
- processing one shift
- final display

Use `PERFORM UNTIL` to control the loop.

## Input assumptions

- Shift count is from 1 to 9.
- Units produced per shift fits in `PIC 9(4)`.
- Total units should fit in at least `PIC 9(5)`.

## Expected learner outcome

By finishing this exercise, you should be able to:

- break a small program into meaningful paragraphs
- manage counters and totals across a loop
- use `PERFORM UNTIL` with a manually updated index
- keep the main flow readable and close to plain English

## Hints

- Keep the main PROCEDURE DIVISION short; it should read like a list of steps.
- One useful pattern is `READ-SHIFT`, then `PROCESS-SHIFT`, then increment the counter.
- A shift producing 100 units or more counts as strong.
- Remember that the `UNTIL` condition is the stop condition, not the continue condition.
