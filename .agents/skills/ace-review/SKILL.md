---
name: ace-review
description: Reviews the current change for spec match, coding standards, and logic, security, performance, and architecture. Fixes what the review settings allow, writes the rest as findings, and writes Merge Danger.
disable-model-invocation: true
---

# Review

Review the diff with up to three checks, fix what the review settings allow, and write the rest as findings. Done means each picked check ran, each fix the settings allow is made or written as a finding, the commands in the "Checks" section of `ace/VERIFY.md` pass after the fixes, the fixes are committed when the caller passed a pull request, and the report ends with Merge Danger.

## Requires

- `ace-checks`

## Checks

Each check file says what to find and drop, and how to rate a finding:

- [Spec](SPEC.md): does the change do what its linked ticket asked.
- [Standards](STANDARDS.md): coding-standards breaks.
- [Code](CODE.md): logic bugs, security holes, performance costs, and architecture.

Run the checks the caller names, such as `spec` or `standards code`. With none named, run all three.

## Settings

Read `review` in `ace/config.json` as `ace-adapters` says. A missing file or key uses the default in brackets. A missing `fixes` takes its value from `autonomy`.

- `agents` (`one-for-all-checks`): `one-for-all-checks` runs every check yourself, one after another. `one-per-check` runs each check in a fresh sub-agent, so one check's reading does not sway the next. When your harness cannot start sub-agents, run the checks yourself and say so in one line of the report.
- `fixes` (`simple-only`): which findings get fixed, by fix type, as step 3 says.
- `fix_severities` (`["blocker", "should-fix", "nit"]`): only findings with one of these severities get fixed.

`review.runs` says when a review starts. `ace-mode` and the review workflow read it. This skill does not.

## Constraints

- Finding is read only. Only step 4 changes files.
- Edit only files this change touches.
- On a pull request, commit your fixes. On a local diff, leave them uncommitted. The user commits.
- Ignore generated and vendored code, and any path the coding standards mark as out of scope.
- A finding needs a concrete failure, cost, gap, or rule break in this diff. Leave out hypotheticals, pre-existing issues the diff does not make worse, and accepted risks.

## Workflow

```
- [ ] 1. Get the diff
- [ ] 2. Find
- [ ] 3. Pick the fixes
- [ ] 4. Fix
- [ ] 5. Run the checks
- [ ] 6. Commit
- [ ] 7. Report
```

### 1. Get the diff

Get the diff once, as the "Get the diff" section of `ace/CODE_HOSTING.md` says. Every check reads this diff.

Stop if the diff is empty and there is no untracked work. On a pull request, also stop when the working tree has uncommitted changes.

### 2. Find

Run each picked check as its file says, in the order of the list above. With `one-per-check`, give each sub-agent the diff, its check file, the Constraints above, and the Finding section below. Tell it to change no file and to return its findings, and for Spec its result line.

Merge the findings. When two findings name the same problem, keep the one in the category that owns it, as the Belongs elsewhere section of each check file says.

### 3. Pick the fixes

A finding gets fixed when its severity is in `fix_severities` and its fix type allows it under `fixes`:

| Fix type | `none` | `simple-only` | `all` |
|---|---|---|---|
| `one-correct-fix` | finding | fixed | fixed |
| `several-fixes` | finding | finding | fixed, with the fix you judge best |
| `needs-a-person` | finding | finding | finding |

Every other finding stays a finding. When no finding gets fixed, go to step 7.

### 4. Fix

Make the picked fixes yourself, in this agent, also when the checks ran in sub-agents, so no two edits collide. A standards fix keeps behavior identical: the same control flow, return values, queries, cache keys, auth, and visible data. Note for each fix whether it came from Standards or Code.

### 5. Run the checks

Run every command in the "Checks" section of `ace/VERIFY.md`, and of each package verify file for the changed paths, found as "Package folders" in [ADAPTERS.md](../ace-adapters/ADAPTERS.md) says. Run them once, after all fixes.

When a command fails, revert fixes until the commands pass, Code fixes before Standards fixes. Revert one fix at a time when that keeps the fixes that pass. Each reverted fix becomes a finding, with that fix as its best fix. When a command still fails with every fix reverted, the failure is not from this review. Name the command in the report.

### 6. Commit

On a pull request, commit the fixes that remain, in up to two commits:

- Standards fixes: a conventional title, `refactor:`, and a short reason.
- Code fixes: a conventional title, `fix:` or `perf:`, and a short reason.

On a local diff, leave them uncommitted.

### 7. Report

Write the parts below in this order, as plain top-level paragraphs, outside any alert box or `>` blockquote. Prefer fewer findings.

1. **Spec.** The result line from [SPEC.md](SPEC.md). Leave it out when Spec did not run.
2. **Fixed.** When you fixed something, the fixed list. One bullet per fix, one clause with the path and the change only.

   ```
   Fixed:

   - `path/to/file.ts`: what changed
   ```

3. **Findings.** Each finding left, in the shape the Finding section gives. When you fixed nothing and nothing is left, write `No findings.`
4. **Merge Danger.** As its section below says.

Go straight from the last finding to Merge Danger.

## Finding

Each finding has:

- **Severity**: `blocker`, `should-fix`, or `nit`, as its check file rates it.
  - `blocker` is 🔴. You would block the merge.
  - `should-fix` is 🟡. You would ask a teammate to change it.
  - `nit` is 🔵. Concrete and worth the author's time.
- **Category**: `spec`, `standards`, `logic`, `security`, `performance`, or `architecture`.
- **Fix type**:
  - `one-correct-fix`: one edit is correct, and a teammate would not have to choose.
  - `several-fixes`: two or more fixes are reasonable.
  - `needs-a-person`: the fix changes a product decision, a public contract, or a stored data shape, or the check file says its findings always need a person.
- **Best fix**: the concrete change.
- **Location**: `path:line`. `path` is repo-relative. `line` is the line in the new file after this review's fixes.

Write a finding left for the report as an emoji, then **severity** and category, then one or two sentences, then **Best fix.** and the change, then the location. Use exactly the emoji listed for its severity.

```
🔴 **blocker** logic. One or two sentences.

**Best fix.** The concrete change.

`path/to/file.ts:42`
```

## Merge Danger

Always write this block last. It is not a finding. Return it to the caller only.

```
## Merge Danger

**Door:** one-way or two-way

**Blast Radius:** module, feature, or product
```

Door is `two-way` when going back is easy and possible: a revert restores the previous behavior, and leftover stored data, sent messages, or a public contract change do not remain. Otherwise write `one-way`. Door takes only these two values.

Blast Radius is the largest area this merge can break. It takes only these three values:

- `module`: one function, module, or call path, and the callers in this diff
- `feature`: one feature and the people who use it
- `product`: the whole product, every user, or a shared module many features depend on

Count stored data, external services, and shared contracts as part of every feature that reads them.

Add a sentence after Door or Blast Radius only when it adds information those labels do not already say.
