# Skill checklist

## Contents

- Discovery
- Body
- Structure
- Freedom and scripts
- Frontmatter
- Fix on sight

## Discovery

`name` and `description` are the only skill text loaded at startup. When `disable-model-invocation` is omitted, they decide whether the body is read.

- `name`: lowercase, digits, hyphens; max 64 chars; matches the folder that contains `SKILL.md`
- `description`: third person; max 1024 chars; no XML tags
- When `disable-model-invocation` is `true`, the description is one line that says what the skill does, and only what. The skill loads only when named.
- When `disable-model-invocation` is omitted, the description answers **what** and **when**, and leaves the **how** to the body. A how-summary in the description trains the agent to skip the body. Include the words people actually say (slash name, "optimize this skill", domain nouns).
- Vague descriptions fail when the skill must self-trigger: "helps with documents", "processes data"

## Body

Every Authoring rule in [SKILL.md](SKILL.md), plus:

- The Requires section has no install check
- 500 lines is a ceiling, not a target
- Flag a missing example only on a rule that is easy to get wrong without it
- One term per concept. Pick one of "endpoint" / "route" / "path" for the same thing and use it everywhere
- No dated "before August 2025 use v1" rules. Put retired steps under a legacy heading
- Workflows are numbered steps. Quality-critical work has a validate → fix → repeat loop
- Verbatim user wording stays verbatim

## Structure

Progressive disclosure: metadata always; `SKILL.md` when triggered; sibling files and script **output** only when needed.

- `SKILL.md` is the map. Details live in sibling files it names
- Links are **one level deep** from `SKILL.md`. Every linked file is linked from `SKILL.md` itself
- Reference files over ~100 lines start with a table of contents
- No nested "skill inside a skill" folders that need a second `SKILL.md` unless they are truly separate skills

## Freedom and scripts

Match specificity to how wrong variation would be.

- High freedom: judgment tasks (review, writing)
- Medium: preferred template, some variation
- Low: fragile sequences (migrate, pack, deploy). Exact command, no extra flags

Prefer a script over a prose procedure when the step is deterministic, repetitive, or easy to hallucinate (validate, parse, generate, count, call an API).

Scripts:

- Say **Run** `scripts/foo.py` or **Read** `scripts/foo.py` for the algorithm, every time
- Forward slashes in paths
- Solve the job in the script and print the result
- Inputs via flags, env, or stdin. No interactive prompts

Offer **one default** tool or path, plus one alternative for the exception. A menu of four libraries freezes the agent.

## Frontmatter

- `disable-model-invocation: true` by default. `ace-mode` and other skills load the skill by path
- Omit `user-invocable` (Claude Code only). `disable-model-invocation` covers Claude Code, Cursor, Antigravity, and OpenCode (V2); `agents/openai.yaml` covers Codex
- With `disable-model-invocation: true`, add `agents/openai.yaml` next to `SKILL.md` containing `policy:` / `allow_implicit_invocation: false`, so Codex keeps it manual too. Remove that file when the field is removed
- Link a skill that has `disable-model-invocation: true` by relative path, e.g. `[ace-explain](../ace-explain/SKILL.md)`. The agent cannot load it by name
- Omit that field only for a skill that applies to every task, such as `ace-mode`

## Fix on sight

Each line is a defect, then the fix.

- Job skill bound to one caller (slash command, UI, parent skill, page) or one runner (local, cloud, an agent product): make the body work wherever it loads
- Rules or defaults copied from an `ace/` file or a contract file: point to the file
- Another skill named by its file path: name it by its `name`
- Text teaching what a PDF, git, or a standard library is: cut it
- A bare prompt with no steps: turn it into numbered steps
- One skill doing several verbs (review + deploy + docs): one skill per verb
- Bundled library source: depend on the package
- Human onboarding files (`README.md`, `CHANGELOG.md`) in the skill folder: remove them
- Backslash paths (`scripts\foo.py`): use forward slashes
- Sections for cases the skill does not have: cut them
- Purpose changed to make the checklist greener: restore the purpose
- A user complaint treated as a lint issue only: change behaviour until X is the mandated path
- Optional wording for a required behaviour ("consider", "you may", "if useful"): state it as an order
- Em dashes (U+2014) in any file under the skill folder: use a period or a comma. An en dash or a hyphen used as a dash is not a fix
