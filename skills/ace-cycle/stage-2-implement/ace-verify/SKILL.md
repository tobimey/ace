---
name: ace-verify
description: Proves the current change works by running the project's checks and trying the changed behavior. Use when the user or another skill asks to verify, test, or check that a change works.
---

# Verify

Prove the current change works. Done means every command in the "Checks" section passes, each behavior the change adds or alters was tried and seen working, and the report says what ran and what was seen.

## Constraints

- Verify only as `ace/VERIFY.md` says, plus the package file its "Packages" section names for each path the change touches. If a file or one of its sections is missing, stop and say which one is missing.
- A passing check proves the check, not the behavior. Do not report behavior as working until you have tried it.
- Do not weaken, skip, or delete a check or a test to make it pass. Do not skip hooks.
- A failure that also happens without this change is pre-existing. Report it. Do not fix it.
- Stop every process you started.

## Workflow

```
- [ ] 1. Get the change
- [ ] 2. Run the checks
- [ ] 3. Try the behavior
- [ ] 4. Fix and repeat
- [ ] 5. Report
```

## 1. Get the change

Use the change the caller gave. Otherwise get the diff as the "Get the diff" section of `ace/CODE_HOSTING.md` says. List each behavior the change adds or alters.

## 2. Run the checks

Run every command in the "Checks" section of each verify file from the constraints. Note each result.

## 3. Try the behavior

Start the app as the "Run the app" section says. For each behavior from step 1, try it as the matching line of the "Check behavior" section says, and look at the result.

When the change has no runtime behavior (docs, comments, types only), write that and skip this step. When a behavior cannot be tried here, write exactly what is missing, such as a login or a service. Do not count it as verified.

## 4. Fix and repeat

On any failure, fix it and go back to step 2. When the same failure survives three fixes, stop and report it.

## 5. Report

```
Checks:
- `command`: pass or fail

Behavior:
- What you did, and what you saw.

Not verified: what and why, or "none"
```
