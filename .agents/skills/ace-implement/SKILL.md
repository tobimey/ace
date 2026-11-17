---
name: ace-implement
description: Implements a given plan, spec, or ticket with the smallest change that does the job.
disable-model-invocation: true
---

# Implement

Implement the plan, spec, or ticket the caller gives. Done means each behavior the plan names works and has a test, one that failed before the change for a new behavior and passed before it for a kept one, nothing outside the request was built, and `ace-verify` passes.

## Requires

- `ace-verify`

## Approach

Aim for ambitious ideas, simple systems, and software that feels obvious.

- Measure twice, cut once. Understand the real constraint before writing code.
- Find the smallest model that makes the correct behavior unsurprising, then build that.
- Question existing complexity. Find out why it is there, then remove it when the reason no longer holds.
- Make the change easy, then make the easy change. When the code makes the change awkward, refactor first with the tests green, then add the behavior. Keep the two steps apart.
- When the change spans several layers, get one thin path working end to end first, then fill in the rest.
- Build only what this request needs now, at the plainest shape that does it.
- Honor the developer's intent in a minimal and realistic way.

## Constraints

- Build only what the plan asks for. Name anything else you noticed in the report.
- Leave every change uncommitted. The user commits, or `ace-open-pr` does when the user asks for a pull request.
- Look up facts in the code yourself. Ask only for decisions the plan leaves open.
- The plan sets the tests. Give each behavior and edge case it names its own test, and test only those.
- Test only through the public interface, so a refactor keeps tests green.
- Past decisions in tickets, ADRs in `ace/adrs/`, docs, or comments explain the current state. When the plan contradicts one, follow the plan, and update or delete a contradicted doc or comment in the same change. Keep a contradicted ADR: set its Status to `Superseded` and name the plan or ticket that replaced it.

## Workflow

1. Read the plan and the code it touches. List each behavior the plan names. When the plan keeps behavior the same, such as a refactor or a speedup, those are the behaviors the touched code has now.
2. Pick the smallest shape that does the job.
3. Build it in slices. For each behavior:
   1. Write a test for it and run it. A new or changed behavior fails: note the line of the red run that says why, such as the assertion message. A kept behavior passes, and when it already has a test, use that test as it is.
   2. Write the least code that makes it pass.
   3. Clean up while the tests stay green.

   Skip the test when the behavior has no logic to test, such as layout, config, or wiring, or when the "Checks" section of `ace/VERIFY.md`, and of each package verify file for the touched path, has no test command. Name each skipped test in the report.
4. Follow [ace-verify](../ace-verify/SKILL.md). Fix and repeat until it passes.
5. Report what changed, which tests you added or skipped, what was left out on purpose, and the `ace-verify` report. For each new or changed behavior, give the test name and the line its red run printed before the code existed.
