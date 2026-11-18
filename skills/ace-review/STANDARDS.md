# Standards check

Does the change follow the project's coding standards.

## Before scanning

Read `ace/CODING_STANDARDS.md` in full, plus each package `CODING_STANDARDS.md` for the changed paths, found as [PACKAGES.md](../ace-adapters/contract/PACKAGES.md) says.

## Find

Match the diff against those rules. Each of these is a finding:

- A break of a rule in those files.
- A smell those files list, when the better shape is obvious and keeps the same behavior. An earlier rule in that file wins over a later one.
- A tautological test in this diff, one that cannot fail. The best fix deletes that test case, or drops only the incidental asserts. Production behavior stays the same.

## Drop

- What the repo's linter and type checker already enforce.
- A fix that would change behavior. A standards fix is a refactor only.

## Belongs elsewhere

Logic bugs, security holes, performance costs, and architecture belong to [Code](CODE.md). Spec match belongs to [Spec](SPEC.md).

## Severity

- A rule break or a tautological test is `should-fix`.
- A smell is `nit`.

## Fix type

- `one-correct-fix` when the refactor has one obvious shape.
- `several-fixes` when more than one shape fits the rule.
