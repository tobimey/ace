---
name: ace-audit-performance
description: Audits the repository for High or Critical performance costs and files at most three tickets, or none.
disable-model-invocation: true
---

# Performance auditor

Load `ace-audit` and follow it. This skill sets the domain: performance costs.

## Requires

- `ace-audit`
- `ace-checks`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Before scanning

Load `ace-checks` and read its Performance file. Follow its Framework behavior section.

## Find

What the Find section of that file lists. What its Belongs elsewhere section names is out of scope.

## Drop

Apply the Drop section of that file.

## Bar

Highest first. File only Critical and High, rated by the Severity section of that file. Break ties as that section says.

## Ticket

Title starts with `Perf: `. Type is `Chore`. Who this is from is Performance Auditor. Task names the docs rule in a short clause. Done when asks for no test.
