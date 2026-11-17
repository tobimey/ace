---
name: ace-verify
description: Proves the current change works by running the project's checks and trying the changed behavior.
disable-model-invocation: true
---

# Verify

Prove the current change works. Done means every command in the "Checks" section passes, each behavior the change adds or alters was tried and seen working, the verify file holds each way to try a behavior that worked, and the report says what ran and what was seen.

## Constraints

- Verify as `ace/VERIFY.md` says, plus each package verify file for the paths the change touches, found as "Package folders" in [ADAPTERS.md](../ace-adapters/ADAPTERS.md) says. When those files have no way to try a behavior, or a way they give is wrong, find one that works and write it back in step 5.
- In the verify files, change only the lines of the "Run the app" and "Check behavior" sections that step 5 names. When `ace/VERIFY.md` is missing, create it in step 5 instead.
- A passing check proves the check, not the behavior. Report behavior as working only after you have tried it.
- Make a failing check or test pass by fixing the code. Keep every check, test, and hook as strict as you found it, and let hooks run.
- A failure that also happens without this change is pre-existing. Report it and leave it as it is.
- Stop every process you started.
- Keep screenshots out of the repository.

## Workflow

```
- [ ] 1. Get the change
- [ ] 2. Run the checks
- [ ] 3. Try the behavior
- [ ] 4. Fix and repeat
- [ ] 5. Update the verify file
- [ ] 6. Report
```

## 1. Get the change

Use the change the caller gave. Otherwise get the diff as the "Get the diff" section of `ace/CODE_HOSTING.md` says. List each behavior the change adds or alters.

## 2. Run the checks

Run every command in the "Checks" section of each verify file from the constraints. Note each result.

## 3. Try the behavior

Start the app as the "Run the app" section says. For each behavior from step 1, try it as the matching line of the "Check behavior" section says, and look at the result.

When no line of the "Check behavior" section matches a behavior, or a step of the "Run the app" or "Check behavior" section fails because the file is wrong, such as a wrong port or start order, find a way that works with the tools this environment has, such as browser automation, `curl`, or the CLI. Try the behavior that way and note the way for step 5.

When you try a behavior in a browser, save a screenshot of what you saw to a temp folder outside the repository, such as one from `mktemp -d`, and note its path for the report.

When the change has no runtime behavior (docs, comments, types only), write that and skip this step. When a behavior cannot be tried here, write exactly what is missing, such as a login or a service, and the line the verify file needs once it is there. List it under Not verified.

## 4. Fix and repeat

On any failure, fix it and go back to step 2. When the same failure survives three fixes, stop and report it.

## 5. Update the verify file

For each way you noted in step 3, add or fix one line in the file that covers the touched path: the package verify file for a path in a package, otherwise `ace/VERIFY.md`. Write it like the lines around it: the kind of change, the tool, where to start, such as a URL, an endpoint, or a command, and what to look at. When you noted nothing, skip this step.

When `ace/VERIFY.md` is missing, create it from [templates/VERIFY.md](../ace-setup/templates/VERIFY.md), also when you noted nothing. Fill "Checks" with the commands you ran in step 2, "Run the app" with how you started the app, or `None.`, and "Check behavior" with each way that worked in step 3. Leave package verify files to `ace-setup`. Tell the user to read the new file and fix what is wrong.

## 6. Report

```
Checks:
- `command`: pass or fail

Behavior:
- What you did, and what you saw. For a behavior tried in a browser, the screenshot path.

Verify file:
- `path`: the line added or fixed, or "none"

Not verified: what and why, or "none"
```
