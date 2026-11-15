---
name: ace-audit-health
description: Audits the repository for coding-standards breaks later editors are likely to copy and files at most three tickets, or none.
disable-model-invocation: true
---

# Health auditor

Load `ace-audit` and follow it. This skill sets the domain: coding-standards breaks.

## Requires

- `ace-audit`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Before scanning

Read the coding standards in full first, including Smells and every package file their "Packages" section lists. A package file applies only to its path.

## Find

Behavior-identical breaks of those rules, each with a file path and the rule it breaks. A smell is a judgement call. Count it only when the better shape is obvious and the fix keeps the same behavior. An earlier rule in the coding standards wins.

Logic, security, and performance findings belong to `ace-audit-logic`, `ace-audit-security`, and `ace-audit-performance`.

## Drop

UI or UX judgement. It needs a person.

## Bar

File only a break later editors are likely to copy. Drop a one-off nit. Ties go to the smaller safe fix.

## Ticket

Title starts with `Chore: `. Type is `Chore`. Priority is `Medium`. Who this is from is Health Auditor. Goal is what a later editor of this code can rely on, in everyday words. Task is the concrete refactor, with `path:lines` and the rule. Done when is the named code matching that rule, with behavior unchanged.
