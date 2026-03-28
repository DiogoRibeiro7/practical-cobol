# Picture Clause

The `PIC` clause tells COBOL what a field looks like. It is one of the most important ideas in the language because COBOL cares deeply about **data layout**.

When you define a variable, you are not only naming it. You are also describing:

- whether it holds text or numbers
- how wide it is
- whether it has decimals
- whether it can be signed

## Simple examples

```cobol
       01 WS-NAME           PIC X(20).
       01 WS-AGE            PIC 999.
       01 WS-PRICE          PIC 9(5)V99.
       01 WS-BALANCE        PIC S9(4)V99.
```

## What the symbols mean

| Symbol | Meaning | Example | Practical use |
| ------ | ------- | ------- | ------------- |
| `X` | Any character | `PIC X(20)` | names, cities, codes |
| `9` | Numeric digit | `PIC 999` | whole numbers |
| `9(n)` | Repeated numeric digit | `PIC 9(5)` | wider numbers |
| `V` | Implied decimal point | `PIC 9(3)V99` | prices, rates |
| `S` | Signed number | `PIC S9(4)` | positive or negative amounts |
| `A` | Alphabetic character | `PIC A(10)` | less common in beginner work |

## `PIC X` for text

```cobol
       01 WS-CITY PIC X(15).
```

This creates a 15-character text field. If you store `PORTO`, COBOL still reserves all 15 characters. The unused positions are spaces.

That matters when:

- displaying output
- building fixed-width files
- moving values between fields of different sizes

## `PIC 9` for numbers

```cobol
       01 WS-GRADE PIC 999.
```

This field holds exactly three digits. If the value is `42`, COBOL displays it as `042`.

That behavior surprises beginners because many modern languages would display just `42`. COBOL is showing the full field width.

## Repetition form: `9(5)`

These two are equivalent:

```cobol
       01 WS-TOTAL-A PIC 99999.
       01 WS-TOTAL-B PIC 9(5).
```

The second form is easier to read once the widths get larger.

## Implied decimals with `V`

```cobol
       01 WS-PRICE PIC 9(3)V99.
```

This means:

- 3 digits before the decimal
- 2 digits after the decimal

The decimal point is **implied**, not stored as a literal character. COBOL treats the field like a numeric value with decimal places.

If the stored value is `12345`, you should think of it as `123.45`.

This is common in business software because it gives precise control over numeric layout.

## Signed values with `S`

```cobol
       01 WS-BALANCE PIC S9(4)V99.
```

This field can hold positive or negative values. That is useful for balances, adjustments, credits, and debits.

## Display format vs storage format

The `PIC` clause often controls both storage and default display behavior. For example:

```cobol
       01 WS-SCORE PIC 999 VALUE 5.
```

When displayed, that prints as `005`.

Later lessons introduce **edited pictures** such as:

```cobol
       01 WS-DISPLAY-SCORE PIC ZZ9.
```

That format is better for reports because it suppresses leading zeros.

## A practical example

```cobol
       01 WS-EMPLOYEE-NAME PIC X(20) VALUE "ANA".
       01 WS-YEARS-SERVICE PIC 99 VALUE 7.

       PROCEDURE DIVISION.
           DISPLAY "NAME : " WS-EMPLOYEE-NAME
           DISPLAY "YEARS: " WS-YEARS-SERVICE
           STOP RUN.
```

Expected display:

```text
NAME : ANA
YEARS: 07
```

## Common beginner mistakes

## Picking a field that is too small

If the picture is too narrow, the value may not fit correctly. When a number or text field is the wrong size, the result can be confusing.

Choose widths deliberately.

## Forgetting that text fields are fixed width

`PIC X(20)` always reserves 20 characters, even if the text is short.

## Expecting modern-language formatting

COBOL does not automatically hide leading zeros or trim fields the way Python or JavaScript usually do. You control formatting by choosing the right picture.

## A good beginner rule

When defining a field, ask:

1. Is this text or numeric data?
2. How wide should it be?
3. Is it whole-number or decimal?
4. Will it ever be negative?

Those four questions cover most beginner `PIC` decisions in this repository.
