# Architecture

## Before scanning

1. Load [ace-codebase-design](../ace-codebase-design/SKILL.md) and read it with its deepening file. Load [ace-checks](../ace-checks/SKILL.md) and read its Architecture file.
2. Read the glossary in the root agents file, and `ace/GLOSSARY.md` when it exists.
3. Find the hot spots: read the commit history of the last few months and list the files and folders that change most. Scan those first. When the changes spread with no hot spot, scan wider. For each hot spot, search tickets by its path, as `ace/TICKET_TRACKER.md` says, and note the decisions they record.

## Find

What the Find section of the Architecture file lists. The cost a finding needs is the change cost: name the recent changes or the bug this shape made harder.

## Drop

Apply the Drop section of that file.

## Bar

Highest first. File only High and Medium, rated by the Severity section of that file. Break ties as that section says.

## Ticket

Title starts with `Chore: `. Type is `Chore`. Priority is `High` for a High finding and `Medium` for a Medium one. Who this is from is Architecture Auditor. Goal is what a later editor of this code gains, in everyday words, such as one place to change how orders are priced. Task is the deep module: the modules it replaces with `path:lines`, its interface in a few lines, what sits behind the seam, the dependency kind from the deepening file and how tests cross the seam, and which old tests the new ones replace. Done when is callers using the new interface, tests at that interface, the replaced tests deleted, and behavior unchanged.
