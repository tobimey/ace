---
name: ace-audit
description: Audits the whole repository in one domain (logic, security, performance, or health) and files at most three tickets, or none.
disable-model-invocation: true
---

# Audit

Audit the repository in one domain and file a ticket for each finding you keep. Done means at most three tickets for that domain. Zero is a complete audit. Three is a cap, not a quota.

The caller names the domain: `logic`, `security`, `performance`, or `health`. If none is named, ask which.

## Constraints

- Do not edit the repository. Do not apply a fix. Do not open a pull request. Do not write a file in the repo.
- Audit only the named domain. A finding that belongs to another domain is out of scope.
- Ignore any path the coding standards mark as out of scope. Respect the trust boundaries they state.
- A finding needs a concrete failure, exposure, or cost on a plausible path. Do not file a hypothetical, an unverified dependency issue, or something the repo's linter or type checker already fails.
- Never file an accepted risk.
- Do not stretch a weaker finding to meet the domain's bar so there is something to file. If nothing meets it, open no tickets.

## Workflow

```
- [ ] 1. Read the domain section
- [ ] 2. Scan
- [ ] 3. Drop what the domain drops
- [ ] 4. Check existing tickets
- [ ] 5. Keep at most three
- [ ] 6. File those
```

## 1. Read the domain section

Read the section below for the named domain. It sets what to find, what to drop, the bar a finding must meet, and the ticket fields.

## 2. Scan

Read the code. Find what the domain lists.

## 3. Drop what the domain drops

Apply the domain's drop rules.

## 4. Check existing tickets

For each finding, search tickets by its primary file path, as `ace/TICKET_TRACKER.md` says. Read the matches. Skip a finding when a ticket already exists with the same root cause, primary files, or shape.

## 5. Keep at most three

Drop every finding below the domain's bar. If none remain, file nothing. If one or two remain, file those and do not hunt for a third. If more than three remain, keep the three that rank highest, and break ties as the domain says.

## 6. File those

Skip this step when step 5 kept none. Open one ticket per finding with `ace-open-ticket`. A writeup in the session does not count.

Take the title prefix, type, Priority, and Who this is from from the domain section. Choose Size from the concrete fix as `ace-open-ticket` defines it.

Unless the domain says otherwise:

- Goal is what the person using the product would have when this is fixed, in everyday words, with no code, file names, or internal terms.
- Task is the concrete fix, with `path:lines`.
- Done when includes a test only for critical infrastructure: auth, tenant isolation, webhooks, stored data integrity, or secrets.

When the tickets exist, or when nothing was filed, stop.

## Logic

Find:

- Off-by-one or wrong bounds
- Impossible or unreachable branches
- Inverted conditions
- Incorrect async/await, or missing error handling that loses failures
- Wrong database or API assumptions
- Type or logic contradictions
- User-visible or data-affecting incorrect behavior on plausible inputs

Authorization holes belong to `security`.

Drop:

- Concurrency, races, and missing locks or transactions, unless the impact is severe. Severe means money charged twice, data or messages reaching the wrong user or tenant, or stored data permanently wrong. Two tasks touching the same record is not a finding.
- Any other finding whose only fix adds runtime cost: extra database reads or writes, extra network, extra CPU on a request or task path, an N+1 query, or scanning more data. Keep a finding whose fix uses data already in memory. A severe race may use a transaction. For example, drop re-fetching a record on every request to work around a stale cache.

Bar, highest first. File only Critical and High.

- **Critical.** Money charged twice, data or messages reaching the wrong user or tenant, or stored data permanently wrong.
- **High.** Wrong user-visible behavior on a common path, with stored data still correctable.
- **Medium.** Wrong behavior on a narrow path.
- **Low.** A real bug with a small, recoverable effect.

Ties go to the worse user impact.

Ticket: title starts with `Bug: `. Type is `Bug`. Critical is Priority `Urgent`, High is `High`. Who this is from is Logic Auditor.

## Security

Find:

- Exposed secrets
- XSS or other unescaped output
- Insecure API endpoints
- Server-side handlers with missing or weak auth
- Injection
- Path traversal
- SSRF or unsafe URL handling in server-side requests

A logic bug with no exposure to an outsider, or to another user or tenant, belongs to `logic`.

Drop a weaker finding whose only fix adds runtime cost. When a Critical or High hole has no zero-cost fix, file it with the cheapest correct fix.

Bar, highest first. File only Critical and High.

- **Critical.** A secret is exposed, or an outsider can read or change data of many users or tenants.
- **High.** An outsider, or another user or tenant, can read or change data or act through one endpoint or handler.
- **Medium.** A real hole that needs an extra condition, and does not expose a secret or another user's data by itself.
- **Low.** A real hole with little the attacker can do.

Ties go to the wider exposure.

Ticket: title starts with `Security: `. Type is `Bug`. Critical is Priority `Urgent`, High is `High`. Who this is from is Security Auditor.

## Performance

Before scanning, find the main framework and its installed version. If the installed package ships docs, read the pages on caching, data loading, and rendering. Otherwise use the docs for that version. Read a further page only when a candidate finding needs it. Judge framework behavior from those docs, not from memory. Do not file what the framework or compiler already optimizes.

Find:

- Waterfalls: independent awaits or requests that run one after the other on a request path
- N+1 queries, or one network call per item in a loop
- A shared, expensive read with no cache, or a read that bypasses an existing cached helper
- Per-user or per-request data stored in a shared cache, bloating memory
- Data loaded on the client that the server could load, or more data sent to the client than the path uses
- Work on a hot path that could run in the background
- Scanning or loading more data than the path needs
- A slow part that blocks the whole page or response when it could load on its own

Wrong data from a bad cache key belongs to `logic` or `security`.

Drop:

- Micro-optimizations, and one-off costs on a rare path with no plausible wait.
- A change that splits a shared cache into many smaller ones.
- Dependent awaits. Two awaits where the second needs the first's id are not a waterfall.

Bar, highest first. File only Critical and High.

- **Critical.** A common path shows nothing until a chain of independent reads finishes, or a shared cache stores per-user data at scale.
- **High.** A waterfall, N+1, or blocked response on a common path.
- **Medium.** Wrong cache lifetime or invalidation, or a waterfall on a narrower path.
- **Low.** A real cost with a small local fix.

Ties go to the longer user wait.

Ticket: title starts with `Perf: `. Type is `Chore`. Critical is Priority `Urgent`, High is `High`. Who this is from is Performance Auditor. Task names the docs rule in a short clause. Done when asks for no test.

## Health

Read the coding standards in full first, including Smells and every package file their "Packages" section lists. A package file applies only to its path.

Find behavior-identical breaks of those rules, each with a file path and the rule it breaks. A smell is a judgement call. Count it only when the better shape is obvious and the fix keeps the same behavior. An earlier rule in the coding standards wins.

Logic, security, and performance findings belong to their domains. UI or UX judgement needs a person. Do not file it.

Bar: file only a break later editors are likely to copy. Drop a one-off nit.

Ties go to the smaller safe fix.

Ticket: title starts with `Chore: `. Type is `Chore`. Priority is `Medium`. Who this is from is Health Auditor. Goal is what a later editor of this code can rely on, in everyday words. Task is the concrete refactor, with `path:lines` and the rule. Done when is the named code matching that rule, with behavior unchanged.
