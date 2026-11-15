---
name: ace-audit-performance
description: Audits the repository for High or Critical performance and caching issues and files at most three tickets, or none.
disable-model-invocation: true
---

# Performance auditor

Audit the repository for performance and caching issues. File a ticket for each finding you keep. Done means at most three High or Critical tickets. Zero is a complete audit. Three is a cap, not a quota.

## Constraints

- Do not edit the repository. Do not apply a fix. Do not open a pull request. Do not write a file in the repo.
- File performance and caching findings only. A logic bug, a security vulnerability, or a coding-standards nit is out of scope. Wrong data from a bad cache key is a logic or security bug. Do not file it here.
- Judge framework behavior (caching, rendering, data loading) from the docs of the installed version, not from training data.
- Do not file something the framework or compiler already optimizes.
- File only High or Critical. Do not file Low or Medium. Do not stretch a weaker finding to High so you have something to file.
- If nothing is High or Critical, stop. Open no tickets.

## Workflow

```
- [ ] 1. Read docs, then scan
- [ ] 2. Drop ignored and low-value findings
- [ ] 3. Check existing tickets
- [ ] 4. Cap at three High or Critical, or file none
- [ ] 5. File those
- [ ] 6. Stop
```

## 1. Read docs, then scan

Find the main framework and its installed version. If the installed package ships docs, read the pages on caching, data loading, and rendering. Otherwise use the docs for that version. Read a further page only when a candidate finding needs it.

Then read the code. Find:

- Waterfalls: independent awaits or requests that run one after the other on a request path
- N+1 queries, or one network call per item in a loop
- A shared, expensive read with no cache, or a cache that is bypassed where a cached helper already exists
- Per-user or per-request data stored in a shared cache, bloating memory
- Data loaded on the client that the server could load, or more data sent to the client than the path uses
- Work on a hot path that could run in the background
- Scanning or loading more data than the path needs
- A slow part that blocks the whole page or response when it could load on its own

A finding needs a concrete wait, extra round trip, blocked response, bloated cache, or extra client payload on a plausible path. Do not file a hypothetical, a micro-optimization, or something the repo's linter already fails.

## 2. Drop ignored and low-value findings

Ignore generated and vendored code, and any path the project's `ace/` files mark as out of scope.

Drop one-off nits on a rare path with no plausible wait.

Drop a change that splits a shared cache into many smaller ones.

Dependent awaits are not a waterfall. Drop them.

Example: drop two awaits where the second needs the first's id. File two independent reads in a request handler that run one after the other and delay the response.

## 3. Check existing tickets

For each finding, search tickets by its primary file path, as `ace/TICKET_TRACKER.md` says. Read the matches.

Skip a finding when a ticket already exists with the same root cause, primary files, or the same wait.

## 4. Cap at three High or Critical, or file none

Rank what remains. Drop Low and Medium.

If none are High or Critical, file nothing. Do not file Medium or Low to fill the cap.

If one or two are, file those. Do not hunt for a third.

If more than three are, file the three most severe. Leave the rest unfiled.

Severity, highest first:

- **Critical.** A common path shows nothing until a chain of independent reads finishes, or a shared cache stores per-user data at scale.
- **High.** A waterfall, N+1, or blocked response on a common path.
- **Medium.** Wrong cache lifetime or invalidation, or a waterfall on a narrower path. Do not file.
- **Low.** A real cost with a small local fix. Do not file.

On a tie, keep the worse user wait.

Map severity to Priority when you file. Critical is `Urgent`, High is `High`.

## 5. File those

Skip this step when step 4 kept none. One ticket per finding. A writeup in the session does not count. For each ticket, write the body with `ace-write-ticket`, then open it as `ace/TICKET_TRACKER.md` says.

Title starts with `Perf: `. Type is `Chore`. Priority is the map in step 4. Choose Size from the concrete fix as `ace-write-ticket` defines it.

Who this is from is Performance Auditor.

Goal is what the person using the product would have when this is fixed, in everyday words, with no code, file names, or internal terms.

Task is the concrete fix, with `path:lines`. Name the docs rule in a short clause.

Do not ask for a test in Done when.

## 6. Stop

When the tickets exist, or when nothing was filed, stop.
