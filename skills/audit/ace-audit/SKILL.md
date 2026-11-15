---
name: ace-audit
description: Shared workflow for the ace-audit-* skills. Runs only as a step of an ace-audit-* skill, when that skill loads it.
---

# Audit workflow

The domain auditor that loaded this skill names the domain and sets its Find, Drop, Bar, and Ticket sections. Some auditors also have a Before scanning section. Where this skill says "the auditor", it means that skill.

Audit the repository for that domain and file a ticket for each finding you keep. Done means at most three tickets. Zero is a complete audit. Three is a cap, not a quota.

If no auditor loaded this skill, stop and ask which `ace-audit-*` skill to run.

## Requires

- `ace-open-ticket`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Constraints

- Read only. Your output is tickets. Leave every file, branch, and pull request as it is.
- File findings in the auditor's domain only. A finding that belongs to another auditor is out of scope.
- Ignore any path the coding standards mark as out of scope.
- A finding needs a concrete failure, exposure, or cost on a plausible path. Leave out hypotheticals, unverified dependency issues, accepted risks, and what the repo's linter or type checker already fails.
- Rate each finding at its real severity. If nothing meets the bar, open no tickets.
- Find each adapter section by its job. Its heading may differ from the one named here. If a file or a section is missing, name it, say what it must hold, and stop.

## Workflow

```
- [ ] 1. Scan
- [ ] 2. Drop
- [ ] 3. Check existing tickets
- [ ] 4. Keep at most three
- [ ] 5. File those
```

1. **Scan.** If the auditor has a Before scanning section, do it first. Then read the code. Find what the auditor's Find section lists.
2. **Drop.** Apply the auditor's Drop section.
3. **Check existing tickets.** For each finding, search tickets by its primary file path, as `ace/TICKET_TRACKER.md` says. Read the matches. Skip a finding when a ticket already exists with the same root cause, primary files, or shape.
4. **Keep at most three.** Drop every finding that misses the auditor's Bar section. If none remain, file nothing. If one or two remain, file those and stop looking. If more than three remain, keep the three that rank highest. Break ties as the Bar section says.
5. **File those.** Skip this step when step 4 kept none. Open one ticket per finding with `ace-open-ticket`, using the auditor's Ticket section and the defaults below. A writeup in the session does not count. Choose Size from the concrete fix and Risk from what it touches, as `ace-open-ticket` defines them. When the tickets exist, or when nothing was filed, stop.

## Ticket defaults

The auditor's Ticket section overrides these.

- Goal is what the person using the product would have when this is fixed, in everyday words, with no code, file names, or internal terms.
- Task is the concrete fix, with `path:lines`.
- Done when includes a test only when Risk is `High`.
- Critical is Priority `Urgent`. High is Priority `High`.
