# 06 - PERFORM and Paragraphs

This lesson introduces one of the most important COBOL ideas: structuring logic into named paragraphs and calling them with `PERFORM`.

## Goal

Learn how to:

- organize a COBOL program into paragraphs
- reuse logic with `PERFORM`
- separate input, processing, and output

## Program idea

The program reads two numbers, computes their sum, and prints the result. Instead of writing everything inline, it splits the program into three paragraphs.

## Main concepts

- paragraph names
- `PERFORM paragraph-name`
- procedural flow in COBOL
- simple separation of concerns

## How to run

```bash
cobc -x -o lesson06 main.cob
./lesson06
```

## Why this matters

In larger COBOL systems, paragraphs make the business flow easier to read. They are an important step toward batch-style programs that read records, process them, and write reports.
