# Practical COBOL

A hands-on course to learn COBOL from zero to practical business-style programs.

## Start Here

If you are new to the repository, follow this order:

1. Read [docs/setup.md](docs/setup.md) and make sure `cobc` works.
2. Run [examples/00_hello_world/README.md](examples/00_hello_world/README.md).
3. Continue through the lesson sequence in `examples/` from 00 to 11.
4. Practice with [exercises/README.md](exercises/README.md).
5. Move to [examples/12_mini_projects/README.md](examples/12_mini_projects/README.md) and then [projects/README.md](projects/README.md).

If you only want the shortest path into the material, start with lesson 00, then work forward in order without skipping.

## Who this is for

This repository is for developers, students, and engineers who want to learn COBOL in a modern, structured way. No prior COBOL experience is required. If you have written code in Python, Java, C, or JavaScript, you have everything you need to get started.

## What you will learn

By working through the lessons in order, you will learn to:

- Write and run COBOL programs with GnuCOBOL
- Understand the division-based structure of COBOL
- Define variables with picture clauses (`PIC`)
- Read user input and move data between fields
- Perform arithmetic with COBOL verbs
- Make decisions with `IF` / `ELSE` / `END-IF`
- Organize programs with paragraphs and `PERFORM`
- Format output with edited picture clauses
- Store data in tables with `OCCURS`
- Read and process sequential files
- Build small business-style reporting programs

## Suggested Study Order

Use the repository in four passes:

1. **Core syntax**
   Lessons 00 to 04. Learn program structure, fields, input, output, and arithmetic.
2. **Control flow and formatting**
   Lessons 05 to 08. Learn decisions, paragraphs, loops, and report-style output.
3. **File processing**
   Lessons 09 to 11. Learn sequential files, output files, and summary reports.
4. **Applied practice**
   Use [exercises/README.md](exercises/README.md), then continue to [projects/README.md](projects/README.md).

Recommended checkpoints:

- After lesson 04, start the `beginner` exercises.
- After lesson 06, add the `lower-intermediate` exercises.
- After lesson 09, begin the `project-prep` exercises.
- After lesson 11, start with the payroll project.

## Learning path

Start at lesson 00 and work through them in order. Each lesson builds on the previous one.

| Lesson | Topic | What you learn |
| ------ | ----- | -------------- |
| 00 | Hello World | Minimum COBOL program, `DISPLAY`, `STOP RUN` |
| 01 | Program Structure | Divisions, `WORKING-STORAGE`, variables |
| 02 | Variables and PIC | `PIC X`, `PIC 9`, field widths, data types |
| 03 | MOVE, ACCEPT, DISPLAY | User input, data movement between fields |
| 04 | Arithmetic Operations | `ADD`, `SUBTRACT`, `MULTIPLY`, `DIVIDE`, `GIVING` |
| 05 | IF and Conditions | `IF` / `ELSE` / `END-IF`, comparisons, business rules |
| 06 | PERFORM and Paragraphs | Named paragraphs, `PERFORM`, program organization |
| 07 | Strings and Formatting | Edited picture clauses, display formatting |
| 08 | OCCURS and Tables | Arrays with `OCCURS`, `PERFORM VARYING` loops |
| 09 | Sequential Files | File I/O, record processing, batch totals |
| 10 | Writing Sequential Files | `OPEN OUTPUT`, `WRITE`, read-transform-write |
| 11 | File-Based Summary Report | Classification, accumulators, formatted reports |
| 12 | Mini Projects | Project bridge and capstone guidance |

Quick navigation:

- [Lesson 00](examples/00_hello_world/README.md)
- [Lesson 05](examples/05_if_and_conditions/README.md)
- [Lesson 09](examples/09_sequential_files/README.md)
- [Lesson 11](examples/11_summary_report/README.md)
- [Mini Projects](examples/12_mini_projects/README.md)
- [Projects Hub](projects/README.md)
- [Exercises](exercises/README.md)
- [Reference Docs](docs/)

## Installing GnuCOBOL

This repository uses **GnuCOBOL** as the compiler. See [docs/setup.md](docs/setup.md) for detailed instructions.

Quick install:

```bash
# Debian / Ubuntu
sudo apt update && sudo apt install gnucobol

# Fedora
sudo dnf install gnucobol

# macOS (Homebrew)
brew install gnu-cobol
```

Verify the installation:

```bash
cobc -V
```

On Windows, use WSL with Ubuntu or an MSYS2-based GnuCOBOL environment.

## Running the examples

Each lesson lives in its own folder under `examples/`. Every folder contains:

- `README.md` — lesson explanation, code walkthrough, and exercises
- `main.cob` — the COBOL source code
- `expected_output.txt` — what the program should print
- `notes.md` — terminology, common mistakes, and comparisons with modern languages

To compile and run any lesson:

```bash
cd examples/00_hello_world
cobc -x -o hello main.cob
./hello
```

Or use the helper script from the repository root:

```bash
./scripts/run_example.sh examples/00_hello_world
```

To compile a lesson without running it:

```bash
./scripts/compile_lesson.sh examples/04_arithmetic_operations
```

## Exercises and solutions

The repository also includes a structured exercise track under `exercises/`. It is divided into three levels:

- `beginner`
- `lower-intermediate`
- `project-prep`

Start with [exercises/README.md](exercises/README.md) for the full exercise index and lesson mapping. Each exercise includes an objective, input assumptions, expected learner outcome, and hints. Worked answers live under `exercises/solutions/` and mirror the same level structure.

## Projects

The repository now includes a small capstone track under [projects/README.md](projects/README.md).

- [projects/payroll/README.md](projects/payroll/README.md) is the best first project after lesson 11.
- [projects/bank-ledger/README.md](projects/bank-ledger/README.md) is the next best follow-up.
- The remaining project folders are intentionally lighter-weight scaffolds for further practice.

## Maintainer validation

Maintainers can validate lessons with a few small scripts:

```bash
# Compile one lesson
./scripts/compile_lesson.sh examples/04_arithmetic_operations

# Compile and run one lesson
./scripts/run_example.sh examples/00_hello_world

# Compile the early lesson set
./scripts/compile_beginner_examples.sh

# Compile every example with a main.cob file
./scripts/check_examples.sh
```

The GitHub Actions workflow uses the same idea on Ubuntu: install GnuCOBOL, compile the beginner lessons, then compile every example program. It is intentionally simple and fails as soon as a compile step breaks.

## Repository structure

```text
practical-cobol/
├── examples/          Step-by-step lessons (00 through 12)
├── exercises/         Structured practice track with worked solutions
├── projects/          Capstone-style programs and guided project scaffolds
├── docs/              Setup guide and concept references
├── scripts/           Helper scripts for compiling and checking
└── assets/            Diagrams and supporting files
```

## Release status

This repository is prepared as a `v1` educational release. See [docs/releases.md](docs/releases.md) for the release summary and scope.

## Why COBOL?

COBOL powers critical systems in banking, insurance, government, and large enterprises. Many online resources jump straight into mainframe-specific tooling. This repository focuses on the language itself and gradually builds toward the business-data mindset that made COBOL important.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[MIT](LICENSE)
