# Custom check

A check the project adds as `ace/checks/<name>.md`. Run one pass per file. This file says how to run it, and the project file says what to find.

## Before scanning

Read the project file in full. Do its Before scanning section when it has one.

## Find

In the diff and the call sites it affects, find what the Find section of the project file lists.

## Drop

Apply the Drop section of the project file. Leave out what the linter and type checker already enforce.

## Belongs elsewhere

Follow the Belongs elsewhere section of the project file when it has one. Coding standards belong to [Standards](STANDARDS.md), and logic, security, performance, and architecture belong to [Code](CODE.md), unless the project file claims them.

## Severity

Rate each finding by the Severity section of the project file, then write that level as:

- `blocker`: Critical or High.
- `should-fix`: Medium.
- `nit`: Low.

## Fix type

Use the fix types of the Finding section in [SKILL.md](SKILL.md). When the project file says its findings always need a person, every finding is `needs-a-person`.
