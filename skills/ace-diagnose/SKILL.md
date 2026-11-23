---
name: ace-diagnose
description: Finds and proves the root cause of a bug before it is fixed.
disable-model-invocation: true
---

# Diagnose

Find why the bug happens, and prove it. Done means one command goes red on this bug, the repro is as small as it gets, one hypothesis is confirmed by a probe, everything you added for the hunt is gone, and the report names the cause and the seam for the regression test. The fix belongs to `ace-implement`.

## Constraints

- Build the loop first. Read code only as needed to locate the entry point or seam for the loop; form root-cause theories only after a loop command has gone red on this bug.
- Change the repository only for loop files and tagged debug lines, and remove them before the report. Keep a failing test only when it sits at the seam the report names.
- Change one variable per probe.
- Find facts yourself. Ask the user only for access, a captured artifact, or a decision.
- Redact every secret in commands, output, and artifacts you show: write `<REDACTED>` in its place. Pass credentials through environment variables.
- Take the test command from the "Checks" section of `ace/VERIFY.md`, how to start the app from "Run the app", and how to try a behavior from "Check behavior". When one is missing, build the loop without it and name the gap in the report.
- Slowness with correct results is out of scope. It belongs to the Perf playbook of `ace-mode`. Tell the user it is a performance problem, not a bug, and stop.

## Workflow

```
- [ ] 1. Build a loop that goes red
- [ ] 2. Shrink the repro
- [ ] 3. Rank hypotheses
- [ ] 4. Probe
- [ ] 5. Clean up
- [ ] 6. Report
```

## 1. Build a loop that goes red

This step decides the outcome. Spend most of the effort here.

A loop is one command that drives the code path of this bug and checks the exact symptom the user reported. Try these, roughly in this order:

1. A failing test at whatever seam reaches the bug.
2. An HTTP request script against the running app.
3. A CLI call with a fixture input, diffed against a known-good output.
4. A browser run that drives the UI with the tool [contract/VERIFY.md](../ace-mode/shared/adapters/contract/VERIFY.md) picks, such as `agent-browser`, and checks the DOM, console, or network.
5. A replay of a captured request, payload, or event log through the code path.
6. A throwaway harness that runs the smallest part of the system that reaches the bug.
7. A fuzz loop over many random inputs, when the bug is "sometimes wrong".
8. A `git bisect run` script, when the bug appeared between two known states.
9. A differential run: the same input through the old and the new version, with the outputs diffed.
10. A human-in-the-loop script, as the last resort. Read `scripts/hitl-loop.template.sh`, copy it outside the repository, fill in the steps, and ask the user to run it in their terminal and paste the Captured block back.

Then tighten it. Make it faster, assert on the exact symptom, and pin what varies: time, random seeds, network, filesystem.

When the bug happens only sometimes, raise the failure rate: run the trigger many times, in parallel, under load, with narrowed timing windows. Keep raising it until the loop goes red often enough to test against.

The loop is done when you have run it, seen it go red, and it:

- fails on the symptom the user described, not on a nearby failure
- gives the same verdict every run, or a high and stable failure rate
- runs in seconds
- runs without a person, except the human-in-the-loop script

When no loop goes red, stop. Report what you tried, and ask the user for one of these: access to an environment where the bug happens, a captured artifact such as a log, a HAR file, or a recording with timestamps, or permission to add temporary logging where it happens.

## 2. Shrink the repro

Cut inputs, callers, config, data, and steps one at a time. Rerun the loop after each cut and keep only what it needs to stay red. Done when removing any remaining part makes the loop pass.

## 3. Rank hypotheses

Write 3 to 5 hypotheses, most likely first, before you test any. Each one states a prediction: "If X is the cause, changing Y makes the bug go away." Drop a hypothesis that predicts nothing.

Show the list to the user and go on without waiting. They may rule one out or reorder them.

## 4. Probe

Test the hypotheses in order. Each probe checks one prediction.

- Use a debugger or REPL when the project has one. Otherwise add logs at the boundaries that tell the hypotheses apart.
- Tag every debug line with one unique prefix, such as `[DEBUG-a4f2]`.

Done when one hypothesis is confirmed: its prediction held, and the probes ruled out the rest. When every hypothesis fails, write new ones from what the probes showed and repeat.

Then find the seam for the regression test: the public interface where a test reproduces the bug as it happens at the real call site. When the only possible test is too shallow to replay the bug, such as a unit test for a bug that needs two callers, there is no seam. Write that as a finding in the report.

## 5. Clean up

1. Search the repository for the debug prefix and remove every line.
2. Delete each loop script and throwaway file you added, except a failing test at the seam from step 4.
3. Check the working tree. It holds only the changes it had before you started, plus that test.

## 6. Report

```
Symptom: what the user saw, as the loop shows it
Loop: `command`, and its red output, redacted
Repro: the smallest input or steps that still fail
Cause: the confirmed hypothesis, its evidence, and (when `communication` is `code`) `path:line` where the code first goes wrong
Ruled out: each other hypothesis, and the probe that ruled it out
Regression test: the seam, and the failing test file when you kept one. Or "no seam", and why
Gaps: missing `ace/VERIFY.md` sections, or "none"
```
