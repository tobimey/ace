---
name: ace-to-ticket
description: Turns a spec into one ticket or several sub-tickets, based on the spec's size.
disable-model-invocation: true
---

# To Ticket(s)

Turn an existing spec into **ticket(s)**. **One ticket** fills the spec ticket itself. **Multiple tickets** are tracer-bullet vertical slices as **sub-tickets** of that parent, each declaring what blocks it.

Read `ace-open-ticket` before any draft. Open every new ticket with it. Follow `ace/TICKET_TRACKER.md` to read and update tickets, and to link sub-tickets and blockers.

## Requires

- `ace-open-ticket`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Constraints (always)

- Leave the parent or spec ticket open.
- Keep ticket bodies in the ticket tracker only.
- Find each adapter section by its job. Its heading may differ from the one named here. If a file or a section is missing, name it and say what it must hold. Offer to add it, and go on once the user agrees. When the user declines, stop.

Mode-specific constraints are under each mode below.

## Process

### 1. Resolve the ticket

If the user passed a ticket number or URL, or the conversation already names one, read it with its comments and treat it as the **spec ticket** (single-ticket target or parent for children).

If none is present and the conversation holds a settled plan, such as one from `ace-grill`, use that plan as the spec. It gets its ticket at publish.

Otherwise **stop and ask** for the ticket number or URL. Wait for it before you draft or create anything. If they confirm there is no ticket, suggest `ace-grill` to settle a plan first.

Work from that ticket or plan plus whatever is already in the conversation. Use the project's domain glossary vocabulary.

### 2. Choose single vs multiple

After you understand the spec, pick a mode. State the choice and one sentence why before drafting.

**Use single-ticket mode** when **all** of these hold:

- One cohesive end-to-end behaviour (one demoable outcome).
- Honest **Size** is `S` or `M`, and the work fits in a **single fresh context window** for implementation.
- No natural tracer-bullet splits where each slice is independently valuable and demoable.
- Not a **wide refactor** (see multiple-ticket mode).

**Use multiple-ticket mode** when **any** of these hold:

- The spec names multiple behaviours, phases, or milestones that should land as separate vertical slices.
- Honest **Size** is `L` or `XL`, or the work clearly will not fit one context window.
- Dependencies between chunks mean some work must finish before other work can start (blocking edges).
- A **wide refactor** applies: one mechanical change with blast radius across the codebase (rename column, retype shared symbol, etc.). Sequence expand → migrate batches → contract, each as its own ticket.

If the call is borderline, recommend a mode and ask whether to proceed single, split, or adjust. Respect an explicit user preference over the default recommendation.

### 3a. Single ticket: draft

Show the user:

- **Title**: short descriptive name
- **What it delivers**: the end-to-end behaviour this ticket makes work
- **Priority**: `Urgent`, `High`, `Medium`, or `Low`
- **Size**: `S`, `M`, `L`, or `XL`
- **Risk**: `High` or `Low`

If **Size** would be `L` or `XL` or the work still will not fit one context window, **stop** before publishing. Say so and offer to switch to multiple-ticket mode.

Wait for approval.

### 3b. Multiple tickets: explore (optional)

If you have not already explored the codebase, do so to understand current state. Look for prefactors that make implementation easier: make the change easy, then make the easy change.

### 3c. Multiple tickets: draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests): vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges**: other tickets that must complete before it can start. A ticket with no blockers can start immediately.

For **wide refactors**, sequence expand, then contract. First expand: add the new form beside the old so nothing breaks. Migrate call sites in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green because the old form still exists. Contract: delete the old form once no caller remains, blocked by every migrate batch. When batches cannot stay green alone, use a shared integration branch and block a final integrate-and-verify ticket; green is promised only there.

Present the breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work
- **Priority**: `Urgent`, `High`, `Medium`, or `Low`
- **Size**: `S`, `M`, `L`, or `XL`
- **Risk**: `High` or `Low`

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct: does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 4a. Single ticket: publish

- Publish exactly one ticket.

If a ticket was resolved in step 1, **update that ticket** as the ticket tracker says, including type, Priority, Size, Risk, and project. Write its body in the shape `ace-open-ticket` defines.

If the spec is a plan from the conversation, open a new ticket with `ace-open-ticket`.

### 4b. Multiple tickets: publish

- If the spec is a plan from the conversation, first open the parent with `ace-open-ticket`. Its Goal and Task come from the plan, and its Done when is the plan's overall acceptance checks.
- Use the parent from step 1, or the one you just opened, as the only parent, and leave its body as it is.
- After create, attach each ticket as a **sub-ticket** of that parent.

Open one ticket per approved ticket with `ace-open-ticket`, **blockers first**, so each blocking edge can name a real ticket number. After each create, attach it as a sub-ticket of the parent and set its blockers, both as the ticket tracker says.

Work the frontier: any ticket whose blockers are all done. For a chain that is strictly one-after-another, that means top to bottom.

### Ticket body (both modes)

Pass these facts to `ace-open-ticket`.

Who this is from is Ticket.

Goal is the end-to-end behaviour this ticket makes work, from the user's perspective, not a layer-by-layer implementation.

Task is that behaviour, enough to carry it out.

Done when is the acceptance checks, one `- [ ]` per check.

Blocked by is None in single-ticket mode (can start immediately), or names each blocking ticket in multiple-ticket mode.

In the ticket body, describe behaviour in prose, without file paths or code snippets. They go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts, not a working demo, just the important bits.
