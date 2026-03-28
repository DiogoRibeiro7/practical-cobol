# Picture clause

The `PIC` clause describes how data is stored and interpreted.

## Examples

```cobol
01 USER-NAME        PIC X(20).
01 AGE              PIC 999.
01 PRICE            PIC 9(5)V99.
01 SIGNED-AMOUNT    PIC S9(4)V99.
```

## Meaning

- `X` means alphanumeric character storage
- `9` means numeric digit
- `V` means implied decimal point
- `S` means signed numeric field

## Why it matters

COBOL is strongly shaped by data layout. The picture clause is one of the core language ideas because it ties business meaning to storage structure.
