# Notes — Lesson 02

## Key terminology

- **PIC clause** (PICTURE clause) — defines the type, size, and format of a data item
- **Alphanumeric (X)** — PIC X holds any character (letters, digits, symbols, spaces); PIC X(20) means 20 characters
- **Numeric (9)** — PIC 9 holds a single digit 0-9; PIC 9(5) means five digits
- **Field width** — the exact number of character positions a variable occupies; COBOL fields are always fixed-width
- **Leading zeros** — numeric PIC fields display leading zeros by default (e.g., PIC 999 with value 7 displays as 007)
- **Space padding** — alphanumeric PIC fields are padded with trailing spaces if the stored value is shorter than the field width

## Common beginner mistakes

- Confusing X and 9 — storing text in a PIC 9 field or storing numbers in a PIC X field causes unexpected results or data errors
- Wrong field sizes causing truncation — if a value is longer than the PIC width, COBOL silently truncates it (alphanumeric from the right, numeric from the left)
- Forgetting that PIC 999 shows leading zeros — beginners expect 42 to display as "42" but it displays as "042"; use edited pictures (lesson 07) for formatted output

## Comparison with modern languages

- PIC fields are like typed variables with a fixed width — Python and JavaScript have dynamic types with no size limit, while COBOL requires you to declare exactly how many characters or digits a field holds
- In Java, the closest concept is a fixed-length `char[]` or a formatted `String`; in C, it is like a fixed-size `char` array or an integer with a known maximum number of digits
- There is no automatic type coercion or resizing — the programmer must plan field sizes carefully

## Where this pattern appears

- Every COBOL variable needs a PIC clause — there are no untyped or dynamically sized variables in COBOL
- Record layouts in files use PIC extensively to define exactly how each field maps to bytes in a file record (e.g., a customer record with PIC X(30) for name, PIC 9(10) for account number)
- Copybooks (shared data definitions) are full of PIC clauses that multiple programs include
