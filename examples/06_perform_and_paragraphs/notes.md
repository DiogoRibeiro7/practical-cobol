# Notes — Lesson 06

## Key terminology

- **Paragraph** — a named block of code in the PROCEDURE DIVISION, beginning with a label in Area A followed by a period; it has no explicit end marker
- **PERFORM** — transfers control to a paragraph (or section), executes it, and returns to the statement after the PERFORM; the COBOL equivalent of a function call
- **PERFORM N TIMES** — executes a paragraph a fixed number of times, like a counted `for` loop
- **PERFORM UNTIL** — executes a paragraph repeatedly, checking the condition before each iteration, like a `while` loop with an inverted condition
- **Fall-through** — the default COBOL behavior: if execution reaches a paragraph label without a PERFORM, it enters the paragraph and continues straight through into the next one; this is why STOP RUN must appear before the first paragraph
- **STOP RUN** — terminates the program; in a paragraph-based program, it must be placed at the end of the main flow, before the first paragraph definition
- **Main flow** — the block of code at the top of the PROCEDURE DIVISION that PERFORMs paragraphs in sequence; serves as a table of contents for the program

## Common beginner mistakes

- **Forgetting STOP RUN before the first paragraph** — this is the number one PERFORM bug; without it, after the main flow finishes, execution falls through into the first paragraph and runs every paragraph sequentially, producing duplicate or unexpected output
- **Infinite loop with PERFORM UNTIL** — if the paragraph body never changes the variable tested in the UNTIL condition, the loop runs forever; always make sure the paragraph moves the program closer to the exit condition on every iteration
- **Confusing UNTIL with WHILE** — `PERFORM UNTIL X > 5` means "keep going until X becomes greater than 5", which is the same as `while (x <= 5)` in C; many beginners write the condition backward because they think in `while` terms
- **Misspelling a paragraph name** — some compilers treat a misspelled PERFORM target as a new paragraph rather than an error, leading to silent bugs where the intended code never runs
- **Modifying shared variables unexpectedly** — since all paragraphs share WORKING-STORAGE, one paragraph can accidentally overwrite a field that another paragraph depends on; use clear naming (WS-BONUS-AMOUNT, not WS-TEMP) to reduce this risk
- **Thinking paragraphs have local scope** — there is no concept of local variables in standard COBOL paragraphs; every variable is globally visible, unlike functions in Python, Java, or C

## Comparison with modern languages

- **Paragraphs vs functions** — paragraphs are like `void` functions with no parameters and no return values; `PERFORM COMPUTE-TAX` is like calling `computeTax()` in Java, but the "arguments" and "return value" are shared WORKING-STORAGE variables rather than explicit parameters
- **PERFORM vs function call** — PERFORM executes the paragraph and returns, just like a function call; the key difference is that COBOL paragraphs communicate through shared state instead of through arguments
- **PERFORM N TIMES vs for loop** — `PERFORM DO-WORK 5 TIMES` is like `for i in range(5): do_work()` in Python or `for (int i=0; i<5; i++) doWork();` in Java; COBOL does not give you an automatic loop variable — you must manage your own counter in WORKING-STORAGE
- **PERFORM UNTIL vs while loop** — `PERFORM DO-WORK UNTIL done` is like `while not done: do_work()`; the condition is inverted compared to most languages (UNTIL = stop when true, WHILE = continue while true)
- **No recursion in practice** — while some COBOL compilers allow a paragraph to PERFORM itself, recursion is not idiomatic in COBOL; iterative loops with PERFORM UNTIL are the standard pattern
- **No closures or callbacks** — you cannot pass a paragraph name as a variable or store it for later; PERFORM always targets a fixed, compile-time name

## Avoiding spaghetti logic

- **Keep the main flow short and readable** — it should be a simple sequence of PERFORM statements that reads like a business process: GET-INPUT, VALIDATE, PROCESS, REPORT
- **One task per paragraph** — if a paragraph does two unrelated things, split it; a paragraph called COMPUTE-AND-PRINT is a sign that you need two paragraphs
- **Name paragraphs after their purpose, not their position** — PARA-1, PARA-2, PARA-3 tells the reader nothing; VALIDATE-DATE, COMPUTE-TAX, PRINT-SUMMARY tells them everything
- **Never let the main flow fall through into paragraphs** — always end the main flow with STOP RUN; if you see output appearing twice, the first thing to check is whether STOP RUN is missing
- **Avoid deeply nesting PERFORM UNTIL loops** — a PERFORM UNTIL inside a PERFORM UNTIL inside another PERFORM UNTIL is hard to follow; flatten the structure by using separate paragraphs for the inner loops

## Where this pattern appears

- **Batch processing** — the canonical COBOL pattern is: PERFORM READ-RECORD, PERFORM PROCESS-RECORD UNTIL end-of-file, PERFORM PRINT-TOTALS; this structure processes millions of records in banking, insurance, and government systems
- **Report generation** — PERFORM PRINT-HEADER, PERFORM PRINT-DETAIL-LINE (looped), PERFORM PRINT-FOOTER; each paragraph handles one section of the report
- **Transaction processing** — PERFORM VALIDATE-TRANSACTION, PERFORM APPLY-TRANSACTION, PERFORM LOG-TRANSACTION; each step is a separate paragraph that can be tested and maintained independently
- **Real-world scale** — production COBOL programs often have 50+ paragraphs organized into a clear flow; the PERFORM pattern is what makes these large programs manageable
