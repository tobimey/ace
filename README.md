`This project is in active development and not ready to use. Pre-Alpha expected by 18.11.2026.`

# Ace

Ace is an adaptable, agentic skills framework. Use the `ace-setup` skill to get started.

The new age of programming isn't … programming. It's probably not even engineering. Writing code is not just cheap; for many workflows it is largely delegated to agents. With Ace, the role shifts: less direct code authorship, more engineering of the factory and the inputs that the factory receives.

## What models to use?

Make sure you use a model that scores > 40 on the current [Artificial Analysis Intelligence Index](https://artificialanalysis.ai/models#intelligence).

## Agnostic by default 

Ace is fully harness agnostic. You can use it with any harness. Ace is also agnostic to the model you use if it is good enough. It also doesn't matter what type of project you are working on. 

## Skill categories

Ace provides skills threw out different categories: 

- Stage 1: plan: skills that give define a plan, create tickets etc. 
- Stage 2: implement: skills that implement the plan.
- Stage 3: review: skills that review the codebase, usually invoked by PR events.
- Stage 4: optimize: skills that optimize the current agentic system so it works better for the next iteration.

That is called the `ace cycle`. Its the core software cycle that drives the software development process. On top of these ace provides a few more skills: 

- audit: skills that audit the codebase, usually on a CRON. They usually lead to new tickets that then hook into stage 2
- understand: skills that help the developer understand the codebase, its architecture, its dependencies, its code style, its best practices, etc.
- tone: skills that add quality of life improvements when writing with an agent like /bro when the agent talk to much jargon or /unslop to make sure an agents output is clean to follow.

## Local vs Cloud 

Some things will run in the cloud, some on a local machine. The trend likely moves toward more cloud execution. The system here is not built for one specific type of machine. When set up correctly, something running in the cloud can access an app the same way as local tooling.

## The ace cycle

You can call it a factory. You can call it a restaurant. You can call it a garden. Many terms match. This document uses the term **cycle**: software is rarely ever "done."

The cycle is a loop. It starts with an idea that forms into a plan. The plan gets implemented. The code gets verified, tested and reviewed. This is the inner loop.

## Adapters

Ace is generic. It's suitable for all sorts of software projects in whatever language. What matters is adapting it to project and team needs.

The skills are built in a way that they listen to your needs. These adapters live in `ace/` in your project, and `ace-setup` creates them:

- `GLOSSARY.md` holds a shared language between the human and the agent, so that nothing drifts.
- `CODING_STANDARDS.md` gets used in stage 2 and 3. To check that the code is written in a way that is consistent with your coding standards.
- `VERIFY.md` says how to prove a change works: the checks CI runs, how to start the app, and how to try each kind of change. `ace-verify` follows it in stage 2, and the review jobs run its checks in stage 3.
- `TICKET_TRACKER.md` says how to read, search, open, and update tickets, e.g. in GitHub Issues, Linear, Jira, etc.
- `CODE_HOSTING.md` says how to open a pull request, comment on it, and find the tickets it closes, e.g. on Github, Gitlab, Bitbucket, etc.

In a monorepo, `ace-setup` detects the workspace and gives each package with its own checks or app a small `ace/` folder with its own `VERIFY.md`, plus a `CODING_STANDARDS.md` if the package has its own rules. The root files list those package files, and the package files add to the root ones. The glossary, ticket tracker and code hosting files exist only once, at the root.

Your root `AGENTS.md` (or `CLAUDE.md`) stays where it is, because harnesses load it from there into every agent session. `ace-setup` adds a short section to it that points at the adapters. If the file doesn't exist yet, `ace-setup` writes a small draft for you to iterate on. If you have an `AGENTS.md` but no `CLAUDE.md`, it also creates a `CLAUDE.md` containing only `@AGENTS.md`, so Claude Code loads the same instructions.

## Credits

Ace builds on ideas and skills from these projects:

- [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock (MIT). `ace-retro` is adapted from his `retro` skill, and `ace-grill` and `ace-to-ticket` follow his grilling and ticket-slicing workflows.
- [pstack](https://cursor.com/marketplace/cursor/pstack) by Lauren Tan (MIT, [mirror](https://github.com/backnotprop/pstack)). `ace-mode` and the playbook-style skills take after its approach.
