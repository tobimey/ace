`This project is in active development and not ready to use. Pre-Alpha expected by 18.11.2026.`

# Ace

Ace is an adaptable, agentic skills framework. Use the `ace-setup` skill to get started.

The new age of programming isn't … programming. It's probably not even engineering. Writing code is not just cheap; for many workflows it is largely delegated to agents. With Ace, the role shifts: less direct code authorship, more engineering of the factory and the inputs that the factory receives.

## What models to use?

Make sure you use a model that scores > 40 on the current [Artificial Analysis Intelligence Index](https://artificialanalysis.ai/models#intelligence).

## Agnostic by default 

Ace is fully harness agnostic. You can use it with any harness. Ace is also agnostic to the model you use if it is good enough. It also doesn't matter what type of project you are working on. 

## Skill categories

Ace groups its skills into these categories: 

- Stage 1: plan: skills that define a plan, create tickets, etc. 
- Stage 2: implement: skills that implement the plan.
- Stage 3: review: skills that review the codebase, usually invoked by PR events.
- Stage 4: optimize: skills that optimize the current agentic system so it works better for the next iteration.

That is called the `ace cycle`. It's the core software cycle that drives the software development process. On top of these, Ace provides a few more skills: 

- audit: skills that audit the codebase, usually on a CRON. They usually lead to new tickets that then feed into stage 2.
- understand: skills that help the developer understand the codebase, its architecture, its dependencies, its code style, its best practices, etc. `ace-explain-change` writes an explainer for a change and posts it on the pull request. It is opt-in: add it to your CI next to the review skills.
- shared: skills that other skills load, never run on their own. `ace-checks` holds the logic, security and performance rules that both `ace-review` and the auditors use.
- tone: skills that add quality of life improvements when writing with an agent like `/ace-bro` when the agent uses too much jargon, or `/ace-unslop` to keep the agent's output clean and easy to follow.

## Local vs Cloud 

Some things will run in the cloud, some on a local machine. The trend likely moves toward more cloud execution. The system here is not built for one specific type of machine. When set up correctly, something running in the cloud can access an app the same way as local tooling.

## The ace cycle

You can call it a factory. You can call it a restaurant. You can call it a garden. Many terms match. This document uses the term **cycle**: software is rarely ever "done."

The cycle is a loop. It starts with an idea that forms into a plan. The plan gets implemented. The code gets verified, tested and reviewed. This is the inner loop.

## Adapters

Ace is generic. It's suitable for all sorts of software projects in whatever language. What matters is adapting it to project and team needs.

The skills are built in a way that they listen to your needs. These adapters live in `ace/` in your project, and `ace-setup` creates them:

- `GLOSSARY.md` holds a shared language between the human and the agent, so that nothing drifts.
- `CODING_STANDARDS.md` is used in stages 2 and 3 to check that the code is written in a way that is consistent with your coding standards.
- `VERIFY.md` says how to prove a change works: the checks CI runs, how to start the app, and how to try each kind of change. `ace-verify` follows it in stage 2, and the review jobs run its checks in stage 3.
- `TICKET_TRACKER.md` says how to read, search, open, and update tickets, e.g. in GitHub Issues, Linear, Jira, etc. `ace-setup` ships a template for GitHub Issues. For another tracker it writes the same sections with that tracker's MCP server, CLI, or API.
- `CODE_HOSTING.md` says how to open a pull request, comment on it, and find the tickets it closes, e.g. on GitHub, GitLab, Bitbucket, etc.
- `CYCLE.md` says how work moves from one stage to the next, and what starts a run without a person. Ace skills say what comes next; this file says how it happens in your setup. By default a person starts every run and `ace-mode` names the next step. `ace-setup` also ships a GitHub recipe, where the label `ace:review` starts a review in GitHub Actions. For another runner, such as a cloud agent with a schedule, you write the triggers here and the skills stay the same.

The adapters are yours. `ace-setup` writes a first draft, and from then on you change them as the project needs. Ace skills depend only on a few sections, listed in [skills/ace-setup/ADAPTERS.md](skills/ace-setup/ADAPTERS.md). Keep those, under any heading, and the rest of each file is free. When a skill misses one, it says which, and a skill that edits files offers to add it.

In a monorepo, `ace-setup` detects the workspace and gives each package with its own checks or app a small `ace/` folder with its own `VERIFY.md`, plus a `CODING_STANDARDS.md` if the package has its own rules. The root files list those package files, and the package files add to the root ones. The glossary, ticket tracker and code hosting files exist only once, at the root.

Your root `AGENTS.md` (or `CLAUDE.md`) stays where it is, because harnesses load it from there into every agent session. `ace-setup` adds a short section to it that turns on `ace-mode`, points at the adapters, and tells the agent to change files only when asked to. `ace-mode` is the router: for each message it picks a playbook, such as Build, Fix, or Review, and runs the Ace skills that playbook needs, in order. You state the goal, and `ace-mode` picks the skills. If the file doesn't exist yet, `ace-setup` writes a small draft for you to iterate on. If you have an `AGENTS.md` but no `CLAUDE.md`, it also creates a `CLAUDE.md` containing only `@AGENTS.md`, so Claude Code loads the same instructions.

## Credits

Ace builds on ideas and skills from these projects:

- [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock (MIT). `ace-retro` is adapted from his `retro` skill, `ace-learn` from his `teach` skill, and `ace-grill` and `ace-to-ticket` follow his grilling and ticket-slicing workflows.
- [pstack](https://cursor.com/marketplace/cursor/pstack) by Lauren Tan (MIT, [mirror](https://github.com/backnotprop/pstack)). `ace-mode` and the playbook-style skills take after its approach. `ace-how`, `ace-why`, and `ace-teach` are adapted from its `how`, `why`, and `teach` skills.
- [explain-diff](https://gist.github.com/geoffreylitt/a29df1b5f9865506e8952488eac3d524) by Geoffrey Litt. `ace-explain-change` follows its idea of explaining a change with background, intuition, a code walkthrough, and a quiz.
