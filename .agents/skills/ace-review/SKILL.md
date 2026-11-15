---
name: ace-review
description: Reviews the current change, commits a fix when one edit is the correct one, writes the rest as findings, and writes Merge Danger.
disable-model-invocation: true
---

# Review

Review the diff for logic bugs, security holes, performance costs, and architecture. Done means a fix is committed when one edit is the correct one, every finding that needs a person is written with a severity and a best fix, and Merge Danger is written.

## Constraints

- Edit only files this change touches.
- Flag only logic, security, performance, and architecture. Coding standards, naming, and code smells belong to `ace-validate-standards`. Spec match belongs to `ace-check-spec`. Bypassing an existing cached helper is performance.
- Respect the trust boundaries the coding standards state. Flag missing authorization only between parties the project does not trust.
- Ignore generated and vendored code, and any path the coding standards mark as out of scope.
- A finding needs a concrete failure mode or cost on a plausible path in this diff, or a simpler or deeper design this diff could have used. Leave out hypotheticals, pre-existing issues the diff does not make worse, unverified dependency advisories, and accepted risks.

## Workflow

```
- [ ] 1. Get the diff
- [ ] 2. Scan logic, security, performance, architecture
- [ ] 3. Drop out of scope
- [ ] 4. Fix what needs no decision
- [ ] 5. Write what remains
- [ ] 6. Write Merge Danger
```

## 1. Get the diff

Get the diff as the "Get the diff" section of `ace/CODE_HOSTING.md` says. If that file or that section is missing, stop and say which one is missing.

Stop if the diff is empty and there is no untracked work. Also read call sites the change affects, not only the moved lines.

## 2. Scan

### Logic

Wrong behavior on a plausible input.

- Off-by-one or wrong bounds
- Impossible or unreachable branches
- Inverted conditions
- Incorrect async/await, or missing error handling that loses failures
- Wrong database or API assumptions
- Type or logic contradictions
- Stale cache, a wrong cache key, or invalidation that serves the wrong data
- User-visible or data-affecting incorrect behavior

Drop concurrency, races, and missing locks or transactions unless the impact is severe. Severe means money charged twice, data or messages reaching the wrong user or tenant, or stored data permanently wrong. Two tasks touching the same record is not a finding.

### Security

A concrete exposure to an outsider, or to another user or tenant.

- Exposed secrets
- XSS or other unescaped output
- Insecure API endpoints
- Server-side handlers with missing or weak auth
- Injection
- Path traversal
- SSRF or unsafe URL handling in server-side requests

### Performance

New runtime cost this diff adds on a real path.

- Extra database reads or writes on a request or background-job path
- A direct read that bypasses a cached helper the codebase already has for that data. Call the cached helper.
- N+1 queries, or per-item network
- Sequential awaits that can run in parallel
- Extra data sent to the client
- Work on a hot path that can run in the background
- Scanning more data than the path needs

Leave out micro-optimizations with no hot path, reads required for correctness, and what the framework or compiler already optimizes.

### Architecture

The same change, simpler or as a deep module. Flag the concrete better shape.

- Same job in fewer layers, files, or types (about a quarter the size)
- Shallow module: the surface is as complex as the implementation, or callers reach internals
- New logic in the wrong module (another feature, a shared module, or a package already in play)
- Speculative layer, or a second pattern beside one that already works

Propose a redesign only for files this diff changes.

## 3. Drop out of scope

Drop anything that is only style, naming, folder placement, or "the spec didn't ask for this".

Keep a logic bug whose fix uses data already in memory. If the only fix is extra runtime cost, that is a performance finding when this diff introduced the cost, not a logic finding.

## 4. Fix what needs no decision

Fix a logic, security, or performance finding when one edit is the correct one and a teammate would not have to choose. Leave architecture findings. Leave a finding when two fixes are reasonable, or when the edit would change a product decision, a public contract, or a stored data shape.

**Example (fix).** An inverted condition sends the message to the wrong user. Swap the condition.

**Example (leave).** The same read could move to a background job or stay on the request. Write it as a finding.

One commit for every fix in this pass. When you change files, run every command in the "Checks" section of `ace/VERIFY.md`, and of each package verify file its "Packages" section lists for the changed paths. Fix failures until they pass.

If a fix still fails those checks, drop that fix and write it as a finding. Commit only when at least one fix qualifies.

Commit with a conventional title, `fix:` or `perf:`, and a short reason.

## 5. Write what remains

A committed fix is not a finding. Write a finding for what you left.

Each finding is an emoji, then **severity** and category, then one or two sentences, then **Best fix.** and the concrete change. Use exactly the emoji listed for that severity. Write each finding as plain top-level paragraphs in the shape below, outside any GitHub alert or `>` blockquote.

- `blocker` is 🔴. You would block the merge. A secret is exposed, an outsider or another user or tenant can reach data or act, money is charged twice, data or messages reach the wrong user or tenant, stored data is permanently wrong, or a hot-path cost will hurt in production.
- `should-fix` is 🟡. You would ask a teammate to change it. Wrong behavior on a narrower path, a real hole that needs an extra condition, extra cost on a real path, or a simpler or deeper design this change should have used.
- `nit` is 🔵. Concrete and worth the author's time. Optional.

```
🔴 **blocker** logic. One or two sentences.

**Best fix.** The concrete change.

`path/to/file.ts:42`
```

`path` is the repo-relative path. `line` is the line in the new file after this pass's commit. The category is `logic`, `security`, `performance`, or `architecture`. `should-fix` uses 🟡. `nit` uses 🔵.

Prefer fewer findings.

When you committed, start the output with the fixed list and nothing around it. One bullet per fix. One clause with the path and the change only.

```
Fixed:

- `path/to/file.ts`: what changed
```

Then the remaining findings, if any. When you committed and nothing remains, that list is the output before Merge Danger.

When you did not commit and nothing remains, write `No findings.` before Merge Danger.

Go straight from the last finding to Merge Danger.

## 6. Write Merge Danger

Always write this block last. It is not a finding. Return it to the caller only.

```
## Merge Danger

**Door:** one-way or two-way

**Blast Radius:** one word
```

Door is `two-way` when going back is easy and possible: a revert restores the previous behavior, and leftover stored data, sent messages, or a public contract change do not remain. Otherwise write `one-way`. Door takes only these two values.

Blast Radius is one word for the largest area this merge can affect.

Add a sentence after Door or Blast Radius only when it adds information those labels do not already say.
