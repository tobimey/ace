---
name: ace-audit
description: Audits the whole repository for one or more domains (security, logic, performance, architecture, health, and each custom check in ace/checks/) and files a capped number of tickets per domain, or none.
disable-model-invocation: true
---

# Audit

Audit the repository for the domains the caller names, one pass per domain, and file a ticket for each finding you keep. Done means each pass ran and filed at most the cap of tickets. Zero is a complete pass. The cap is not a quota.

The cap is 3, unless the caller names another number.

## Requires

- `ace-mode`, for its [CHECKS.md](../ace-mode/shared/checks/CHECKS.md)
- `ace-to-ticket`, for its [OPEN_TICKET.md](../ace-to-ticket/OPEN_TICKET.md)

## Domains

Each domain's sections set what its pass reads first, finds, drops, keeps, and files:

- Security, logic, and performance: High or Critical holes, bugs, and costs. Each uses the Find, Drop, and Severity sections of its file in [CHECKS.md](../ace-mode/shared/checks/CHECKS.md). Its Bar is Critical and High, highest first, with ties broken as its Severity section says. Its Ticket is the row below.
- [Architecture](ARCHITECTURE.md): shallow modules and leaking seams that make change costly.
- [Health](HEALTH.md): coding-standards breaks later editors are likely to copy.
- Custom: one domain for each custom check in `ace/checks/`, named after its file, such as `accessibility` for `ace/checks/ACCESSIBILITY.md`. Read that file in full. Its sections, with the defaults in [contract/CHECKS.md](../ace-mode/shared/adapters/contract/CHECKS.md), are the domain's.

| Domain | Title starts with | Type | Who this is from |
|---|---|---|---|
| security | `Security: ` | `Bug` | Security Auditor |
| logic | `Bug: ` | `Bug` | Logic Auditor |
| performance | `Perf: ` | `Chore` | Performance Auditor |

A performance Task names the docs rule in a short clause, and its Done when asks for no test.

## Constraints

- Read only. Your output is tickets. Leave every file, branch, and pull request as it is.
- A pass files findings in its own domain only. A finding that belongs to another domain is out of scope for that pass.
- Ignore any path the coding standards mark as out of scope.
- A finding needs a concrete failure, exposure, or cost on a plausible path. Leave out hypotheticals, the accepted risks the coding standards list, and what the repo's linter or type checker already fails.
- Rate each finding at its real severity. If nothing meets the bar, open no tickets.

## Pick the domains

Run the domains the caller names, such as `security` or `security performance`. "Full audit" or "audit everything" names all five built-in domains and every custom check.

When the caller names none, ask which to run, and recommend all of them. With nobody to ask, run all of them.

Run the picked domains in this order: security, logic, performance, architecture, health, then the custom checks by file name. A later pass skips what an earlier pass filed, so the more severe domain claims a shared root cause first.

## Run each pass

Run the passes one after another, so each pass sees the tickets the one before it filed. When your harness can start sub-agents, run each pass in a fresh one with this skill and the domain name, so one pass's reading stays out of the next. Otherwise run them yourself in turn.

Each pass follows its domain's sections and these steps:

```
- [ ] 1. Scan
- [ ] 2. Drop
- [ ] 3. Check existing tickets
- [ ] 4. Keep at most the cap
- [ ] 5. File those
```

1. **Scan.** Do its Before scanning section first, when it has one. Then read the code. Find what its Find section lists.
2. **Drop.** Apply its Drop section.
3. **Check existing tickets.** For each finding, search tickets by its primary file path and by the feature or glossary term it touches, since planned tickets name no paths, as `ace/TICKET_TRACKER.md` says. Read the matches. Skip a finding when a ticket already covers its root cause, code, or shape. This includes tickets an earlier pass of this run filed.
4. **Keep at most the cap.** Drop every finding that misses its Bar section. If none remain, file nothing. If the cap or fewer remain, file those and stop looking. If more remain, keep the ones that rank highest, up to the cap. Break ties as the Bar section says.
5. **File those.** Skip this step when step 4 kept none. Open one ticket per finding with [OPEN_TICKET.md](../ace-to-ticket/OPEN_TICKET.md), using its Ticket section and the defaults below. A writeup in the session counts only when there is no ticket tracker, as the no-tracker default in [TICKET_TRACKER.md](../ace-mode/shared/adapters/contract/TICKET_TRACKER.md) says. Choose Size from the concrete fix and Risk from what it touches, as that file defines them. Each ticket stays in needs-human for a person.

## Ticket defaults

A domain's Ticket section overrides these.

- Goal is what the person using the product would have when this is fixed, in everyday words, with no code, file names, or internal terms.
- Task is the concrete fix, with `path:lines`.
- Done when includes a test only when Risk is `High`.
- Critical is Priority `Urgent`. High is Priority `High`.

## Report

One line per domain that ran, in run order:

```
security: <ticket URLs, or "nothing filed">
```
