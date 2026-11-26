# Multiple tickets: split and publish

Loaded by [SKILL.md](SKILL.md) only when multiple-ticket mode is chosen.

### 3b. Explore (optional)

If you have not already explored the codebase, do so to understand current state. Look for prefactors that make implementation easier: make the change easy, then make the easy change.

### 3c. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests): vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window and one pull request (see single-ticket mode in [SKILL.md](SKILL.md))
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges**: other tickets that must complete before it can start. A ticket with no blockers can start immediately.

For **wide refactors**, sequence expand, then contract. First expand: add the new form beside the old so nothing breaks. Migrate call sites in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green because the old form still exists. Contract: delete the old form once no caller remains, blocked by every migrate batch. When batches cannot stay green alone, use a shared integration branch and block a final integrate-and-verify ticket; green is promised only there.

Present the breakdown as a numbered list. For each ticket, show the fields of step 3a and **Blocked by**: which other tickets (if any) must complete first.

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct: does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 4b. Publish

- If the spec is a plan from the conversation, first open the parent. Its Goal and Task come from the plan, and its Done when is the plan's overall acceptance checks.
- Use the parent from step 1, or the one you just opened, as the only parent, and leave its body as it is.

Open one ticket per approved ticket, **blockers first**, so each blocking edge can name a real ticket number. After each create, attach it as a sub-ticket of the parent and set its blockers, both as the ticket tracker says.

Then finish with "Ticket state (both modes)" and "Ticket body (both modes)" in [SKILL.md](SKILL.md).
