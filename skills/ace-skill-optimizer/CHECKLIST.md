# Skill checklist

## Contents

- Discovery
- Body
- Structure
- Freedom and scripts
- Cursor
- Do not

## Discovery

`name` and `description` are the only skill text loaded at startup. When `disable-model-invocation` is omitted, they decide whether the body is read.

- `name`: lowercase, digits, hyphens; max 64 chars; matches the folder that contains `SKILL.md`
- `description`: third person; max 1024 chars; no XML tags
- When `disable-model-invocation` is `true`, the description is one line and does not say when to invoke the skill. The skill loads only when named.
- When `disable-model-invocation` is omitted, the description answers **what** and **when**, never **how**. A how-summary in the description trains the agent to skip the body. Include the words people actually say (slash name, "optimize this skill", domain nouns).
- Vague descriptions fail when the skill must self-trigger: "helps with documents", "processes data"

## Body

- State the goal and what done looks like, near the start. If the opening already says that, leave it.
- One section for constraints and forbidden actions. A heading such as "Constraints" or "Do not" counts. If that section exists, leave it.
- Call-site agnostic: a job skill's body does not name a slash command, UI, parent skill, or route as the place it runs. When `disable-model-invocation` is omitted, discovery `when` lives in `description`
- Follow the prefix rules in this skill. That list is the only prefix list. A job skill does not name the runner. An `ace-run-*` skill names Cursor Cloud Agent, follows `ace-env-cursor-cloud-agent`, names the job, and says a local chat does not load it. After the job returns, that starter posts, pushes, and moves labels. A pull request comment, review, or inline comment follows `ace-pr-comment`.
- Name another skill by its `name`, not by a path under `.agents/skills/`. Name a document by its role unless that path is the work.
- Shortest text that still works. Say each rule once. 500 lines is a ceiling, not a target
- Most rules have no example. Add one only when the instruction is easy to get wrong without it. Do not flag a missing example on every rule. Skip trivia a capable model already knows
- One term per concept. Do not mix "endpoint" / "route" / "path" for the same thing
- No dated "before August 2025 use v1" rules. Put retired steps under a legacy heading
- Workflows are numbered steps. Quality-critical work has a validate → fix → repeat loop
- Verbatim user wording stays verbatim

## Structure

Progressive disclosure: metadata always; `SKILL.md` when triggered; sibling files and script **output** only when needed.

- `SKILL.md` is the map. Details live in sibling files it names
- Links are **one level deep** from `SKILL.md`. Never `SKILL.md` → `advanced.md` → `details.md`
- Reference files over ~100 lines start with a table of contents
- No nested "skill inside a skill" folders that need a second `SKILL.md` unless they are truly separate skills

## Freedom and scripts

Match specificity to how wrong variation would be.

- High freedom: judgment tasks (review, writing)
- Medium: preferred template, some variation
- Low: fragile sequences (migrate, pack, deploy). Exact command, no extra flags

Prefer a script over a prose procedure when the step is deterministic, repetitive, or easy to hallucinate (validate, parse, generate, count, call an API).

Scripts:

- Say **Run** `scripts/foo.py` or **Read** `scripts/foo.py` for the algorithm. Never leave it ambiguous
- Forward slashes in paths
- Solve the job; do not print "ask the model to decide"
- Inputs via flags, env, or stdin. No interactive prompts

Offer **one default** tool or path, plus one alternative for the exception. A menu of four libraries freezes the agent.

## Cursor

- `disable-model-invocation: true` when the skill should run only via `/name`
- Omit that field when the agent should self-trigger from the description
- `paths` (not legacy `globs`) when guidance applies only while matching files are in play
- `name` must match the parent folder

## Do not

- Bind a job skill to one caller (slash command, UI, parent skill, page)
- Bind a job skill to one runner. Cloud facts belong in `ace-env-cursor-cloud-agent`
- Copy cloud facts into an `ace-run-*` skill. It follows `ace-env-cursor-cloud-agent`. Only its fallback without the trigger block stays in the starter
- Copy `ace-pr-comment` identity rules into an `ace-run-*` skill
- Use `gh` or the PAT for a pull request comment, review, or inline comment
- Point a skill at `docs/software-factory`
- Strip the Cursor Cloud Agent sentence from an `ace-run-*` skill. That sentence is the kind.
- An `ace-subject-*` skill
- Name another skill as `.agents/skills/<name>/SKILL.md`
- Teach what a PDF, git, or a standard library is
- Dump a ChatGPT prompt with no steps
- One mega-skill that is several verbs (review + deploy + docs)
- Bundle library source; depend on the package instead
- Human onboarding files (`README.md`, `CHANGELOG.md`) in the skill folder
- Windows paths (`scripts\foo.py`)
- Speculative sections for cases the skill does not have
- Change the skill's purpose to make the checklist greener
- Treat a user complaint as a lint issue only. If X is failing, add or change behaviour until X is the mandated path
- Optional wording for a required behaviour ("consider", "you may", "if useful")
- Em dashes (`—`) in any file under the skill folder. Use a period or a comma. An en dash or a hyphen used as a dash is not a fix
