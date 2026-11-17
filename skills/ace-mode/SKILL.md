---
name: ace-mode
description: Routes each message in an Ace project to the matching playbook and runs its Ace skills in order. Use at the start of every task, and again whenever the task changes, in any project with an `ace` folder.
---

# Ace mode

Ace mode is always on. For each message, pick the playbook below that matches it, run the playbook's skills in order, then hand off to the next stage of the cycle. Done means the playbook's last step ran and the hand-off is done, or the reply names the step that stopped and why.

## Requires

- Every skill a playbook below names.

Before you run a step, check that its skill is installed: its folder sits next to this skill's folder. If one is missing, mark the step `skip: not installed`, tell the user to install it the way they installed Ace, and go on with the next step.

## Constraints

- The agents file decides when to change files. A playbook step that changes files waits until the message asks for a change. Until then, run the read-only steps and propose the rest.
- This file picks the skills and their order. Follow each skill as written. Its steps, rules, and report live in the skill.
- Load each skill by reading `../<name>/SKILL.md` from this file's folder. Ace hides its skills from the model, so a skill loads only by path.
- A step that does not apply stays in the list as `skip: <reason>`.
- A small edit the user fully specified, such as a typo or a line they dictated, needs no playbook. Make it and say what changed.
- Playbooks are internal. Never name a playbook in a reply, and never print `Playbook: X` or a list of its steps. Say what you are doing in plain words, such as "I'll fix the bug, then review the diff."
- When the project has no `ace` folder, say so once and offer `ace-setup`. Then work without the adapters.
- Leave every merge to a person. Ace stops at a reviewed pull request.
- This file says what comes next. A person starts the next run, unless `ace/CYCLE.md` says a label or a schedule does.

## Route

1. Match the message to one playbook. When two match, take the one listed first. When none matches, work without a playbook and use skills as their own descriptions say.
2. Copy its steps into the todo list. When the harness has no todo list, track them yourself and keep them out of the reply.
3. Run the steps. When a later message changes the task, route again.
4. Hand off as the "Hand off" section below says.

## Playbooks

### Understand

A question about the code, with no change asked: "how does X work", "why is Y built this way", "explain this PR", "teach me Z".

1. How it works now, why it is this way, or an explanation of a change: `ace-explain`. Lasting skill over several sessions: `ace-learn`.
2. Answer. Change nothing.

### Prototype

A question a quick sketch answers by running it: "prototype X", "try both layouts", "which is faster, A or B".

1. Write the question and the result that settles it, in two lines.
2. Build the smallest sketch that shows that result, on a throwaway branch or in a scratch folder. It needs no tests, review, or coding standards.
3. Run it and look at the result. Try each option the same way.
4. Answer with what you saw and the choice it points to. Delete the sketch, unless the user wants to keep it.

### Plan

An idea or a feature whose shape is not settled.

1. `ace-grill` until the design tree has no open branch. When a decision turns on something only running code shows, such as speed or how a layout feels, run the Prototype playbook for it and bring its result to that question.
   `ace-grill` writes the settled plan into a ticket, unless the user chose no ticket.
2. Ask one question in the question format of `ace-unslop`: implement it here now, or stop? Recommend stopping when grill opened sub-tickets, or when the work should wait. Otherwise recommend implementing here. Wait for the answer.
3. Here: run the Build playbook with the settled plan, or with its ticket, and hand off as Build. Stop: stop.

### Perf

Something works but is too slow: a page, a query, a build, a job.

1. Measure it the way the user hits it, three runs or more. Write down the command, each number, and the spread. When it is not slow, report the numbers and stop.
2. Find what the time goes to, with a profiler or a timer around each step, and trace it to its source.
3. `ace-implement`, with the fix for that source as the plan. Behavior stays the same.
4. Measure again the same way. When the gain is inside the spread, revert the fix and stop. Report the numbers before and after, with the command.
5. Finish the change.

### Fix

A bug report: something behaves wrong.

1. `ace-diagnose`. When no loop goes red on the bug, report what it tried and stop.
2. `ace-implement`, with the diagnosis as the plan. The first test reproduces the bug at the seam the diagnosis names. When it names no seam, skip that test and say why.
3. Finish the change.

### Refactor

A change to the shape of the code that keeps what it does: rename, extract, move, merge, simplify.

