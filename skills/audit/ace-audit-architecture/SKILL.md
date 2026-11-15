---
name: ace-audit-architecture
description: Audits the repository for shallow modules and leaking seams that make change costly, and files at most three tickets, or none.
disable-model-invocation: true
---

# Architecture auditor

Load `ace-audit` and follow it. This skill sets the domain: architecture.

## Requires

- `ace-audit`
- `ace-checks`
- `ace-codebase-design`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Before scanning

1. Load `ace-codebase-design` and read it with its deepening file. Load `ace-checks` and read its Architecture file.
2. Read `ace/GLOSSARY.md` and the decisions the repo records, such as ADRs.
3. Find the hot spots: read the commit history of the last few months and list the files and folders that change most. Scan those first. When the changes spread with no hot spot, scan wider.

## Find

What the Find section of the Architecture file lists. The cost `ace-audit` asks for is the change cost: name the recent changes or the bug this shape made harder.

## Drop

Apply the Drop section of that file.

## Bar

Highest first. File only High and Medium, rated by the Severity section of that file. Break ties as that section says.

## Ticket

Title starts with `Chore: `. Type is `Chore`. Priority is `High` for a High finding and `Medium` for a Medium one. Who this is from is Architecture Auditor. Goal is what a later editor of this code gains, in everyday words, such as one place to change how orders are priced. Task is the deep module: the modules it replaces with `path:lines`, its interface in a few lines, what sits behind the seam, the dependency kind from the deepening file and how tests cross the seam, and which old tests the new ones replace. Done when is callers using the new interface, tests at that interface, the replaced tests deleted, and behavior unchanged.
