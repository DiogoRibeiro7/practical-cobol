# Release Notes

## v1.0.0

`practical-cobol` now ships as a coherent self-study course rather than a loose set of example folders.

### Included in v1

- lesson path from `00_hello_world` through `11_summary_report`
- project bridge in `12_mini_projects`
- structured exercise system with level-based prompts and worked solutions
- beginner-friendly reference docs under `docs/`
- simple maintainer scripts for compiling lessons and examples
- GitHub Actions compile-check workflow
- completed capstone-style projects for payroll and bank ledger reporting

### What v1 is meant to do well

- teach core COBOL syntax and structure in a practical order
- build confidence with business-style data handling
- move learners from tiny programs to file-driven reports
- stay small enough to be consistent and maintainable

### What is intentionally still out of scope

- copybooks and enterprise code reuse patterns
- indexed files and relative files
- sort/merge workflows
- large multi-file business systems

That work belongs in a later release once the current teaching path is fully stable.

## v0.2

This version extended the starter repository with:

- `IF` and basic business-rule branching
- structured flow with `PERFORM`
- string and display formatting
- first sequential-file lesson with fixed-width records
- starter exercises and sample solutions

It laid the groundwork for the fuller course structure introduced in v1.
