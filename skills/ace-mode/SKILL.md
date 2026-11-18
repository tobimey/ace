---
name: ace-mode
description: Routes each message to the matching playbook and runs its Ace skills in order. Use at the start of every session in any project where Ace is installed, with or without an `ace` folder. Load it once per session; when the task changes, route again from the text already loaded.
---

# Ace mode

Ace mode is always on. For each message, pick the playbook below that matches it, run its skills in order, then hand off to the next stage of the cycle. Done means the playbook's last step ran and the hand-off is done, or the reply names the step that stopped and why.

## Requires

- `ace-adapters`
- Every skill a playbook names. Ace installs as one set, so each is in a folder next to this one.

## Constraints

- A step that changes files waits until the message asks for a change. A message asks for one when it asks in words, such as "fix", "add", or "do it", when it names a job that changes files, such as `Review pull request #12`, `Run ace-work-ticket.`, or a skill command like `/ace-review`, or when it says yes to a change you proposed. A skill then makes the changes its Done names, within the settings in `ace/config.json`, and no others. Until a message asks, run the read-only steps and propose the rest.
- Load a skill by reading `../<name>/SKILL.md` from this file's folder, since Ace hides its skills from the model. Follow each skill as written. This file only picks the skills and their order.
- Read a playbook file the first time you route to it, then keep using it from context.
- A step that does not apply stays in the list as `skip: <reason>`.
- A small edit the user fully specified, such as a typo or a line they dictated, needs no playbook. Make it and say what changed.
- Playbooks are internal. Never name one in a reply or print its steps. Say what you do in plain words, such as "I'll fix the bug, then review the diff."
- Read every project fact as `ace-adapters` says. A missing `ace` folder or section is no error: its default applies. When the project has no `ace` folder, end the first reply of the session with one line that offers `ace-setup`.
- Leave every merge to a person. Ace stops at an open pull request.
- A model never reviews a change it built. When this session built the change, the Review playbook does not run here. Say that a review needs another model, such as a new session on a different model or the user's runner, and give the line to send there. Run it here only when the user asks again after that.

## Questions

When asking the user to decide, number each question and give a recommended answer. Write each question in this shape, with a bold title line, then a blank line, then the body, and no markdown fence, heading, or list:

**❓ Q1 - <question title>**

<question body>
A) <choice>
B) <choice>

➡️ <recommended answer>

The body is a few sentences. Put each choice on its own plain line under the body; a question without choices has only the body. The recommended answer is one sentence. Define a specialist term in the same sentence that uses it.

## Route

1. Match the message to one playbook. When two match, take the one listed first. When none matches, work without a playbook and use skills as their own descriptions say. A request for an opinion, a ranking, or a comparison that proposes no change, such as "what are the worst parts of X", matches none: answer it directly and change nothing.
2. Copy its steps into the todo list. When the harness has no todo list, track them yourself and keep them out of the reply.
3. Run the steps. When a later message changes the task, route again.
4. Hand off as the "Hand off" section below says.

## Playbooks

### Understand

A question about the code, with no change asked: "how does X work", "why is Y built this way", "explain this PR", "teach me Z".

1. How it works now, why it is this way, or an explanation of a change: `ace-explain`. Lasting skill over several sessions: `ace-learn`.
2. Answer. Change nothing.

### Prototype

A question a quick sketch answers by running it: "prototype X", "try both layouts", "which is faster, A or B". Steps: [PLAN.md](PLAN.md), section Prototype.

### Plan

An idea or a feature whose design is not settled, an opinion on a change the user proposes ("should we split X? what do you think?"), or no direction yet ("how can I make X better", "what should we build next"). "What's next" about work in progress is Continue. Steps: [PLAN.md](PLAN.md), section Plan.

### Perf

Something works but is too slow: a page, a query, a build, a job. Steps: [PERF.md](PERF.md).

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

### Babysit

An open pull request with work left before merge: "babysit PR #12", "fix the CI", "address the review comments", "check my open PRs", "watch it until it is green".

1. `ace-babysit-pr` with the pull requests the message names, in `watch` mode when it asks to watch.

### Review

A diff, a branch, or a pull request to review.

1. `ace-review` on that input. When the message asks for only some checks, such as "check it against the ticket", pass them: `spec`, `standards`, `code`, or the name of a custom check in `ace/checks/`.
2. Reply with its report.
3. When the user asked to comment on the pull request, first push the commits `ace-review` made, if any, to its branch with a plain push. Then post the report as one comment that starts with `<!-- ace-review -->` and the model line, as "Sign what you post" in `ace-adapters` says, replacing an earlier comment with that marker, as `ace/CODE_HOSTING.md` says.

### Audit

"Audit", or a search for bugs, security holes, performance costs, standards breaks, or shallow modules across the repo.

1. `ace-audit` with the domains the message names: `security`, `logic`, `performance`, `architecture`, `health`, or the name of a custom check in `ace/checks/`. A full audit names all of them. With no domain named, `ace-audit` asks.

### Improve the factory

Agents went wrong, or the user wants to change how agents are steered.

1. A whole session to look back on, "retro", or one named misbehaviour: `ace-optimize-factory`. The agents file: `ace-agents-file`. An existing skill: `ace-skill-optimizer`. A new skill: `ace-create-skill`.

### Single job

A message that names one job runs that skill alone: work the next ready ticket with `ace-work-ticket`, open a ticket with `ace-to-ticket/OPEN_TICKET.md`, open a pull request with `ace-open-pr`, verify a change with `ace-verify`, set up Ace with `ace-setup`, post an explainer on a pull request with `ace-explain/EXPLAINER.md`.

### Continue

"What's next", "continue", "where are we", or a ticket or pull request named with no ask. Steps: [CONTINUE.md](CONTINUE.md), section Continue.

## Finish a change

Perf, Fix, Refactor, and Build end with these steps. Copy them into the todo list in place of "Finish the change".

1. `ace-open-pr` when the user asked to ship or open a pull request. Otherwise offer it.
2. Leave the review to another model, as the Constraints say. `ace-implement` already checked the coding standards.

## Hand off

When Plan, Perf, Fix, Refactor, Build, Babysit, Review, or Audit ends, hand off as [CONTINUE.md](CONTINUE.md), section Hand off, says.

Understand, Prototype, Improve the factory, Continue, and Single job hand off nothing. A playbook run as a step of another hands off nothing. The outer playbook hands off.
