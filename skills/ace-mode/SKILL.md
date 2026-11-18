---
name: ace-mode
description: Routes each message to the matching playbook and runs its Ace skills in order. Use at the start of every session in any project where Ace is installed, with or without an `ace` folder. Load it once per session; when the task changes, route again from the text already loaded.
---

# Ace mode

Ace mode is always on. For each message, pick the playbook below that matches it, run its steps in order, then hand off. Done means the playbook's last step ran and the hand-off is done, or the reply names the step that stopped and why.

## Requires

- `ace-adapters`
- Every skill a playbook names. Ace installs as one set, so each is in a folder next to this one.

## Constraints

- A step that changes files waits until the message asks for a change. A message asks for one when it asks in words, such as "fix", "add", or "do it", when it names a job that changes files, such as `Review pull request #12`, `Run ace-work-ticket.`, or a skill command like `/ace-review`, or when it says yes to a change you proposed. A skill then makes the changes its Done names, within the settings in `ace/config.json`, and no others. Until a message asks, run the read-only steps and propose the rest.
- Load a skill by reading `../<name>/SKILL.md` from this file's folder, since Ace hides its skills from the model. Follow each skill as written. Read a playbook file the first time you route to it, then keep using it from context.
- Read every project fact as `ace-adapters` says. A missing `ace` folder or section is no error: its default applies. When the project has no `ace` folder, end the first reply of the session with one line that offers `ace-setup`.
- Playbooks are internal. Never name one in a reply or print its steps. Say what you do in plain words, such as "I'll fix the bug, then review the diff."
- Skip a step that does not apply. Mention it in the reply only when the user would expect it to run, such as a test or a review.
- When you ask the user to decide in chat, use the format in [QUESTIONS.md](QUESTIONS.md).
- Leave every merge to a person. Ace stops at an open pull request.
- A model never reviews a change it built. When this session built the change, the Review playbook does not run here. Say that a review needs another model, such as a new session on a different model or the user's runner, and give the line to send there. Run it here only when the user asks again after that.

## Route

1. Match the message to one playbook. When two match, take the one listed first. When none matches, work without a playbook and use skills as their own descriptions say.
   - A small edit the user fully specified, such as a typo or a line they dictated, needs no playbook. Make it and say what changed.
   - A request for an opinion, a ranking, or a comparison that proposes no change, such as "what are the worst parts of X", matches none: answer it directly and change nothing.
2. When the playbook has three steps or more, copy them into the todo list. When the harness has no todo list, track them yourself and keep them out of the reply.
3. Run the steps. When a later message changes the task, route again.
4. When Plan, Perf, Fix, Refactor, Build, Babysit, Review, or Audit ends, hand off as [CONTINUE.md](CONTINUE.md), section Hand off, says. The other playbooks hand off nothing, and neither does a playbook run as a step of another: the outer playbook hands off.

## Playbooks

| Playbook | The message | Steps |
|---|---|---|
| Understand | A question about the code, with no change asked: "how does X work", "why is Y built this way", "explain this PR", "teach me Z" | `ace-explain` for how it works now, why it is this way, or a change. `ace-learn` for lasting skill over several sessions. Then answer and change nothing. |
| Prototype | A question a quick sketch answers by running it: "prototype X", "try both layouts", "which is faster, A or B" | [PLAN.md](PLAN.md), section Prototype |
| Plan | An idea or a feature whose design is not settled, an opinion on a change the user proposes ("should we split X? what do you think?"), or no direction yet ("how can I make X better", "what should we build next"). "What's next" about work in progress is Continue. | [PLAN.md](PLAN.md), section Plan |
| Perf | Something works but is too slow: a page, a query, a build, a job | [PERF.md](PERF.md) |
| Fix | A bug report: something behaves wrong | [BUILD.md](BUILD.md), section Fix |
| Refactor | A change to the shape of the code that keeps what it does: rename, extract, move, merge, simplify | [BUILD.md](BUILD.md), section Refactor |
| Build | A ticket, spec, or plan to implement, or a feature the conversation has settled | [BUILD.md](BUILD.md), section Build |
| Babysit | An open pull request with work left before merge: "babysit PR #12", "fix the CI", "address the review comments", "check my open PRs", "watch it until it is green" | `ace-babysit-pr` with the pull requests the message names, in `watch` mode when it asks to watch |
| Review | A diff, a branch, or a pull request to review | The Review steps below |
| Audit | "Audit", or a search for bugs, security holes, performance costs, standards breaks, or shallow modules across the repo | `ace-audit` with the domains the message names: `security`, `logic`, `performance`, `architecture`, `health`, or the name of a custom check in `ace/checks/`. A full audit names all of them. With no domain named, `ace-audit` asks. |
| Improve the factory | Agents went wrong, or the user wants to change how agents are steered | A whole session to look back on, "retro", one named misbehaviour, or the agents file: `ace-optimize-factory`. A new or existing skill: `ace-skill-best-practices`. |
| Single job | A message that names one job | That skill alone: work the next ready ticket with `ace-work-ticket`, open a ticket with `ace-to-ticket/OPEN_TICKET.md`, open a pull request with `ace-open-pr`, verify a change with `ace-verify`, set up Ace with `ace-setup`, post an explainer on a pull request with `ace-explain/EXPLAINER.md` |
| Continue | "What's next", "continue", "where are we", or a ticket or pull request named with no ask | [CONTINUE.md](CONTINUE.md), section Continue |

### Review steps

1. `ace-review` on that input. When the message asks for only some checks, such as "check it against the ticket", pass them: `spec`, `standards`, `code`, or the name of a custom check in `ace/checks/`.
2. Reply with its report.
3. When the user asked to comment on the pull request, post the report as one comment that starts with `<!-- ace-review -->` and the model line, as "Sign what you post" in `ace-adapters` says, replacing an earlier comment with that marker, as `ace/CODE_HOSTING.md` says.
