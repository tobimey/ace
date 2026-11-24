---
name: ace-verify
description: Proves the current change works by running the project's checks and trying the changed behavior.
disable-model-invocation: true
---

# Verify

Prove the current change works. Done means every "Checks" command passes with real evidence, each added or altered behavior was tried and observed working, and the report states what ran, what was seen, and any verify file updates.

## Constraints

- Verify as `ace/VERIFY.md` says, plus each package verify file for the paths the change touches, found as [PACKAGES.md](../ace-mode/shared/adapters/contract/PACKAGES.md) says.
- Read only for the verify files, so the change stays what the user asked for. Step 5 proposes their changes in the report.
- A passing check proves the check, not the behavior. Every check and behavior proof needs evidence that could have failed: an exit status with a non-zero test or check count, or concrete observed output. A check that ran zero tests fails.
- Make a failing check or test pass by fixing the code. Keep every check, test, and hook as strict as you found it, and let hooks run.
- A failure that also happens without this change is pre-existing. Report it and leave it as it is.
- Stop every process you started.

## Workflow

When your harness can start sub-agents, run steps 2 and 3 in one sub-agent so raw test, build, and browser logs stay out of the main context; return only the Report block (plus exact failing output on failure). When it cannot, run them yourself and trim verbose passing output.

```
- [ ] 1. Get the change
- [ ] 2. Run the checks
- [ ] 3. Try the behavior
- [ ] 4. Fix and repeat
- [ ] 5. Propose verify file changes
- [ ] 6. Report
```

## 1. Get the change

Use the change the caller gave. Otherwise get the diff as the "Get the diff" section of [PULL_REQUESTS.md](../ace-mode/shared/adapters/github/PULL_REQUESTS.md) says. List each behavior the change adds or alters.

## 2. Run the checks

Run every command in the "Checks" section of each verify file from the constraints. Record each exit status and test or check count.

## 3. Try the behavior

Start the app per "Run the app". For each behavior from step 1, run the matching "Check behavior" ready command (installing the tool if it fails), try the behavior, and observe the result.

When no line matches a behavior, a line's tool cannot run here, or a step of the "Run the app" or "Check behavior" section fails because the file is wrong, such as a wrong port or start order, pick a tool as "Pick the tool" in [contract/VERIFY.md](../ace-mode/shared/adapters/contract/VERIFY.md) says. Try the behavior that way and note the way for step 5.

When you try a behavior in a browser, save a screenshot of what you saw to a temp folder outside the repository, such as one from `mktemp -d`, and note its path for the report.

When the change has no runtime behavior (docs, comments, types only), write that and skip this step. When a behavior cannot be tried here, write exactly what is missing, such as a login or a service, and the line the verify file needs once it is there. List it under Not verified.

## 4. Fix and repeat

On any failure, fix it and go back to step 2. Stop when the same failure survives two fixes, or after five total fix cycles without passing. Report what you tried and what fact or decision is missing.

## 5. Propose verify file changes

For each way noted in step 3, propose one line for the matching verify file (package verify file if inside a package, else `ace/VERIFY.md`), matching its format: change kind, tool and ready command, entry point, and what to check. Quote any replaced line. Skip when nothing was noted.

When `ace/VERIFY.md` is missing, propose the whole file from [templates/VERIFY.md](../ace-setup/templates/VERIFY.md), also when you noted nothing: "Checks" with the commands you ran in step 2, "Run the app" with how you started the app, or `None.`, and "Check behavior" with each way that worked in step 3. Offer `ace-setup` as the other way to write it.

When the user says yes, make those edits as their own change, apart from the change you verified, and tell the user to commit them on their own. When this work gets a pull request, `ace-open-pr` copies the proposal into its body, so a person finds it also after a run nobody watched.

## 6. Report

Omit `Verify file, proposed` and `Not verified` when empty. When called inside a multi-step chat run, fold this into the combined reply (one short pass line when everything passed, plus only failures, unverified items, or proposed verify-file lines).

```
Checks:
- `command`: pass or fail, with count or output summary

Behavior:
- What you did, and the concrete output you saw. For a browser check, add the screenshot path.

Verify file, proposed:
- `path`: the line to add, or the line to fix and its replacement

Not verified: what and why
```
