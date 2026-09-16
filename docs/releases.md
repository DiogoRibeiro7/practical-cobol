# Release Notes

## Unreleased

Development after `v1.0.0` extends the course from core language skills into intermediate batch-processing and record-contract patterns.

### Added

- lesson 13: sort and merge processing
- lesson 14: multi-file sequential input
- lesson 15: copybooks and shared record layouts
- compile-time validation for copybook-backed examples
- COBOL lint coverage for both `.cob` source files and `.cpy` copybooks

These additions are intended to bridge the gap between introductory COBOL syntax and the engineering patterns found in long-lived business systems.

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

### What was intentionally out of scope at v1.0.0

- copybooks and enterprise code reuse patterns
- indexed files and relative files
- sort/merge workflows
- large multi-file business systems

Post-v1 development can add those capabilities without changing the scope of the original release.

## v0.2

This version extended the starter repository with:

- `IF` and basic business-rule branching
- structured flow with `PERFORM`
- string and display formatting
- first sequential-file lesson with fixed-width records
- starter exercises and sample solutions

It laid the groundwork for the fuller course structure introduced in v1.
