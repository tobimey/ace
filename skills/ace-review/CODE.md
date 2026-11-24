# Code check

Logic bugs, security holes, performance costs, and architecture.

## Before scanning

Load [CHECKS.md](../ace-mode/shared/checks/CHECKS.md) and read its Logic, Security, Performance, and Architecture files. Read the call sites the change affects, not only the moved lines.

## Find

In the diff and the call sites it affects, find what each domain file's Find section lists.

For architecture, flag the concrete better shape, and propose a redesign only for files this diff changes.

## Drop

Apply the Drop section of each domain file.

## Severity

Rate each finding by the Severity section of its domain file.

## Fix type

**Example (`one-correct-fix`).** An inverted condition sends the message to the wrong user. Swap the condition.

**Example (`several-fixes`).** The same read could move to a background job or stay on the request.
