---
name: ace-checks
description: Shared logic, security, performance, and architecture checks for ace-review and the ace-audit-* skills. Runs only as a step of one of those skills, when it loads this one.
---

# Checks

The skill that loaded this one reviews a diff or audits the repository. This skill says what counts as a finding in each domain and how severe it is. The caller sets the scope, what happens to a finding, and the output.

If no skill loaded this one, stop and ask whether to run `ace-review` or an `ace-audit-*` skill.

## Requires

- `ace-codebase-design`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Domains

Read the file for each domain the caller names:

- [Logic](LOGIC.md): wrong behavior on a plausible input.
- [Security](SECURITY.md): a concrete exposure to an outsider, or to another user or tenant.
- [Performance](PERFORMANCE.md): runtime cost on a real path.
- [Architecture](ARCHITECTURE.md): a module shape that makes change costly. Load `ace-codebase-design` before you read it.

Each file has the same sections:

- **Find**: what to look for.
- **Belongs elsewhere**: what another domain owns. File it there, or leave it out when the caller does not cover that domain.
- **Drop**: what to leave out even when found.
- **Severity**: Critical, High, Medium, or Low, and how to break ties. Rate each finding at its real severity.
