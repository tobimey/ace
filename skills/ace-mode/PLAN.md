# Plan and Prototype

The playbooks that settle what to build before any code changes.

## Plan

1. Run `ace-grill` until no material decision remains open. Stop if grill stops after a verdict or with no direction picked. When a decision turns on running code (such as speed or layout feel), run Prototype below and bring its result to that question.
2. When the user asked to build, implement, or fast-track and grill opened no sub-tickets, go straight to step 3. Otherwise ask one question per [QUESTIONS.md](QUESTIONS.md): start a fresh session to implement (recommended for work bigger than `S`, sub-tickets, or waiting work), or implement here now (recommended for `S` work)? Wait for the answer.
3. Implement here: run Build in [BUILD.md](BUILD.md) with the settled plan or ticket, and hand off as Build. Fresh session: stop and give the command (`Implement <ticket or plan path>`).

## Prototype

1. Write the question and the result that settles it, in two lines.
2. Build the smallest sketch that shows that result, on a throwaway branch or in a scratch folder. It needs no tests, review, or coding standards.
3. Run it and look at the result. Try each option the same way.
4. Answer with what you saw and the choice it points to. Delete the sketch, unless the user wants to keep it.
