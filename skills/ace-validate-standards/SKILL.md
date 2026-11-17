---
name: ace-validate-standards
description: Commits behavior-identical coding-standards fixes in the current change.
disable-model-invocation: true
---

# Standards

Bring the diff in line with the coding standards. Done means every safe edit is made: committed when the caller passed a pull request, left uncommitted on a local diff.

## Constraints

- Refactor only. Same control flow, same return values, same queries, same cache keys, same auth, same visible data.
- Edit only files this change touches.
- Fix only coding-standards breaks. Logic bugs, security holes, performance, and architecture belong to `ace-review`. Spec match belongs to `ace-check-spec`.
- Leave to the repo's linter and type checker whatever they already enforce.
- A smell in the coding standards is a judgement call. Fix it only when the better shape is obvious and the edit keeps the same behavior. An earlier rule in that file wins.
- A tautological test in this diff (one that cannot fail) is a standards violation. Delete that test case, or drop only the incidental asserts. Production behavior stays the same.
- On a pull request, commit the whole standards pass as one commit. On a local diff, leave your edits uncommitted. The user commits.

## Workflow

```
- [ ] 1. Get the diff
- [ ] 2. Read the standards and the diff
- [ ] 3. Apply safe fixes, or write that none were safe
```

## 1. Get the diff

Get the diff as the "Get the diff" section of `ace/CODE_HOSTING.md` says.

Stop if there is no diff. On a pull request, also stop if the working tree has uncommitted changes.

## 2. Read the standards and the diff

Read `ace/CODING_STANDARDS.md` in full, plus each package file its "Packages" section lists for the changed paths. Match the diff against those rules. Ignore generated and vendored code, and any path the coding standards mark as out of scope.

## 3. Apply safe fixes, or write that none were safe

When you change files, run every command in the "Checks" section of `ace/VERIFY.md`, and of each package verify file its "Packages" section lists for the changed paths. Fix failures until they pass.

On a pull request, commit with a conventional title, `refactor:` and a short reason. Write what changed and why.

When no edit is safe, change nothing and write only `No standards edit was safe.`
