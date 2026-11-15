---
name: ace-validate-standards
description: Commits behavior-identical coding-standards fixes in the current change.
disable-model-invocation: true
---

# Standards

Bring the diff in line with the coding standards. Done means any safe edits are committed.

## Constraints

- Refactor only. Same control flow, same return values, same queries, same cache keys, same auth, same visible data.
- Edit only files this change touches.
- Do not flag logic bugs, security holes, performance, spec match, or architecture. Architecture findings belong to `ace-review`.
- Skip anything the repo's linter or type checker already enforces.
- A smell in the coding standards is a judgement call. Fix it only when the better shape is obvious and the edit keeps the same behavior. An earlier rule in that file wins.
- A tautological test in this diff (one that cannot fail) is a standards violation. Delete that test case, or drop only the incidental asserts. Production behavior stays the same.
- Do not clean up the rest of the repo.
- One commit for the whole standards pass.

## Workflow

```
- [ ] 1. Resolve the diff
- [ ] 2. Read the standards and the diff
- [ ] 3. Apply safe fixes, or write that none were safe
```

## 1. Resolve the diff

When the caller passed a diff, use it. When the caller passed a pull request and no diff, use `gh pr diff`. When the caller passed a base ref and no diff and no pull request, diff against that ref. In those cases, do not diff the checkout this run woke up on against the default branch.

When the caller passed none of those, diff the current branch against the default branch (`origin/main`, then `main`):

```bash
git diff "$(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main)"
```

Stop if there is no diff. Stop if the working tree has changes you did not just make for this pass.

## 2. Read the standards and the diff

Read `ace/CODING_STANDARDS.md` in full and `ace/AGENTS.md`. Match the diff against those rules. Ignore generated and vendored code, and any path the project's `ace/` files mark as out of scope.

## 3. Apply safe fixes, or write that none were safe

When you change files, run the repo's checks (lint, typecheck, tests, build, and any other check its CI runs) and fix failures until they pass. Find the commands in `ace/AGENTS.md`, the build config, or the CI workflow.

Commit with a conventional title, `refactor:` and a short reason. Write what changed and why.

When nothing is safe to edit, do not commit. Write only `No standards edit was safe.` No notes about files this change does not touch.
