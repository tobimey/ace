---
name: ace-implement
description: Implements a given plan, spec, or ticket with the smallest change that does the job.
disable-model-invocation: true
---

# Implement

Implement the plan, spec, or ticket the caller gives. Done means each behavior the plan names works and has a test, nothing outside the request was built, the diff follows the coding standards, and `ace-verify` passes.

## Requires

- `ace-verify`

## Approach

Aim for ambitious ideas, simple systems, and software that feels obvious.

- Question existing complexity. Find out why it is there, then remove it when the reason no longer holds.
- Make the change easy, then make the easy change. When the code makes the change awkward, refactor first with the tests green, then add the behavior. Keep the two steps apart.
- When the change spans several layers, get one thin path working end to end first, then fill in the rest.

## Constraints

- Build only what the plan asks for. Name anything else you noticed in the report.
- Leave every change uncommitted. The user commits, or `ace-open-pr` does when the user asks for a pull request.
- Look up facts in the code yourself. Ask only for decisions the plan leaves open.
- The plan sets the tests. Give each behavior and edge case it names its own test, and test only those.
- Test only through the public interface, so a refactor keeps tests green.
- Check your own change against the coding standards only. Leave the spec, code, and custom checks to `ace-review`, best run by a model other than the one that wrote the change.
- Past decisions in tickets, ADRs in `ace/adrs/`, docs, or comments explain the current state. When the plan contradicts one, follow the plan, and update or delete a contradicted doc or comment in the same change. Keep a contradicted ADR: set its Status to `Superseded by` and the plan or ticket that replaced it, and leave the rest of it as it is.

## Workflow

1. Read the plan and the code it touches. List each behavior the plan names. When the plan keeps behavior the same, such as a refactor or a speedup, those are the behaviors the touched code has now.
2. Pick the smallest shape that does the job and makes the correct behavior unsurprising.
3. Build it in slices. For each behavior:
   1. Write a test for it and run it. For a bug fix or non-trivial logic, confirm it fails before changing code; for a kept behavior, confirm it passes (or reuse its existing test).
   2. Write the least code that makes it pass.
   3. Clean up while the tests stay green.

   Skip the test when the behavior has no logic to test, such as layout, config, or wiring, or when the "Checks" section of `ace/VERIFY.md`, and of each package verify file for the touched path, has no test command. Name each skipped test in the report.
4. Check the diff against the coding standards, as the Before scanning, Find, and Drop sections of the [Standards check](../ace-review/STANDARDS.md) say. Fix each finding yourself, with behavior unchanged.
5. Follow [ace-verify](../ace-verify/SKILL.md). Fix and repeat until it passes.
6. Give one short summary: what changed, plus any skipped tests, fixed coding-standards breaks, intentional omissions, or verify issues. Omit empty items instead of writing "none".
