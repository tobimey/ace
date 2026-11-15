---
name: ace-audit-logic
description: Audits the repository for High or Critical logic and correctness bugs and files at most three tickets, or none.
disable-model-invocation: true
---

# Logic auditor

Audit the repository for logic and correctness bugs. File a ticket for each finding you keep. Done means at most three High or Critical tickets. Zero is a complete audit. Three is a cap, not a quota.

## Constraints

- Do not edit the repository. Do not apply a fix. Do not open a pull request. Do not write a file in the repo.
- File logic and correctness bugs only. A security vulnerability is out of scope.
- File only High or Critical. Do not file Low or Medium. Do not stretch a weaker finding to High so you have something to file.
- If nothing is High or Critical, stop. Open no tickets.

## Workflow

```
- [ ] 1. Scan
- [ ] 2. Drop ignored, known-risk, and low-value findings
- [ ] 3. Check existing tickets
- [ ] 4. Cap at three High or Critical, or file none
- [ ] 5. File those
- [ ] 6. Stop
```

## 1. Scan

Read the code. Find:

- Off-by-one or wrong bounds
- Impossible or unreachable branches
- Inverted conditions
- Incorrect async/await, or missing error handling that loses failures
- Wrong database or API assumptions
- Type or logic contradictions
- User-visible or data-affecting incorrect behavior on plausible inputs

A finding needs a concrete failure mode on a plausible input. Do not file a hypothetical with no plausible impact, a style-only nit, or an unverified dependency issue.

Respect the trust boundaries the project's `ace/` files state. Authorization holes belong to the security auditor.

## 2. Drop ignored, known-risk, and low-value findings

Ignore generated and vendored code, and any path the project's `ace/` files mark as out of scope.

Drop concurrency, races, and missing locks or transactions, unless the impact is severe. Severe means money charged twice, data or messages reaching the wrong user or tenant, or stored data permanently wrong. Two tasks touching the same record is not a finding. A theoretical race is not enough.

Drop any other finding whose only concrete fix adds runtime cost: extra database reads or writes, extra network, extra CPU on a request or task path, an N+1 query, or scanning more data. Keep a High or Critical finding when the fix uses data already in memory. A severe race is the exception and may use a transaction.

Example: drop re-fetching a record on every incoming request to work around a stale cache. That is an extra read on the hot path.

Never file an accepted risk.

## 3. Check existing tickets

For each finding, search tickets by its primary file path, as `ace/TICKET_TRACKER.md` says. Read the matches.

Skip a finding when a ticket already exists with the same root cause, primary files, or exposure.

## 4. Cap at three High or Critical, or file none

Rank what remains. Drop Low and Medium.

If none are High or Critical, file nothing. Do not file Medium or Low to fill the cap.

If one or two are, file those. Do not hunt for a third.

If more than three are, file the three most severe. Leave the rest unfiled.

Severity, highest first:

- **Critical.** Money charged twice, data or messages reaching the wrong user or tenant, or stored data permanently wrong.
- **High.** Wrong user-visible behavior on a common path, with stored data still correctable.
- **Medium.** Wrong behavior on a narrow path. Do not file.
- **Low.** A real bug with a small, recoverable effect. Do not file.

On a tie, keep the worse user impact.

Map severity to Priority when you file. Critical is `Urgent`, High is `High`.

## 5. File those

Skip this step when step 4 kept none. One ticket per finding. A writeup in the session does not count. For each ticket, write the body with `ace-write-ticket`, then open it as `ace/TICKET_TRACKER.md` says.

Title starts with `Bug: `. Type is `Bug`. Priority is the map in step 4. Choose Size from the concrete fix as `ace-write-ticket` defines it.

Who this is from is Logic Auditor.

Goal is what the person using the product would have when this is fixed, in everyday words, with no code, file names, or internal terms.

Task is the concrete fix, with `path:lines`.

In Done when, include a test only for critical infrastructure: auth, tenant isolation, webhooks, stored data integrity, or secrets.

## 6. Stop

When the tickets exist, or when nothing was filed, stop.
