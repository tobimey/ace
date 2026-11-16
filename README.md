`This project is in active development and not ready to use. Pre-Alpha expected by 18.11.2026.`

# Ace

Ace is an adaptable, agentic skills framework.

The new age of programming isn't … programming. It's probably not even engineering. Writing code is not just cheap; for many workflows it is largely delegated to agents. With Ace, the role shifts: less direct code authorship, more engineering of the factory and the inputs that the factory receives.

## Get started

1. Install Ace with one method per harness. A skill installed both ways shows up twice.
   - Claude Code: `/plugin marketplace add tobimey/ace`, then `/plugin install ace@tobimey`.
   - Codex: `codex plugin marketplace add tobimey/ace`, then install `ace` from `/plugins`.
   - Cursor and every other harness: `npx skills add tobimey/ace`. To add a single skill later, use `npx skills add tobimey/ace --skill NAME`.
2. Run `/ace-setup`, or `/ace:ace-setup` when you installed the plugin. It writes the adapters in `ace/` and turns on `ace-mode` in your `AGENTS.md`.
3. Read the drafts it wrote, fix what is wrong, and start working. Say what you want, such as "fix the login redirect" or "review my changes", and `ace-mode` picks the skills.
4. After each Ace update, run `/ace-setup` again. It keeps what your adapters say and adds the sections that new skills need.

## What models to use?

