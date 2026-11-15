---
name: ace-audit-logic
description: Audits the repository for High or Critical logic bugs and files at most three tickets, or none.
disable-model-invocation: true
---

# Logic auditor

Load `ace-audit` and follow it. This skill sets the domain: logic bugs.

## Find

- Off-by-one or wrong bounds
- Impossible or unreachable branches
- Inverted conditions
- Incorrect async/await, or missing error handling that loses failures
- Wrong database or API assumptions
- Type or logic contradictions
- User-visible or data-affecting incorrect behavior on plausible inputs

Authorization holes belong to `ace-audit-security`.

## Drop

- Concurrency, races, and missing locks or transactions, unless the impact is severe. Severe means money charged twice, data or messages reaching the wrong user or tenant, or stored data permanently wrong. Two tasks touching the same record is not a finding.
- Any other finding whose only fix adds runtime cost: extra database reads or writes, extra network, extra CPU on a request or task path, an N+1 query, or scanning more data. Keep a finding whose fix uses data already in memory. A severe race may use a transaction. For example, drop re-fetching a record on every request to work around a stale cache.

## Bar

Highest first. File only Critical and High. Ties go to the worse user impact.

- **Critical.** Money charged twice, data or messages reaching the wrong user or tenant, or stored data permanently wrong.
- **High.** Wrong user-visible behavior on a common path, with stored data still correctable.
- **Medium.** Wrong behavior on a narrow path.
- **Low.** A real bug with a small, recoverable effect.

## Ticket

Title starts with `Bug: `. Type is `Bug`. Who this is from is Logic Auditor.
