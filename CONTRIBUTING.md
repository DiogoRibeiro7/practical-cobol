# Contributing

Thank you for contributing to Practical COBOL. This is an educational repository, so every contribution should help someone learn.

## Principles

- **Clarity over cleverness.** Write code and explanations that a beginner can follow.
- **Small and focused.** Each example should teach one concept well.
- **Real content only.** No placeholder text, no "TODO" stubs in lessons.
- **Gradual progression.** New lessons should build on what came before.
- **Standard COBOL.** Everything must compile with GnuCOBOL. No CICS, JCL, DB2, or platform-specific features.

## Lesson structure

Every lesson folder must contain these four files:

```text
examples/NN_lesson_name/
├── README.md              Lesson explanation and exercises
├── main.cob               Runnable COBOL source code
├── expected_output.txt    Exact program output
└── notes.md               Terminology, mistakes, modern comparisons
```

### README.md template

Each lesson README must include these sections in order:

1. `# NN - Lesson Title`
2. `## Objective` — one sentence
3. `## Concepts covered` — bullet list
4. `## Code` — full code listing in a `cobol` fenced block
5. `## Walkthrough` — block-by-block explanation
6. `## How to compile and run` — `cobc` command
7. `## Expected output` — in a `text` fenced block
8. `## Exercises` — at least 2 numbered exercises
9. `## What comes next` — one sentence linking to the next lesson

### notes.md template

Each notes file must include:

1. `## Key terminology`
2. `## Common beginner mistakes`
3. `## Comparison with modern languages`
4. `## Where this pattern appears`

## Code style

- Use **fixed-format** COBOL (code starts at column 8, with 6-space prefix for comment indicators).
- Use **uppercase** for all COBOL keywords and data names.
- Use the `WS-` prefix for WORKING-STORAGE variables.
- Add `*>` comments where they help a beginner understand the code.
- End every statement with a period.
- Keep programs short — ideally under 50 lines.

## Exercises and solutions

- Exercise descriptions go in the lesson README under `## Exercises`.
- Standalone exercise files go in `exercises/beginner/` or `exercises/intermediate/`.
- Worked solutions go in `exercises/solutions/` with the naming pattern `lessonNN_topic_solution.cob`.

## Pull requests

A good pull request should:

- Explain what it teaches and why
- Specify whether it adds a lesson, exercise, project, or documentation
- Follow the templates above
- Include updated `expected_output.txt` if the code changed
- Not break existing lessons

## Quick contributor checklist

Before opening a pull request, confirm the following:

- [ ] The lesson or exercise is aligned with the educational goals and progression.
- [ ] `examples/NN_lesson_name` includes `README.md`, `main.cob`, `expected_output.txt`, and `notes.md`.
- [ ] If you’re adding an exercise, include both the prompt and solution under `exercises/`.
- [ ] Code compiles with `scripts/check_examples.sh` locally.
- [ ] Documentation is updated (`README`, `docs/`, or `CONTRIBUTING.md`) as needed.
- [ ] The PR describes what changed, why, and how to verify it.

## Ideas for contributions

- New exercises for existing lessons
- File-processing examples and mini projects
- Diagrams explaining COBOL concepts
- Comparisons with other programming languages
- Setup instructions for additional platforms
- Translations of lesson content (in separate branches)
