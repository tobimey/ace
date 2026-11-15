---
name: ace-mode
description: Routes each message in an Ace project to the matching playbook and runs its Ace skills in order. Use at the start of every task, and again whenever the task changes, in any project with an `ace` folder.
---

# Ace mode

Ace mode is always on. For each message, pick the playbook below that matches it, run the playbook's skills in order, then hand off to the next stage of the cycle. Done means the playbook's last step ran and the hand-off is done, or the reply names the step that stopped and why.

## Requires

- Every skill a playbook below names.

Before you run a step, check that its skill is installed: its folder sits next to this skill's folder. If one is missing, mark the step `skip: not installed`, tell the user to install it with `npx skills add tobimey/ace --skill NAME`, and go on with the next step.

## Constraints

- The agents file decides when to change files. A playbook step that changes files waits until the message asks for a change. Until then, run the read-only steps and propose the rest.
- This file picks the skills and their order. Follow each skill as written. Its steps, rules, and report live in the skill.
- Load a skill by its name. When the harness cannot, read `../<name>/SKILL.md` from this file.
- A step that does not apply stays in the list as `skip: <reason>`.
- A small edit the user fully specified, such as a typo or a line they dictated, needs no playbook. Make it and say what changed.
- When the project has no `ace` folder, say so once and offer `ace-setup`. Then work without the adapters.
- Leave every merge to a person. Ace stops at a reviewed pull request.
- This file says what comes next. How the next run starts, by a person, a label, or a schedule, lives in `ace/CYCLE.md`.

## Route

1. Match the message to one playbook. When two match, take the one listed first. When none matches, work without a playbook and use skills as their own descriptions say.
2. Name the playbook in one line, such as `Playbook: Build`. The user can redirect.
3. Copy its steps into the todo list, or into the reply when the harness has no todo list.
4. Run the steps. When a later message changes the task, route again.
5. Hand off as the "Hand off" section below says.

## Playbooks

### Understand

A question about the code, with no change asked: "how does X work", "why is Y built this way", "explain this PR", "teach me Z".

1. How it works now: `ace-how`. Why it is this way: `ace-why`. Both, or an explanation of a change: `ace-teach`. Lasting skill over several sessions: `ace-learn`.
2. Answer. Change nothing.

### Plan

An idea or a feature whose shape is not settled.

1. `ace-grill` until the design tree has no open branch.
2. When no spec ticket exists, open one with `ace-open-ticket` from the settled plan.
3. `ace-to-ticket` on the spec ticket.

### Fix

A bug report: something behaves wrong.

1. Reproduce it as the "Check behavior" section of `ace/VERIFY.md` says, and see it fail. When it does not reproduce, report what you tried and stop.
2. Trace the failure to the first place the code goes wrong.
3. `ace-implement`, with the bug as the plan. The first test reproduces the bug.
4. Run the Review playbook on the local diff. Skip it when the user asked to open a pull request and `ace/CYCLE.md` starts a review run once one opens.
5. `ace-open-pr` when the user asked to ship or open a pull request. Otherwise offer it.

### Build

A ticket, spec, or plan to implement, or a feature the conversation has settled.

1. When the message names a ticket, read it with its comments as `ace/TICKET_TRACKER.md` says.
2. When the plan leaves a decision open, `ace-grill` on the open decisions only.
3. `ace-implement`.
4. Run the Review playbook on the local diff. Skip it when the user asked to open a pull request and `ace/CYCLE.md` starts a review run once one opens.
5. `ace-open-pr` when the user asked to ship or open a pull request. Otherwise offer it.

### Review

A diff, a branch, or a pull request to review.

Run the three jobs one after another on the same input. Two of them commit, so a parallel run conflicts.

1. `ace-check-spec`.
2. `ace-validate-standards`.
3. `ace-review`.
4. Reply with the spec result, the standards commit, the review findings, and Merge Danger last.
5. When the user asked to comment on the pull request, first push the commits from steps 2 and 3 to its branch with a plain push. Then post the reply as one comment that starts with `<!-- ace-review -->`, replacing an earlier comment with that marker, as `ace/CODE_HOSTING.md` says.

### Audit

"Audit", or a search for bugs, security holes, performance costs, or standards breaks across the repo.

1. The `ace-audit-` skill for the domain: `ace-audit-logic`, `ace-audit-security`, `ace-audit-performance`, or `ace-audit-health`. A full audit runs each in turn.

### Improve the factory

Agents went wrong, or the user wants to change how agents are steered.

1. A whole session to look back on, or "retro": `ace-retro`. One named misbehaviour: `ace-optimize-factory`. The agents file: `ace-agents-file`. An existing skill: `ace-skill-optimizer`. A new skill: `ace-create-skill`.

### Single job

A message that names one job runs that skill alone: open a ticket with `ace-open-ticket`, open a pull request with `ace-open-pr`, verify a change with `ace-verify`, set up Ace with `ace-setup`, say the last reply plainly with `ace-bro`.

### Continue

"What's next", "continue", "where are we", or a ticket or pull request named with no ask.

1. Find the work: the ticket or pull request the message names. Otherwise the pull request for the current branch, found as `ace/CODE_HOSTING.md` says. Otherwise the local diff.
2. Place it in the first row that matches:

   | State | Next |
   |---|---|
   | An idea with open decisions, and no spec ticket | Plan |
   | A spec ticket too big for one change, with no sub-tickets | Plan, from `ace-to-ticket` |
   | A ticket with no branch and no pull request | Build |
   | Local changes, or a branch with no pull request | Review on the local diff, then `ace-open-pr` |
   | An open pull request with no `<!-- ace-review -->` comment, or commits newer than that comment | Review |
   | An open pull request with a current review | A person merges. Name its Merge Danger. |
   | A merged pull request | Done. Offer `ace-retro` when the work went badly. |

3. Say the state and the next playbook in two lines. Run that playbook once the user agrees.

## Hand off

When Plan, Build, Fix, Review, or Audit ends, read `ace/CYCLE.md` and do what its section for that playbook says. Fix uses the Build section. The section can tell the user the next step, set a label, move a ticket, or say that nothing follows.

When the file or the section is missing, end the reply with the next step from the Continue table, as one line the user can send, such as `Next: review pull request #12`.

Understand, Improve the factory, Continue, and Single job hand off nothing. A playbook run as a step of another hands off nothing. The outer playbook hands off.
