# AGENTS.md for ace 

Ace is a adaptable skills framework.

I'm a software engineer and content creator (Tobi Mey). With this project I want to build my own skills system. It will later be published as an open source project. 

The core idea is to combine the best of multiple skill systems like pstack, matt pocock... and also add things like auditors and review skills on top of it. 

Currently many things are not clear. Read the `./README.md` file for more information.

## The competition

When I say "the competition", I mean these skill systems:

| Name | By | Source |
|---|---|---|
| pstack | Lauren Tan | https://github.com/backnotprop/pstack (mirror of https://cursor.com/marketplace/cursor/pstack) |
| mattpocock/skills | Matt Pocock | https://github.com/mattpocock/skills |
| gstack | Garry Tan | https://github.com/garrytan/gstack |
| tstack | Theo Browne (t3dotgg) | https://github.com/t3dotgg/tstack |
| Superpowers | Jesse Vincent (obra) | https://github.com/obra/superpowers |

Ace adapts skills from pstack and mattpocock/skills (see `THIRD_PARTY_NOTICES.md`). It does not build on the others. When I ask how Ace compares, or what the competition does better, read their skills at the source and compare them with `skills/`.

## Building Ace with Ace

This repository is the source code of Ace, and it also uses Ace to build itself. Keep the two apart:

| | Paths | What it is |
|---|---|---|
| **Ace source** (the product) | `skills/`, `skills/ace-setup/templates/`, `README.md` | What I build and later publish. |
| **Installed Ace** (the tooling) | `.agents/skills/`, `.claude/skills/`, `skills-lock.json`, `ace/` | Copies and adapters this repo runs on. Generated from the source. |

Rules:

- When I say "Ace" ("What are the worst parts of Ace?", "improve the review skill"), I mean the Ace source. Read and judge `skills/` and `README.md`, not how this repo is set up to use Ace.
- Change skills in `skills/`. Never edit `.agents/skills/` or `.claude/skills/` by hand; they get overwritten when the skills are reinstalled.
- The files in `ace/` configure this repo only. They are not Ace templates; the templates live in `skills/ace-setup/templates/`.
- I mean the installed Ace only when I say so explicitly, e.g. "our ace setup", "the installed skills", or a path under `.agents/` or `ace/`.
- If the installed skills and the source disagree, the source is the truth. The installed copy is just out of date.
- `README.md` describes what the skills do. When you change a skill's behavior, settings, files, or names, update the README text that describes it in the same change, and say what you updated. When the README and a skill disagree, the skill is the truth.
- This repo uses Ace only in part. For now there is no ticket tracker and no pull request review. Skip any skill step that reads, opens, or updates a ticket, or that reviews or comments on a pull request, and say that you skipped it. Review the local diff instead.

### Keep skills short

Every line in a skill costs context and money on each run, so a skill must not grow with every feature. When I ask for a change or a new feature in `skills/`:

- Before you add text, look for text to change instead: a rule that already covers the case, a step to widen, a section to merge, an example to swap.
- Cut what the change makes redundant, outdated, or obvious to the model.
- Move detail that only some runs need into a separate file the skill loads on demand.
- Add a new section only when none of the above works, and say why.
- When you finish, report the word count of each changed skill before and after (`wc -w`). If a skill grew, say what you tried first and why it had to grow.

### Glossary 

- you: the agent writing code in this project
- I, me, myself: the developer of ace that is driving that repository 
- the user: somebody who uses the ace system to build software, mostly a developer ... 
- project: a codebase / repository ...

<!-- added by ace -->
## Ace

- Use the terms in `ace/GLOSSARY.md`.
- To verify a change, follow `ace/VERIFY.md`.
- To read, search, open, or update a ticket, follow `ace/TICKET_TRACKER.md`.
- To open or comment on a pull request, follow `github/PULL_REQUESTS.md` in the `ace-adapters` skill.
- Answer a question, a report, or an idea with an answer or a proposal, and leave the files as they are. Change files only when the message asks for it, such as "do it", "implement", "fix", or "add". When unsure, propose the change and ask. 