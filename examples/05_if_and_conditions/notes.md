# Notes — Lesson 05

## Key terminology

- **IF** — begins a conditional statement that tests a condition and branches accordingly
- **ELSE** — the alternative branch, executed when the IF condition is false
- **END-IF** — explicitly terminates an IF block (introduced in COBOL-85 to replace the older period-delimited style)
- **EVALUATE** — COBOL's multi-way branching statement, equivalent to `switch/case` or `if/elif/else` chains
- **EVALUATE TRUE** — tests each `WHEN` condition as a Boolean expression; the first true condition wins
- **EVALUATE variable** — compares a variable's value against each `WHEN` value, like `switch(variable)` in C or Java
- **WHEN** — a branch inside an EVALUATE block
- **WHEN OTHER** — the default/fallback branch inside EVALUATE (like `default` in a switch or `else` at the end of a chain)
- **END-EVALUATE** — terminates an EVALUATE block
- **Comparison operators** — `=`, `>`, `<`, `>=`, `<=`, `NOT =` (also available as English words: `EQUAL TO`, `GREATER THAN`, `LESS THAN`)
- **Figurative constant** — a built-in COBOL name like `SPACES` (fills with blanks), `ZEROS` (fills with zeros), or `HIGH-VALUES`/`LOW-VALUES` (used in sorting and comparisons)
- **88-level condition name** — a named Boolean condition attached to a variable (e.g., `88 IS-PASS VALUES 50 THRU 100`), allowing you to write `IF IS-PASS` instead of `IF SCORE >= 50`

## Common beginner mistakes

- **Forgetting END-IF** — without it, the IF scope is terminated by the next period, which can cause statements that look like they are inside the IF to actually run unconditionally; this is one of the most common sources of subtle bugs in COBOL
- **Mismatched END-IF count in nested IFs** — each IF needs its own END-IF; if you have three nested IFs, you need three END-IFs; a missing one causes a compile error that can be confusing to debug
- **Nesting too deeply instead of using EVALUATE** — more than two levels of nested IF becomes hard to read and maintain; switch to `EVALUATE TRUE` for three or more branches
- **Forgetting WHEN OTHER** — if no WHEN branch matches in an EVALUATE and there is no WHEN OTHER, nothing happens and the result field keeps its old value; always include WHEN OTHER as a safety net
- **Wrong order of WHEN conditions in EVALUATE TRUE** — COBOL checks WHEN conditions top to bottom and takes the first match; if you test `>= 50` before `>= 90`, everything above 50 matches the first branch and the `>= 90` branch never runs; always order from most restrictive to least restrictive
- **Expecting EVALUATE to fall through like C switch** — unlike C's switch/case, COBOL's EVALUATE does not fall through; only the matching WHEN branch executes, and then control moves past END-EVALUATE; there is no `break` statement because none is needed

## Comparison with modern languages

- `IF / ELSE / END-IF` is like `if / else` with braces in Java, C, or JavaScript, or `if / else` with indentation in Python
- `EVALUATE TRUE` is like Python's `if / elif / elif / else` chain or a series of `else if` in C and Java
- `EVALUATE variable` is like `switch(variable)` in C/Java/JavaScript, `match variable` in Python 3.10+, or `case variable` in Ruby
- `WHEN OTHER` is like `default:` in switch or the final `else` in an if/elif chain
- COBOL has no ternary operator (no `condition ? a : b`); you always use IF or EVALUATE
- 88-level condition names have no direct equivalent in most languages; the closest analog is an enum or a named constant, but 88-levels are more powerful because they attach directly to a data field and can specify ranges (`VALUES 10 THRU 20`)

## When to choose IF vs EVALUATE

- **Use IF** for simple true/false decisions and when you need compound conditions with `AND` / `OR` (EVALUATE cannot combine conditions with logical operators inside a single WHEN)
- **Use EVALUATE TRUE** when you have three or more range-based conditions to test against a single variable
- **Use EVALUATE variable** when you are matching exact values (day of week, department code, transaction type)
- **Use 88-level names** when the same condition is tested in multiple places throughout the program; naming the condition makes the code read like a business rule

## Where this pattern appears

- **Business rule evaluation** — determining discount tiers, tax brackets, insurance categories, approval levels
- **Record classification** — routing input records to different processing logic based on type codes, status flags, or date ranges
- **Input validation** — checking whether fields are within acceptable ranges before processing
- **Report filtering** — selecting which records to include or exclude in output based on thresholds or categories
- **Menu-driven programs** — using EVALUATE on a user's menu selection to dispatch to the correct paragraph
