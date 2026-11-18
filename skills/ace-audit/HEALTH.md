# Health

## Before scanning

Read the coding standards in full first, including Smells and every package `CODING_STANDARDS.md`, found as [PACKAGES.md](../ace-adapters/contract/PACKAGES.md) says. A package file applies only to its path.

## Find

Behavior-identical breaks of those rules, each with a file path and the rule it breaks. A smell is a judgement call. Count it only when the better shape is obvious and the fix keeps the same behavior. An earlier rule in the coding standards wins.

Logic, security, performance, and architecture findings belong to their own domains.

## Drop

UI or UX judgement. It needs a person.

## Bar

File only a break later editors are likely to copy. Drop a one-off nit. Ties go to the smaller safe fix.

## Ticket

Title starts with `Chore: `. Type is `Chore`. Priority is `Medium`. Who this is from is Health Auditor. Goal is what a later editor of this code can rely on, in everyday words. Task is the concrete refactor, with `path:lines` and the rule. Done when is the named code matching that rule, with behavior unchanged.
