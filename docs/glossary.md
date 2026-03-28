# Glossary

This glossary explains common COBOL terms used throughout the lessons and exercises. The definitions are intentionally practical rather than academic.

## `ACCEPT`

Reads input into a field. In beginner programs, it usually reads from the keyboard.

## `ADD`

COBOL verb for addition.

## `ASSIGN TO`

Part of a file definition that connects a logical COBOL file name to a real file path.

## `AT END`

Branch of a `READ` statement that runs when there are no more records in the file.

## Batch processing

Processing many records in sequence, usually from a file, without user interaction for each one.

## `cobc`

The GnuCOBOL compiler command used throughout this repository.

## Condition

A true-or-false test, such as `WS-SCORE >= 50`.

## `DATA DIVISION`

The part of a COBOL program where variables and record layouts are declared.

## Edited picture

A `PIC` clause used for display formatting, such as suppressing leading zeros.

## `END-IF`

Scope terminator that closes an `IF` block.

## `END-PERFORM`

Scope terminator that closes an inline `PERFORM` loop.

## `END-READ`

Scope terminator that closes a `READ` statement.

## `ENVIRONMENT DIVISION`

The part of a COBOL program that describes external resources such as files.

## `EVALUATE`

COBOL's multi-branch decision statement. It often fills the role of `else if` chains or `switch`.

## `FD`

Short for File Description. Used in the `FILE SECTION` to define the layout of one file record.

## File section

The part of the `DATA DIVISION` where file record layouts are declared.

## Flag

A small field used to represent a state, such as end-of-file being `Y` or `N`.

## `GIVING`

Clause that stores an arithmetic result in a target field without overwriting the original operands.

## Group item

A COBOL data item made of subordinate fields. Useful for records and table entries.

## `IDENTIFICATION DIVISION`

The part of a COBOL program that identifies the program, including `PROGRAM-ID`.

## Implied decimal

A decimal position defined by `V` in a `PIC` clause. The decimal point is understood rather than stored as a literal character.

## Level number

The numeric prefix used in data declarations, such as `01`, `05`, or `10`. It shows structure and hierarchy.

## `LINE SEQUENTIAL`

A file organization where each record is one line of text.

## `MOVE`

COBOL verb for assigning or copying data from one field to another.

## `NOT AT END`

Branch of a `READ` statement that runs when a record was read successfully.

## `OCCURS`

Clause that defines a repeated set of fields, similar to an array or table.

## Paragraph

A named block of logic in the `PROCEDURE DIVISION`. Often called with `PERFORM`.

## `PERFORM`

COBOL verb used to execute a paragraph or loop through a block of statements.

## `PIC`

Short for picture clause. Describes the type and shape of a field.

## Procedure division

The executable part of a COBOL program.

## Program-ID

The program name declared in the `IDENTIFICATION DIVISION`.

## Record

A single structured unit of data, often representing one line in a file.

## `READ`

COBOL verb used to fetch the next record from an input file.

## Sequential file

A file processed from beginning to end, one record at a time.

## `STOP RUN`

Statement that ends program execution.

## Subscript

The index used to access one element of an `OCCURS` table, such as `WS-SCORE(3)`.

## Table

COBOL term for an array-like structure, usually declared with `OCCURS`.

## `WORKING-STORAGE SECTION`

The most common data section for program variables that live during the whole run.

## `WRITE`

COBOL verb used to output a record to a file.
