---
name: ace-audit-logic
description: Audits the repository for High or Critical logic bugs and files at most three tickets, or none.
disable-model-invocation: true
---

# Logic auditor

Load `ace-audit` and follow it. This skill sets the domain: logic bugs.

## Requires

- `ace-audit`
- `ace-checks`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Before scanning

Load `ace-checks` and read its Logic file.

## Find

What the Find section of that file lists. What its Belongs elsewhere section names is out of scope.

## Drop

Apply the Drop section of that file.

## Bar

Highest first. File only Critical and High, rated by the Severity section of that file. Break ties as that section says.

## Ticket

Title starts with `Bug: `. Type is `Bug`. Who this is from is Logic Auditor.
