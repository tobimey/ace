# Standards check

Does the change follow the project's coding standards.

## Before scanning

Read `ace/CODING_STANDARDS.md` in full, plus each package `CODING_STANDARDS.md` for the changed paths, found as [PACKAGES.md](../ace-mode/shared/adapters/contract/PACKAGES.md) says.

## Find

Match the diff against those rules. Each of these is a finding:

- A break of a rule in those files.
- A listed smell when the better shape is obvious and keeps behavior identical. Earlier rules win.
- A tautological test that cannot fail. Best fix: delete the test or drop incidental asserts, keeping production behavior identical.
- A weakened check: a deleted or skipped test, a lint or type suppression, or a loosened check, hook, or CI rule added to make checks pass when the ticket did not ask for it.

## Drop

- What the repo's linter and type checker already enforce.
- A style or smell fix that would change behavior. Keep standards auto-fixes as pure refactors.

## Severity

- A weakened check is `blocker`, with fix type `needs-a-person`.
- A rule break or a tautological test is `should-fix`.
- A smell is `nit`.
