# Coding standards

Review and audit jobs read this file in full. An earlier rule wins over a later one. This file holds only rules a linter or type checker cannot enforce. Put every other rule in the linter.

## Out of scope

Ace jobs skip these paths when they review, audit, or edit:

- Generated code
- Vendored code
- Lockfiles

## Trust boundaries

Parties the project trusts. Treat calls between them as authorized.

<TRUST_BOUNDARIES>

## Rules

- Follow the patterns the codebase already uses. A second way to do the same job needs a reason.
- Use the glossary terms from the root agents file for names. One name per concept.
- Validate input where it enters the system: requests, files, environment, third-party responses. Trust it after that.
- Handle an error where something can be done about it. Log or surface every error you catch.
- Delete dead code, commented-out code, and unused exports. Version control keeps the history.
- A comment says why, not what.

## Tests

- Test behavior through the public interface.
- A test must be able to fail. A test that only checks a mock returns what it was told to return is tautological.
- One behavior per test. The test name says the behavior.

## Smells

Judgement calls. Fix one only when the better shape is obvious and behavior stays the same.

- A boolean argument that switches what a function does. Split it into two functions.
- More than four parameters. Pass one object.
- Deep nesting. Return early.
- A magic number or string used in more than one place. Name it.
- The same logic in three or more places. Extract it.
