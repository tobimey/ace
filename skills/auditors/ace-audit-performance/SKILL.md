---
name: ace-audit-performance
description: Audits the repository for High or Critical Next.js caching and performance issues and files at most three tickets, or none.
disable-model-invocation: true
---

# Performance auditor

Audit the repository for Next.js caching and performance issues. File a ticket for each finding you keep. Done means at most three High or Critical tickets. Zero is a complete audit. Three is a cap, not a quota.

## Constraints

- Do not edit the repository. Do not apply a fix. Do not open a pull request. Do not write a file in the repo.
- File caching and performance findings only. A logic bug, a security vulnerability, or a coding-standards nit is out of scope. Wrong data from a bad cache key is a logic or security bug. Do not file it here.
- Do not file missing keyboard accessibility. A control that works with a pointer and not with a keyboard is not a finding.
- Judge framework caching, streaming, and the static shell from the installed Next.js docs, not from training data. This app uses Cache Components. `fetch` is not cached by default.
- Do not file missing `useMemo`, `memo`, or `useCallback`. React Compiler is on.
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

```bash
ls apps/app.hedwig.chat/node_modules/next/dist/docs
```

Read the installed Next.js caching, fetching, and streaming docs. Open those pages by title. Read a further page only when a candidate finding needs it.

Then read the code. Find:

- React request waterfalls in Server Components: sequential independent awaits, or a parent that awaits before rendering children that also fetch
- Uncached async work with no Suspense, so the static shell cannot commit
- Missing or wrong Cache Components usage (`use cache`, `cacheLife`, `cacheTag`) on a shared expensive read
- Per-user or per-request data inside `use cache` that bloats server memory
- Client-side fetching or `useEffect` data loading on a path that should read on the server
- A `loading.tsx` or Suspense boundary so coarse that it hides the whole app, or so missing that a slow leaf blocks the page
- A hot-path Firestore read that bypasses the feature `get*Cached` function and repeats work

A finding needs a concrete wait, extra round trip, blocked shell, bloated cache, or extra client JS on a plausible path. Do not file a hypothetical, a micro-optimization, or something `pnpm lint` already fails.

## 2. Drop ignored and low-value findings

Ignore `/utility` API routes. They are not production.

Drop one-off nits on a rare path with no plausible wait.

Drop adding `orderBy` or extra query constraints to a `get*Cached` call. That splits the cache.

Dependent awaits are not a waterfall. Drop them.

Example: drop two awaits where the second needs the first's id. File two independent `get*Cached` awaits in a page that run one after the other and block first paint.

## 3. Check existing tickets

For each finding, search tickets by its primary file path, as `ace/TICKET_TRACKER.md` says. Read the matches.

Skip a finding when a ticket already exists with the same root cause, primary files, or the same wait.

## 4. Cap at three High or Critical, or file none

Rank what remains. Drop Low and Medium.

If none are High or Critical, file nothing. Do not file Medium or Low to fill the cap.

If one or two are, file those. Do not hunt for a third.

If more than three are, file the three most severe. Leave the rest unfiled.

Severity, highest first:

- **Critical.** A common live path paints nothing until a chain of independent server reads finishes, or `use cache` stores per-user data in server memory at scale.
- **High.** A waterfall or blocked shell on a common path.
- **Medium.** Wrong cache lifetime or tags, or a waterfall on a narrower path. Do not file.
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
