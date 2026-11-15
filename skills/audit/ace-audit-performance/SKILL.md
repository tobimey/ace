---
name: ace-audit-performance
description: Audits the repository for High or Critical performance costs and files at most three tickets, or none.
disable-model-invocation: true
---

# Performance auditor

Load `ace-audit` and follow it. This skill sets the domain: performance costs.

## Before scanning

Find the main framework and its installed version. If the installed package ships docs, read the pages on caching, data loading, and rendering. Otherwise use the docs for that version. Read a further page only when a candidate finding needs it. Judge framework behavior from those docs, not from memory.

## Find

- Waterfalls: independent awaits or requests that run one after the other on a request path
- N+1 queries, or one network call per item in a loop
- A shared, expensive read with no cache, or a read that bypasses an existing cached helper
- Per-user or per-request data stored in a shared cache, bloating memory
- Data loaded on the client that the server could load, or more data sent to the client than the path uses
- Work on a hot path that could run in the background
- Scanning or loading more data than the path needs
- A slow part that blocks the whole page or response when it could load on its own

Wrong data from a bad cache key belongs to `ace-audit-logic` or `ace-audit-security`.

## Drop

- Micro-optimizations, and one-off costs on a rare path with no plausible wait.
- What the framework or compiler already optimizes.
- A change that splits a shared cache into many smaller ones.
- Dependent awaits. Two awaits where the second needs the first's id are not a waterfall.

## Bar

Highest first. File only Critical and High. Ties go to the longer user wait.

- **Critical.** A common path shows nothing until a chain of independent reads finishes, or a shared cache stores per-user data at scale.
- **High.** A waterfall, N+1, or blocked response on a common path.
- **Medium.** Wrong cache lifetime or invalidation, or a waterfall on a narrower path.
- **Low.** A real cost with a small local fix.

## Ticket

Title starts with `Perf: `. Type is `Chore`. Who this is from is Performance Auditor. Task names the docs rule in a short clause. Done when asks for no test.
