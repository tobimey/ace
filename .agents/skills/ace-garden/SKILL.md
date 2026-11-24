---
name: ace-garden
description: Makes one small cleanup in one scope, for a topic such as naming, comments, tautological tests, pass-through code, outdated dependencies, or a custom check in ace/checks/.
disable-model-invocation: true
---

# Garden

Make one small cleanup for the topic the caller names, in one scope, with behavior unchanged. Done means one finding is fixed and `ace-implement` passed, or no finding has a clean fix and the report names up to three candidates.

## Requires

- `ace-mode`, for its [CODEBASE_DESIGN.md](../ace-mode/shared/codebase-design/CODEBASE_DESIGN.md)
- `ace-implement`

## Topics

- [Naming](NAMING.md): names that hide why a thing exists or what it does.
- [Comments](COMMENTS.md): tautological, stale, or excuse comments and unjustified suppressions.
- [Tests](TESTS.md): tests that cannot fail.
- [Pass-through](PASS_THROUGH.md): wrappers and values that only forward.
- [Deps](DEPS.md): outdated dependencies, bumped as one batch.
- Custom: each check in `ace/checks/`, by its name, such as `caching` for `ace/checks/CACHING.md`. Its Before scanning, Find, and Drop sections serve as the topic file, and the fix is the smallest change that clears the finding. A check that says every finding needs a person runs as a report.

## Constraints

- Fix one finding per run: one cluster of names, one file's comments, one test file, one wrapper or chain, or one batch of bumps. Leave the rest to later runs.
- Change only the code the fix needs. Behavior stays the same.
- Skip the paths the coding standards mark out of scope.
- Start from a clean working tree. When it holds unrelated changes, stop and say so.
- Report a finding as a candidate when its fix needs a product decision, changes a public interface or stored data, or spans several features.
- When the caller asks for a report, change no file: list every kept finding, clearest fix first, after step 3.

## Workflow

1. **Pick the topic and scope.** Run the topic the caller names. When it names none, ask which and list the topics. With nobody to ask, stop and name them. The scope is the folder, feature, or files the caller names. Otherwise it is the folder that changed most in the commit history of the last few months. Deps always covers the whole repository.
2. **Scan.** Read the topic file, do its Before scanning section, then find what its Find section lists in the scope.
3. **Drop and pick.** Apply its Drop section. Pick the finding with the clearest fix, not the biggest. When none has a clean fix, report up to three candidates and stop.
4. **Fix.** Follow `ace-implement` with the fix as the plan, shaped as the topic's Fix section says. When the fix outgrows the constraints, revert it, report it as a candidate, and stop.

## Report

Omit empty lines (such as Candidates when none exist), and fold Checks into one short line when everything passed.

```
Topic: <topic>, scope: <folder or files>
Fixed: <path and what was wrong, or "nothing">
Change: <what changed, by file>
Candidates for later runs: <path and why>
Checks: <the ace-implement summary>
```

A topic's Report section replaces Change.
