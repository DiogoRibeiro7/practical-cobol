# Practical COBOL

A hands-on course that moves from core COBOL syntax to practical batch processing, file-driven business programs, and reusable record layouts.

## Start Here

If you are new to the repository, follow this order:

1. Read [docs/setup.md](docs/setup.md) and make sure `cobc` works.
2. Run [examples/00_hello_world/README.md](examples/00_hello_world/README.md).
3. Continue through the core lesson sequence in `examples/` from 00 to 11.
4. Practice with [exercises/README.md](exercises/README.md).
5. Move to [examples/12_mini_projects/README.md](examples/12_mini_projects/README.md) and then [projects/README.md](projects/README.md).
6. Continue with lessons 13 to 17 for sort/merge processing, multi-file input, copybooks, indexed access, and relative files.

## Learning path

| Lesson | Topic | What you learn |
| ------ | ----- | -------------- |
| 00 | Hello World | Minimum COBOL program, `DISPLAY`, `STOP RUN` |
| 01 | Program Structure | Divisions, `WORKING-STORAGE`, variables |
| 02 | Variables and PIC | `PIC X`, `PIC 9`, field widths, data types |
| 03 | MOVE, ACCEPT, DISPLAY | User input and data movement |
| 04 | Arithmetic Operations | COBOL arithmetic verbs |
| 05 | IF and Conditions | Business-rule branching |
| 06 | PERFORM and Paragraphs | Structured procedural flow |
| 07 | Strings and Formatting | Edited picture clauses and output formatting |
| 08 | OCCURS and Tables | Tables and loops |
| 09 | Sequential Files | Sequential file I/O and batch totals |
| 10 | Writing Sequential Files | Read-transform-write processing |
| 11 | File-Based Summary Report | Classification, accumulators, reporting |
| 12 | Mini Projects | Project bridge and capstone guidance |
| 13 | Sort and Merge Processing | Sort and merge business records |
| 14 | Multi-file Sequential Input | Process multiple input streams |
| 15 | Copybooks and Shared Layouts | Shared fixed-width record contracts |
| 16 | Indexed Files | Direct keyed lookup, `RECORD KEY`, and `FILE STATUS` |
| 17 | Relative Files | Direct access by relative record number and sparse slots |

## Intermediate engineering track

Lessons 13 onward deliberately move beyond syntax into patterns found in long-lived business systems:

- sort/merge workflows
- multiple input streams
- shared copybooks
- explicit control totals
- indexed master records
- relative record files
- direct keyed and positional reads
- observable I/O state through `FILE STATUS`

The goal is not to imitate a specific mainframe stack. It is to make the underlying data-processing and reliability patterns inspectable with GnuCOBOL.

## Quick navigation

- [Lesson 13 — Sort/Merge](examples/13_sort_merge/README.md)
- [Lesson 14 — Multi-file Input](examples/14_multi_file/README.md)
- [Lesson 15 — Copybooks](examples/15_copybooks/README.md)
- [Lesson 16 — Indexed Files](examples/16_indexed_files/README.md)
- [Lesson 17 — Relative Files](examples/17_relative_files/README.md)
- [Projects](projects/README.md)
- [Exercises](exercises/README.md)
- [Setup](docs/setup.md)

## Installing GnuCOBOL

See [docs/setup.md](docs/setup.md). On Debian/Ubuntu:

```bash
sudo apt update && sudo apt install gnucobol
cobc -V
```

## Validation

```bash
bash scripts/compile_beginner_examples.sh
bash scripts/check_examples.sh
bash scripts/check_exercises.sh
bash scripts/lint_cobol.sh
bash scripts/check_links.sh
```

GitHub Actions runs the compile and quality checks on pull requests and on pushes to `develop` and `main`.

## Repository structure

```text
practical-cobol/
├── examples/          Step-by-step lessons (00 through 17)
├── exercises/         Structured practice with worked solutions
├── projects/          Capstone-style business programs
├── docs/              Setup and reference documentation
├── scripts/           Compile, lint, and validation helpers
└── assets/            Diagrams and supporting files
```

## Projects

The capstone track includes payroll and bank-ledger processing, with additional project scaffolds under [projects/](projects/README.md).

The next major development target is a multi-program reconciliation system rather than additional isolated language lessons.

## Release status

The repository has a `v1` educational baseline and an active post-v1 intermediate engineering track on `develop`. See [docs/releases.md](docs/releases.md).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
