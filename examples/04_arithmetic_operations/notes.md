# Notes — Lesson 04

## Key terminology

- **ADD** — adds one or more values to a target field (e.g., `ADD A TO B`)
- **SUBTRACT** — subtracts one or more values from a target field (e.g., `SUBTRACT A FROM B`)
- **MULTIPLY** — multiplies two values (e.g., `MULTIPLY A BY B`)
- **DIVIDE** — divides one value by another (e.g., `DIVIDE A INTO B`)
- **GIVING** — stores the result of an arithmetic operation in a separate target field, preserving the original operands
- **COMPUTE** — evaluates an arithmetic expression using standard operators (+, -, *, /) and stores the result
- **Arithmetic verbs** — the collective name for ADD, SUBTRACT, MULTIPLY, DIVIDE, and COMPUTE

## Common beginner mistakes

- Forgetting GIVING and accidentally overwriting an operand — `ADD A TO B` changes B in place; use `ADD A TO B GIVING C` to keep B unchanged
- Integer truncation in division — if the result field has no decimal places (e.g., PIC 99), the fractional part is lost silently
- PIC too small for the multiplication result (overflow) — multiplying two 3-digit numbers can produce a 6-digit result; if the target PIC is only 9(3), the high-order digits are truncated

## Comparison with modern languages

- `ADD A TO B GIVING C` is like `c = a + b` in Python, Java, JavaScript, or C
- `COMPUTE WS-RESULT = A + B * C` is like `result = a + b * c` — COMPUTE lets you write expressions in a style closer to modern languages
- The verbose verb-based syntax (ADD, SUBTRACT, MULTIPLY, DIVIDE) has no direct equivalent in modern languages, which all use infix operators exclusively

## Where this pattern appears

- Payroll systems — calculating gross pay, deductions, net pay, tax withholdings
- Billing and invoicing — computing totals, discounts, taxes, and balances
- Inventory management — tracking quantities on hand, reorder calculations, cost computations
- Any time COBOL processes financial or business data, arithmetic verbs are in heavy use
