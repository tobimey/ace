# Architecture

A module shape that makes change costly. Use the terms of `ace-codebase-design`.

## Find

- The same job in fewer layers, files, or types, at about a quarter of the size.
- A shallow module: its interface is nearly as complex as its implementation, or callers reach past it into internals. Apply the deletion test.
- One concept spread over many small modules, so understanding or changing it means moving between them.
- The same logic repeated across callers, where one deeper module would hold it once.
- Logic in the wrong module: another feature, a shared module, or a package already in play.
- A leaking seam: two modules that reach into each other's internals.
- Logic split into small functions only so they can be tested, while the bugs sit in how callers combine them.
- A speculative layer, a seam with one adapter, or a second pattern beside one that already works.

## Belongs elsewhere

- A break of a rule or smell the coding standards list is a standards finding.
- Wrong behavior is logic. Runtime cost with correct behavior is performance.

## Drop

- A shape a recorded decision asks for, such as an ADR or a coding standard, unless its reason no longer holds.
- Folder placement, naming, or style alone.
- A redesign that makes no named change, bug fix, or test easier.
- Code the commit history shows unchanged for a long time, unless a bug traces to it.

## Severity

Architecture has no Critical.

- **High.** An area that changes often, where each change touches several modules, or where logic repeated across callers has already drifted apart or caused a bug.
- **Medium.** A shallow module, leaking seam, or speculative layer in new code or on a path that changes now and then.
- **Low.** A real improvement on code that rarely changes.

Ties go to the area changed most recently.
