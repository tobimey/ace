# Coding standards

Review and audit jobs read this file in full. An earlier rule wins over a later one. A rule a linter or type checker can enforce does not belong here. Add it to the linter instead.

## Out of scope

No ace job reviews, audits, or edits these paths:

- Generated code
- Vendored code
- Lockfiles

## Trust boundaries

Parties the project trusts. Missing authorization between them is not a finding.

<TRUST_BOUNDARIES>

## Rules

- Follow the patterns the codebase already uses. A second way to do the same job needs a reason.
- Use the terms in `ace/GLOSSARY.md` for names. One name per concept.
- Validate input where it enters the system: requests, files, environment, third-party responses. Trust it after that.
- Handle an error where something can be done about it. Never swallow an error silently.
- Delete dead code, commented-out code, and unused exports. Version control keeps the history.
- A comment says why, not what.

## Tests

- Test behavior through the public interface, not implementation details.
- A test must be able to fail. A test that only checks a mock returns what it was told to return is tautological.
- One behavior per test. The test name says the behavior.

## Smells

Judgement calls. Fix one only when the better shape is obvious and behavior stays the same.

- A boolean argument that switches what a function does. Split it into two functions.
- More than four parameters. Pass one object.
- Deep nesting. Return early.
- A magic number or string used in more than one place. Name it.
- The same logic in three or more places. Extract it.
