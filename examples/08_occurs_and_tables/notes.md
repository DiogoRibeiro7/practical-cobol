# Notes — Lesson 08

## Key terminology

- **OCCURS** — clause that declares a repeated data item, creating a fixed-size table (array) in memory
- **Table** — COBOL's term for an array; a fixed-size collection of identically structured elements stored contiguously in memory
- **Subscript** — the integer in parentheses used to access a specific table element, e.g., `WS-STU-GRADE(3)` accesses the third student's grade
- **Group-level OCCURS** — when the OCCURS clause is applied to a group item, each element contains multiple fields (like a record or struct), accessed as `WS-STU-NAME(2)`, `WS-STU-GRADE(2)`
- **PERFORM VARYING** — a counted loop construct that initializes a counter, tests a condition before each iteration, executes the body, and increments the counter; the COBOL equivalent of a `for` loop
- **Index** — an alternative to a subscript, declared with `INDEXED BY`; more efficient internally but not covered at this level

## Common beginner mistakes

- **Off-by-one errors (subscript starts at 1, not 0)** — the first element is `WS-GRADE(1)`, not `WS-GRADE(0)`; using subscript 0 accesses memory before the table and causes undefined behavior; this is the single most common table bug for programmers coming from C, Java, or Python
- **Exceeding table bounds** — accessing `WS-GRADE(6)` in a 5-element table reads or writes memory belonging to another variable; COBOL does not check bounds at runtime by default, so the program silently produces wrong results instead of crashing
- **Subscript field too small** — a `PIC 9` subscript only holds values 0-9; for tables with more than 9 elements, you need `PIC 99` or larger; forgetting this causes the counter to wrap around or overflow silently
- **Trying to DISPLAY the whole table at once** — `DISPLAY WS-CLASS-TABLE` outputs the raw bytes of the entire table as one string, which is unreadable; you must loop through elements and display each one individually with a subscript
- **Not initializing accumulators before the loop** — if `WS-TOTAL-GRADE` is not set to 0, it may retain a value from a previous operation; always initialize accumulators before starting a new loop
- **Confusing the OCCURS level with the field level** — in `05 WS-STUDENT OCCURS 5 TIMES` with `10 WS-STU-NAME`, the subscript goes on the field name: `WS-STU-NAME(3)`, not `WS-STUDENT(3).WS-STU-NAME`

## Fixed-size thinking

COBOL tables have a size determined at compile time. You declare `OCCURS 12 TIMES` for monthly data, `OCCURS 50 TIMES` for a batch of employee records, or `OCCURS 100 TIMES` for a product catalog. The size never changes during execution.

This feels limiting if you are used to Python lists or JavaScript arrays that grow dynamically. But in COBOL's world, the data structures are predictable:

- A year always has 12 months
- A payroll batch always has a known maximum number of employees
- A report always has a fixed number of columns

The fixed size means COBOL can allocate memory once and never worry about resizing, reallocation, or out-of-memory errors during processing. This predictability is one reason COBOL has been trusted for critical financial systems for decades.

If you do not know the exact count at compile time, the common pattern is to declare the table with a generous maximum (`OCCURS 100 TIMES`) and use a separate counter variable to track how many elements are actually populated.

## Table iteration patterns

Three common patterns for processing tables:

1. **Display all elements** — `PERFORM VARYING idx FROM 1 BY 1 UNTIL idx > count`, with a DISPLAY inside the loop
2. **Accumulate a total** — same loop, with `ADD element(idx) TO total` inside
3. **Find a value** — same loop, with `IF element(idx) > best` to track the maximum or minimum

These three patterns combine with each other. The lesson program does all three in a single pass: it displays each student, accumulates the total grade, and counts passing students — all inside one `PERFORM VARYING` loop.

## Comparison with modern languages

- `OCCURS 5 TIMES` is like `int[] grades = new int[5]` in Java, `grades = [0] * 5` in Python, or `int grades[5]` in C
- Group-level OCCURS is like an array of structs in C, a list of named tuples in Python, or an array of objects in JavaScript
- `PERFORM VARYING` is like `for (int i = 1; i <= 5; i++)` in Java/C, or `for i in range(1, 6)` in Python — but COBOL spells out every detail (start, step, end condition) instead of providing syntactic sugar
- COBOL has no built-in `sum()`, `max()`, `filter()`, or `map()` — you implement these operations yourself with a loop, an accumulator, and an IF statement
- COBOL subscripts are 1-based; most modern languages use 0-based indexing

## Where this pattern appears

- **Monthly and quarterly totals** — storing 12 monthly amounts in a table, then looping to compute annual totals, averages, or growth rates
- **Batch record processing** — loading a set of records (employees, products, transactions) into a table before sorting, filtering, or reporting
- **Lookup tables** — storing a fixed set of codes and descriptions (department codes, tax brackets, country codes) for reference during processing
- **Accumulator arrays** — tallying counts or sums by category (sales by region, defects by severity, students by grade band)
- **Report generation** — storing detail data in a table before formatting and printing, especially when subtotals or cross-references between records are needed
