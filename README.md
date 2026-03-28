# Practical COBOL

A hands-on repository to learn COBOL from the basics to practical business-style programs.

This repository is designed for developers, students, and engineers who want to understand COBOL in a modern and structured way. It focuses on short lessons, exercises, and mini projects that show how COBOL programs are written and how they process data.

## What you will learn

- COBOL program structure
- Variables and picture clauses
- Input and output with `ACCEPT` and `DISPLAY`
- Arithmetic operations
- Conditions with `IF`
- Reusable logic with paragraphs and `PERFORM`
- String formatting basics
- Sequential file processing
- Business-style data transformation and reporting

## Current scope

This version includes the first guided teaching path, from `Hello, World!` up to a first sequential-file example.

Implemented lessons:

- `00_hello_world`
- `01_program_structure`
- `02_variables_and_pic`
- `03_move_accept_display`
- `04_arithmetic_operations`
- `05_if_and_conditions`
- `06_perform_and_paragraphs`
- `07_strings_and_formatting`
- `09_sequential_files`

Folders already scaffolded for the next iterations:

- `08_occurs_and_tables`
- `10_mini_projects`
- `projects/`
- `exercises/`

## Repository structure

```text
practical-cobol/
├─ examples/     # Step-by-step lessons
├─ exercises/    # Practice tasks
├─ projects/     # Larger business-style programs
├─ docs/         # Setup and concept explanations
├─ scripts/      # Small helper scripts
└─ assets/       # Diagrams and supporting files
```

## How to use this repository

1. Read `docs/setup.md`
2. Start with `examples/00_hello_world`
3. Move through the lessons in order
4. Compare your output against `expected_output.txt`
5. Solve the matching exercises in `exercises/`

## Running examples

With GnuCOBOL installed, a typical flow is:

```bash
cd examples/00_hello_world
cobc -x -o hello main.cob
./hello
```

For the file-processing lesson:

```bash
cd examples/09_sequential_files
cobc -x -o sales_report main.cob
./sales_report
```

## Why this repository exists

COBOL is still important in banking, insurance, public administration, and large enterprise systems. Many explanations online jump too quickly into legacy platform details. This repository starts with the language itself and then moves gradually into the business-data mindset that made COBOL important.

## Suggested GitHub command

```bash
gh repo create practical-cobol \
  --public \
  --source=. \
  --remote=origin \
  --push \
  --description "Hands-on COBOL lessons, exercises, and mini projects for learning practical business-oriented COBOL."
```