1. When the message names a ticket, read it with its comments as `ace/TICKET_TRACKER.md` says.
2. `ace-implement`, with the refactor as the plan. Behavior stays the same.
3. Finish the change.

### Build

A ticket, spec, or plan to implement, or a feature the conversation has settled.

1. When the message names a ticket, read it with its comments as `ace/TICKET_TRACKER.md` says.
2. When the plan leaves a decision open, `ace-grill` on the open decisions only. When a ticket is named, tell grill to keep it as one ticket, so its body stays the spec for what you build.
3. `ace-implement`.
4. Finish the change.

### Review

A diff, a branch, or a pull request to review.

Run the three jobs one after another on the same input. Two of them edit files, so a parallel run conflicts. On a pull request they commit their edits. On a local diff they leave them uncommitted for the user.

1. `ace-check-spec`.
2. `ace-validate-standards`.
3. `ace-review`.
4. Reply with the spec result, the standards edits, the review fixes and findings, and Merge Danger last.
5. When the user asked to comment on the pull request, first push the commits from steps 2 and 3 to its branch with a plain push. Then post the reply as one comment that starts with `<!-- ace-review -->`, replacing an earlier comment with that marker, as `ace/CODE_HOSTING.md` says.

### Audit

"Audit", or a search for bugs, security holes, performance costs, standards breaks, or shallow modules across the repo.

1. `ace-audit` with the domains the message names: `security`, `logic`, `performance`, `architecture`, or `health`. A full audit names all five. With no domain named, `ace-audit` asks.

### Improve the factory

Agents went wrong, or the user wants to change how agents are steered.

1. A whole session to look back on, or "retro": `ace-retro`. One named misbehaviour: `ace-optimize-factory`. The agents file: `ace-agents-file`. An existing skill: `ace-skill-optimizer`. A new skill: `ace-create-skill`.

### Single job

A message that names one job runs that skill alone: work the next ready ticket with `ace-work-ticket`, open a ticket with `ace-open-ticket`, open a pull request with `ace-open-pr`, verify a change with `ace-verify`, set up Ace with `ace-setup`, post an explainer on a pull request with `ace-explain-change`, say the last reply plainly with `ace-bro`.

### Continue

"What's next", "continue", "where are we", or a ticket or pull request named with no ask.

1. Find the work: the ticket or pull request the message names. Otherwise the pull request for the current branch, found as `ace/CODE_HOSTING.md` says. Otherwise the local diff.
2. Place it in the first row that matches:

   | State | Next |
   |---|---|
   | An idea with open decisions, and no spec ticket | Plan |
   | A spec ticket too big for one change, with no sub-tickets | `ace-to-ticket` with that ticket |
   | A ticket in the needs-dev state | A person reads it and its comments, then sets it ready or closes it |
   | A ticket with no branch and no pull request | Build |
   | Local changes, or a branch with no pull request | Review on the local diff, then `ace-open-pr` |
   | An open pull request with no `<!-- ace-review -->` comment, or commits newer than that comment | Review |
   | An open pull request with a current review | A person merges. Name its Merge Danger. |
   | A merged pull request | Done. Offer `ace-retro` when the work went badly. |

3. Say the state and the next step in two lines, in plain words. Run the matching playbook once the user agrees.

## Finish a change

Perf, Fix, Refactor, and Build end with these steps. Copy them into the todo list in place of "Finish the change".

1. Run the Review playbook on the local diff. Skip it when the user asked to open a pull request and `ace/CYCLE.md` starts a review run once one opens.
2. `ace-open-pr` when the user asked to ship or open a pull request. Otherwise offer it.

## Hand off

When Plan, Perf, Fix, Refactor, Build, Review, or Audit ends, and `ace/CYCLE.md` has a section for that playbook, do what it says. Perf, Fix, and Refactor use the Build section. The section can set a label, move a ticket, or tell the user what a run does next.

Otherwise end the reply with the next step from the Continue table, as one line the user can send, such as `Next: review pull request #12`. After Plan or Audit, also say that the new tickets are in the needs-dev state, and that a person sets one ready or starts it with `Implement TICKET`.

Understand, Prototype, Improve the factory, Continue, and Single job hand off nothing. A playbook run as a step of another hands off nothing. The outer playbook hands off.
