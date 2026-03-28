# EX03 - Loan Screening

## Matches lessons

- Lesson 05 - IF, Nested IF, and EVALUATE

## Objective

Create a decision program that screens a loan request and explains the result. The goal is to move beyond simple pass/fail logic and write conditions that feel like business rules.

## Prompt

Create a program that accepts:

- applicant name
- monthly income
- requested loan amount
- existing late-payment count

Use these rules:

- If late-payment count is greater than 2, the result is `REJECT`.
- Otherwise, if requested loan amount is more than 5 times monthly income, the result is `REVIEW`.
- Otherwise, if monthly income is at least 2000, the result is `APPROVE`.
- In all other cases, the result is `REVIEW`.

Display the applicant name, the result, and a short reason message that explains which rule matched.

## Input assumptions

- Applicant name fits in 20 characters.
- Monthly income fits in `PIC 9(5)`.
- Requested loan amount fits in `PIC 9(6)`.
- Late-payment count fits in one digit.

## Expected learner outcome

By finishing this exercise, you should be able to:

- translate business policy into ordered conditional logic
- decide when nested `IF` or `EVALUATE TRUE` is clearer
- store both a decision code and a human-readable explanation
- recognize that rule order changes program behavior

## Hints

- A separate field for the reason text makes the output more useful.
- Check the strongest rejection rule first so later tests do not hide it.
- `EVALUATE TRUE` is often easier to read for this style of classification.
- Use field sizes large enough for messages like `TOO MANY LATE PAYMENTS`.
