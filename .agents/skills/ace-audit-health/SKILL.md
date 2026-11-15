---
name: ace-audit-health
description: Files at most three tickets for coding-standards breaks later editors are likely to copy.
disable-model-invocation: true
---

# Health auditor

Audit the repository for breaks of the coding standards. File a ticket for each finding you keep. Done means at most three copy-path tickets. Zero is a complete audit. Three is a cap, not a quota.

## Constraints

- Do not edit the repository. Do not apply a fix. Do not open a pull request. Do not write a file in the repo.
- Do not file logic bugs, security holes, or performance costs. Those belong to the other auditors.
- Do not file UI or UX judgement. That needs a person.
- File only a break later editors are likely to copy. Do not file a one-off nit. Do not stretch a nit so you have something to file.
- If nothing is a copy-path break, stop. Open no tickets.
- Ignore generated and vendored code, and any path the project's `ace/` files mark as out of scope.
- Do not file something the repo's linter or type checker already fails.

## Workflow

```
- [ ] 1. Read the standards
- [ ] 2. Scan
- [ ] 3. Check existing tickets
- [ ] 4. Cap at three copy-path breaks, or file none
- [ ] 5. File those
- [ ] 6. Stop
```

## 1. Read the standards

Read the coding standards in full, including Smells. A smell is a judgement call. File it only when the better shape is obvious and the fix would keep the same behavior. An earlier rule in that file wins.

## 2. Scan

A finding is a behavior-identical break of those rules, with a file path and the rule it breaks. Skip hypotheticals and nits a later editor would not copy.

## 3. Check existing tickets

For each finding, search tickets by its primary file path, as `ace/TICKET_TRACKER.md` says. Read the matches.

Skip a finding when a ticket already exists with the same rule, the same files, or the same shape.

## 4. Cap at three copy-path breaks, or file none

Drop a one-off nit.

If none remain, file nothing. Do not file a nit to fill the cap.

If one or two remain, file those. Do not hunt for a third.

If more than three remain, keep the three most likely to be copied. On a tie, prefer the smaller safe fix.

Priority is `Medium`.

## 5. File those

Skip this step when step 4 kept none. One ticket per finding. A writeup in the session does not count. For each ticket, write the body with `ace-write-ticket`, then open it as `ace/TICKET_TRACKER.md` says.

Title starts with `Chore: `. Type is `Chore`. Priority is the map in step 4. Choose Size from the concrete fix as `ace-write-ticket` defines it.

Who this is from is Health Auditor.

Goal is what a later editor of this code can rely on, in everyday words.

Task is the concrete refactor, with `path:lines` and the coding standards rule.

Done when is the named code matching that rule, and behavior unchanged.

## 6. Stop

When the tickets exist, or when nothing was filed, stop.
