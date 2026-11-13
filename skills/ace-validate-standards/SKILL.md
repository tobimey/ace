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
- Skip anything `pnpm lint` or `pnpm typecheck` already enforces.
- A smell in the coding standards is a judgement call. Fix it only when the better shape is obvious and the edit keeps the same behavior. An earlier rule in that file wins.
- A tautological test in this diff is a Tests violation. Delete that `it`, or drop only the incidental asserts, as the Tests section of the coding standards says. Production behavior stays the same. Do not load `ace-gardening-tautological-tests`.
- You may follow one `ace-gardening-*` skill when that skill is the behavior-identical fix for a violation in this diff. Do not run `ace-gardening-deps`, `ace-gardening-catalog-deps`, or `ace-gardening-docs-check`. Do not run a report-only gardening skill as a commit. Do not garden the rest of the repo.
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

Read the coding standards in full, including Tests and Smells. Read the Code section of `AGENTS.md`. Match the diff against those rules. Ignore `/utility` routes and generated shadcn files under `packages/ui/src/components/shadcn/`.

## 3. Apply safe fixes, or write that none were safe

When you change files, run these from the repo root and fix failures until they pass:

```bash
pnpm lint
pnpm test
pnpm typecheck
pnpm knip
pnpm build
```

Commit with a conventional title, `refactor:` and a short reason. Write what changed and why.

When nothing is safe to edit, do not commit. Write only `No standards edit was safe.` No notes about files this change does not touch.
