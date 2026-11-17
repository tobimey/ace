---
name: ace-review
description: Reviews the current change, fixes or suggests what has one correct edit, writes the rest as findings, and writes Merge Danger.
disable-model-invocation: true
---

# Review

Review the diff for logic bugs, security holes, performance costs, and architecture. Done means each fix that needs no decision is made, and committed when the caller passed a pull request, every finding that needs a person is written with a severity and a best fix, and Merge Danger is written.

When `review_fixes` in `ace/config.json` is `suggest`, change no file: each fix that needs no decision is written as a finding instead. A missing file or key means `apply`.

## Requires

- `ace-checks`

## Constraints

- Edit only files this change touches.
- On a pull request, commit your fixes. On a local diff, leave them uncommitted. The user commits.
- Flag only logic, security, performance, and architecture. Coding standards, naming, and code smells belong to `ace-validate-standards`. Spec match belongs to `ace-check-spec`.
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

Get the diff as the "Get the diff" section of `ace/CODE_HOSTING.md` says.

Stop if the diff is empty and there is no untracked work. Also read call sites the change affects, not only the moved lines.

## 2. Scan

Load [ace-checks](../ace-checks/SKILL.md) and read its Logic, Security, Performance, and Architecture files. In the diff and the call sites it affects, find what each file's Find section lists. Follow the Framework behavior section of the Performance file. File a finding under the domain its Belongs elsewhere section names.

For architecture, flag the concrete better shape, and propose a redesign only for files this diff changes.

## 3. Drop out of scope

Apply the Drop section of each `ace-checks` file. Drop anything that is only style, naming, folder placement, or "the spec didn't ask for this".

If a logic bug's only fix is extra runtime cost, write it as a performance finding when this diff introduced the cost, and drop it otherwise.

## 4. Fix what needs no decision

Skip this step when `review_fixes` is `suggest`. Each finding goes to step 5, with the one correct edit as its best fix.

Fix a logic, security, or performance finding when one edit is the correct one and a teammate would not have to choose. Leave architecture findings. Leave a finding when two fixes are reasonable, or when the edit would change a product decision, a public contract, or a stored data shape.

**Example (fix).** An inverted condition sends the message to the wrong user. Swap the condition.

**Example (leave).** The same read could move to a background job or stay on the request. Write it as a finding.

When you change files, run every command in the "Checks" section of `ace/VERIFY.md`, and of each package verify file its "Packages" section lists for the changed paths. Fix failures until they pass.

If a fix still fails those checks, drop that fix and write it as a finding.

On a pull request, put every fix from this pass in one commit, with a conventional title, `fix:` or `perf:`, and a short reason.

## 5. Write what remains

A fix you made is not a finding. Write a finding for what you left.

Each finding is an emoji, then **severity** and category, then one or two sentences, then **Best fix.** and the concrete change. Use exactly the emoji listed for that severity. Write each finding as plain top-level paragraphs in the shape below, outside any alert box or `>` blockquote.

Rate each finding by the Severity section of its `ace-checks` file, then write that level as:

- `blocker` is 🔴. Critical, or High outside architecture. You would block the merge.
- `should-fix` is 🟡. Medium, or High architecture. You would ask a teammate to change it.
- `nit` is 🔵. Low. Concrete and worth the author's time.

```
🔴 **blocker** logic. One or two sentences.

**Best fix.** The concrete change.

`path/to/file.ts:42`
```

`path` is the repo-relative path. `line` is the line in the new file after this pass's fixes. The category is `logic`, `security`, `performance`, or `architecture`. `should-fix` uses 🟡. `nit` uses 🔵.

Prefer fewer findings.

When you fixed something, start the output with the fixed list and nothing around it. One bullet per fix. One clause with the path and the change only.

```
Fixed:

- `path/to/file.ts`: what changed
```

Then the remaining findings, if any. When you fixed something and nothing remains, that list is the output before Merge Danger.

When you fixed nothing and nothing remains, write `No findings.` before Merge Danger.

Go straight from the last finding to Merge Danger.

## 6. Write Merge Danger

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
