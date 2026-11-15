---
name: ace-implement
description: Implements a given plan, spec, or ticket with the smallest change that does the job.
disable-model-invocation: true
---

# Implement

Implement the plan, spec, or ticket the caller gives. Done means the requested behavior works, nothing outside the request was built, and the change passes the verification `AGENTS.md` describes.

## Approach

Aim for ambitious ideas, simple systems, and software that feels obvious.

- Measure twice, cut once. Understand the real constraint before writing code.
- Find the smallest model that makes the correct behavior unsurprising, then build that.
- Do not keep complexity just because it already exists. Where the change passes through it, replace it with the simpler shape.
- Do not add machinery because it looks architecturally impressive. Build only what this request needs now.
- Honor the developer's intent in a minimal and realistic way.

## Constraints

- Do not build what the plan does not ask for. Name it in the report instead.
- Look up facts in the code yourself. Ask only for decisions the plan leaves open.

## Workflow

1. Read the plan and the code it touches.
2. Pick the smallest shape that does the job.
3. Build it.
4. Verify as `AGENTS.md` says. Fix and repeat until it passes.
5. Report what changed and what was left out on purpose.
