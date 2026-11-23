# Verify

How to prove a change works in this project. Every ace skill that runs checks or verifies behavior follows this file.

## Checks

Run every command below: lint, typecheck, tests, build, and any other check CI runs. A change is done only when each one passes.

```sh
node scripts/lint-skills.mjs
```

## Run the app

None.

## Check behavior

How to try a change, by what it touches. Use every line that matches the change.

- Skill (`skills/**/SKILL.md`): read the changed skill and confirm the workflow still matches the requested change.
- Adapter (`ace/*.md`): read the file and confirm the section headings ace skills look up are still there.
- Root agents file: confirm it still points at `ace/` and still loads from the repo root.
