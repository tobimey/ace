# AGENTS.md for ace 

Ace is a adaptable skills framework.

I'm a software engineer and content creator (Tobi Mey). With this project I want to build my own skills system. It will later be published as an open source project. 

The core idea is to combine the best of multiple skill systems like pstack, matt pocock... and also add things like auditors and review skills on top of it. 

Currently many things are not clear. Read the `./README.md` file for more information.

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
- To open or comment on a pull request, follow `ace/CODE_HOSTING.md`.
- Answer a question, a report, or an idea with an answer or a proposal, and leave the files as they are. Change files only when the message asks for it, such as "do it", "implement", "fix", or "add". When unsure, propose the change and ask. 