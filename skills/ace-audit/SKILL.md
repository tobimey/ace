---
name: ace-audit
description: Audits the whole repository for one or more domains (security, logic, performance, architecture, health) and files at most three tickets per domain, or none.
disable-model-invocation: true
---

# Audit

Audit the repository for the domains the caller names, one pass per domain, and file a ticket for each finding you keep. Done means each pass ran and filed at most three tickets. Zero is a complete pass. Three is a cap, not a quota.

## Requires

- `ace-open-ticket`

## Domains

Each domain file sets what its pass finds, drops, keeps, and files:

- [Security](SECURITY.md): High or Critical security holes.
- [Logic](LOGIC.md): High or Critical logic bugs.
- [Performance](PERFORMANCE.md): High or Critical performance costs.
- [Architecture](ARCHITECTURE.md): shallow modules and leaking seams that make change costly.
- [Health](HEALTH.md): coding-standards breaks later editors are likely to copy.

## Constraints

- Read only. Your output is tickets. Leave every file, branch, and pull request as it is.
- A pass files findings in its own domain only. A finding that belongs to another domain is out of scope for that pass.
- Ignore any path the coding standards mark as out of scope.
- A finding needs a concrete failure, exposure, or cost on a plausible path. Leave out hypotheticals, unverified dependency issues, accepted risks, and what the repo's linter or type checker already fails.
- Rate each finding at its real severity. If nothing meets the bar, open no tickets.

## Pick the domains

Run the domains the caller names, such as `security` or `security performance`. "Full audit" or "audit everything" names all five.

When the caller names none, ask which to run, and recommend all five. With nobody to ask, run all five.

Run the picked domains in this order: security, logic, performance, architecture, health. A later pass skips what an earlier pass filed, so the more severe domain claims a shared root cause first.

## Run each pass

Run the passes one after another, so each pass sees the tickets the one before it filed. When your harness can start sub-agents, run each pass in a fresh one with this skill, its domain file, and the domain name, so one pass's reading stays out of the next. Otherwise run them yourself in turn.

Each pass follows its domain file and these steps:

```
- [ ] 1. Scan
- [ ] 2. Drop
- [ ] 3. Check existing tickets
- [ ] 4. Keep at most three
- [ ] 5. File those
```

1. **Scan.** Do the domain file's Before scanning section first. Then read the code. Find what its Find section lists.
2. **Drop.** Apply its Drop section.
3. **Check existing tickets.** For each finding, search tickets by its primary file path, as `ace/TICKET_TRACKER.md` says. Read the matches. Skip a finding when a ticket already exists with the same root cause, primary files, or shape. This includes tickets an earlier pass of this run filed.
4. **Keep at most three.** Drop every finding that misses its Bar section. If none remain, file nothing. If one or two remain, file those and stop looking. If more than three remain, keep the three that rank highest. Break ties as the Bar section says.
5. **File those.** Skip this step when step 4 kept none. Open one ticket per finding with [ace-open-ticket](../ace-open-ticket/SKILL.md), using its Ticket section and the defaults below. A writeup in the session does not count. Choose Size from the concrete fix and Risk from what it touches, as `ace-open-ticket` defines them.

## Ticket defaults

A domain file's Ticket section overrides these.

- Goal is what the person using the product would have when this is fixed, in everyday words, with no code, file names, or internal terms.
- Task is the concrete fix, with `path:lines`.
- Done when includes a test only when Risk is `High`.
- Critical is Priority `Urgent`. High is Priority `High`.

## Report

One line per domain that ran, in run order:

```
security: <ticket URLs, or "nothing filed">
```
