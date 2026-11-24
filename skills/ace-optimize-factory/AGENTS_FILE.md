# Agents file

Check the repo's `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` files (root and nested) against the rules below and propose minimal, surgical edits. Done means the user has said yes, no, or what to change for each edit, and only approved edits are made. Every fix that edits them follows the Constraints and Rules below.

## Constraints

- Show numbered, surgical edits (exact text to add, change, or remove) first. Apply only what the user approves, as changed.
- Keep the user's voice and structure. Touch only lines a rule below calls for; leave compliant lines as they are.
- Prefer cutting or moving lines out over adding lines.
- Mark every section Ace adds with `<!-- added by ace -->` on the line above it.

## Rules

- **Minimal and high-signal**: Every line loads into every session. Keep only what every task in that scope needs (orientation, core glossary, edit policy, navigation pointers). Cut anything the agent can read from code or config, generic filler ("write clean code", "be careful"), dead paths or commands, and lines that contradict each other or `ace/` files.
- **Route specifics elsewhere**: Move mechanical rules to a linter or CI check, coding and review rules to `ace/CODING_STANDARDS.md`, and procedures or long reference docs to skills or linked docs, leaving a short pointer only when every session needs it.
- **Action wording**: Each instruction follows the wording rule in [ace-skill-best-practices](../ace-skill-best-practices/SKILL.md).
- **Root essentials**: the project summary and glossary of [templates/ROOT_AGENTS_FILE.md](../ace-setup/templates/ROOT_AGENTS_FILE.md), with core terms as [contract/GLOSSARY.md](../ace-mode/shared/adapters/contract/GLOSSARY.md) says, and the `## Ace` section from "Reference: root agents section" in [CORE.md](../ace-setup/CORE.md). Without `ace/VERIFY.md`, list the exact check commands (lint, typecheck, tests, build) and how to check behavior.

## Steps

1. Find and read `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` at the repo root and in subdirectories (skipping vendored and generated folders). When several exist in a folder, note if one only points to another. If none exist at the root, propose creating `AGENTS.md`.
2. Check referenced file paths and commands against the repo, and check for overlap or conflict with `ace/` files.
3. Present numbered edits. For each, show the file, the rule it serves, and the exact text to add, change, remove, or move (naming the destination when moving). Stop and ask the user: yes, no, or what to change.