Use a model that scores above 40 on the [Artificial Analysis Intelligence Index](https://artificialanalysis.ai/models#intelligence). Ace skills are long, multi-step instructions that call each other, and weaker models skip steps or drop rules.

Review with a different model than the one that implemented the change. A model tends to miss the same mistakes in review that it made while writing the code.

## Agnostic by default 

Ace is fully harness agnostic. You can use it with any harness. Ace is also agnostic to the model you use if it is good enough. It also doesn't matter what type of project you are working on. 

## Skill categories

Ace groups its skills into these categories. Every skill has its own folder in `skills/`, such as `skills/ace-review/`.

- Stage 1, plan: `ace-grill` interviews you until a plan is settled and writes it into a ticket, `ace-to-ticket` turns a plan or spec into one ticket or several sub-tickets, and `ace-open-ticket` opens a ticket in the shared Ace shape.
- Stage 2, implement: `ace-diagnose` finds and proves the root cause of a bug, `ace-implement` builds the plan test-first, `ace-verify` proves it works, and `ace-open-pr` opens the pull request. `ace-work-ticket` runs this stage with no person: it takes the next ready ticket, builds it, and opens a reviewed pull request, usually on a schedule.
- Stage 3, review: `ace-check-spec` checks the change against its ticket, `ace-validate-standards` fixes coding-standards breaks, and `ace-review` fixes or reports logic, security, performance, and architecture problems and rates the Merge Danger. On a pull request these jobs commit their fixes. On a local diff they leave them uncommitted, and you commit.
- Stage 4, optimize: skills that improve the agentic system so it works better next time. `ace-retro` looks back on a session, `ace-optimize-factory` fixes one misbehaviour, `ace-agents-file` edits the agents file, and `ace-skill-optimizer` and `ace-create-skill` edit and create skills.

That is called the `ace cycle`. It's the core software cycle that drives the software development process. On top of these, Ace provides a few more skills:

- router: `ace-mode` picks the playbook for each message and runs its skills in order.
- setup: `ace-setup` writes the adapters.
- audit: `ace-audit-logic`, `ace-audit-security`, `ace-audit-performance`, `ace-audit-health`, and `ace-audit-architecture` audit the whole codebase, usually on a schedule. Each files at most three tickets, which feed into stage 2.
- understand: `ace-how` explains how code works, `ace-why` explains why it is that way, `ace-teach` does both for a change, and `ace-learn` teaches a topic over several sessions. `ace-explain-change` writes an explainer for a pull request, with a code walkthrough and a quiz, and posts it there. Run it by name, or add it to the CI step that runs your reviews.
- shared: skills that other skills load, never run on their own. `ace-checks` holds the logic, security, performance, and architecture rules that both `ace-review` and the auditors use. `ace-codebase-design` holds the deep-module vocabulary those rules and any design work use. `ace-audit` holds the workflow all auditors share.
- tone: `/ace-bro` restates the last reply without jargon, and `ace-unslop` keeps the agent's writing clean and easy to follow.

## Local vs Cloud 

Some things will run in the cloud, some on a local machine. The trend likely moves toward more cloud execution. The system here is not built for one specific type of machine. When set up correctly, something running in the cloud can access an app the same way as local tooling.

## The ace cycle

You can call it a factory. You can call it a restaurant. You can call it a garden. Many terms match. This document uses the term **cycle**: software is rarely ever "done."

The cycle is a loop. It starts with an idea that forms into a plan. The plan gets implemented. The code gets verified, tested and reviewed. This is the inner loop.

## Adapters

Ace is generic. It's suitable for all sorts of software projects in whatever language. What matters is adapting it to project and team needs.

The skills are built in a way that they listen to your needs. These adapters live in `ace/` in your project, and `ace-setup` creates them:

- `CODING_STANDARDS.md` is used in stages 2 and 3 to check that the code is written in a way that is consistent with your coding standards.
- `VERIFY.md` says how to prove a change works: the checks CI runs, how to start the app, and how to try each kind of change. `ace-verify` follows it in stage 2, and the review jobs run its checks in stage 3.
- `TICKET_TRACKER.md` says how to read, search, open, and update tickets, e.g. in GitHub Issues, Linear, Jira, etc. It also says how the tracker shows the three ticket states. Every ticket an agent opens starts in `needs-dev`. A person reads it and sets it `ready`. `ace-work-ticket` claims a ready ticket and sets it `working`, or sends it back to `needs-dev` with a question when it gets stuck. In GitHub these are the labels `ace:needs-dev`, `ace:ready`, and `ace:working`. `ace-setup` ships a template for GitHub Issues. For another tracker it writes the same sections with that tracker's MCP server, CLI, or API.
- `CODE_HOSTING.md` says how to open a pull request, comment on it, and find the tickets it closes, e.g. on GitHub, GitLab, Bitbucket, etc.
- `CYCLE.md` says how work moves from one stage to the next, and what starts a run without a person. Ace skills say what comes next; this file says how it happens in your setup. By default a person starts every run and `ace-mode` names the next step. `ace-setup` also ships a GitHub recipe, where the label `ace:review` starts a review in GitHub Actions, a schedule runs `ace-work-ticket`, and another schedule runs the auditors. For another runner, such as a cloud agent with a schedule, you write the triggers here and the skills stay the same.

The adapters are yours. `ace-setup` writes a first draft, and from then on you change them as the project needs. Ace skills depend only on a few sections, listed in [skills/ace-setup/ADAPTERS.md](skills/ace-setup/ADAPTERS.md). Keep those, under any heading, and the rest of each file is free. When a skill misses one, it says which, and a skill that edits files offers to add it. Running `ace-setup` again adds every missing section at once.

In a monorepo, `ace-setup` detects the workspace and gives each package with its own checks or app a small `ace/` folder with its own `VERIFY.md`, plus a `CODING_STANDARDS.md` if the package has its own rules. The root files list those package files, and the package files add to the root ones. The glossary, ticket tracker and code hosting exist only once, at the root.

The glossary is the shared language between the human and the agent, so that nothing drifts. It is not an adapter file. It lives in a Glossary section of your root `AGENTS.md`, one line per term, because every session needs it and harnesses load that file into every session. Agents skip a lookup in a separate file more often than you'd think. `ace-grill` adds terms as a plan settles them. Once the section passes about 40 terms, or one word means different things in different parts of the project, the detail moves to `ace/GLOSSARY.md`, and `AGENTS.md` keeps the one-line entries.

Your root `AGENTS.md` (or `CLAUDE.md`) stays where it is, because harnesses load it from there into every agent session. `ace-setup` adds a short section to it that turns on `ace-mode`, points at the adapters, and tells the agent to change files only when asked to, plus the Glossary section. `ace-mode` is the router: for each message it picks a playbook, such as Build, Fix, or Review, and runs the Ace skills that playbook needs, in order. You state the goal, and `ace-mode` picks the skills. If the file doesn't exist yet, `ace-setup` writes a small draft for you to iterate on. If you have an `AGENTS.md` but no `CLAUDE.md`, it also creates a `CLAUDE.md` containing only `@AGENTS.md`, so Claude Code loads the same instructions.

## Credits

Ace builds on ideas and skills from these projects:

- [mattpocock/skills](https://github.com/mattpocock/skills) by Matt Pocock (MIT). `ace-retro` is adapted from his `retro` skill, `ace-learn` from his `teach` skill, `ace-diagnose` from his `diagnosing-bugs` skill, `ace-codebase-design` from his `codebase-design` skill, `ace-audit-architecture` follows his `improve-codebase-architecture` survey, and `ace-grill` and `ace-to-ticket` follow his grilling and ticket-slicing workflows.
- [pstack](https://cursor.com/marketplace/cursor/pstack) by Lauren Tan (MIT, [mirror](https://github.com/backnotprop/pstack)). `ace-mode` and the playbook-style skills take after its approach. `ace-how`, `ace-why`, `ace-teach`, `ace-unslop`, and `ace-bro` are adapted from its `how`, `why`, `teach`, `unslop`, and `bro` skills.
- [explain-diff](https://gist.github.com/geoffreylitt/a29df1b5f9865506e8952488eac3d524) by Geoffrey Litt. `ace-explain-change` follows its idea of explaining a change with background, intuition, a code walkthrough, and a quiz.

The license notices of these projects are in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## License

Ace is under the MIT License. See [LICENSE](LICENSE).
