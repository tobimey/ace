# Workspace formats

## MISSION.md

```md
# Mission: {topic}

## Why
{1 to 3 sentences. The concrete outcome. What the user can do once they have this, for example "review payment PRs without help", not "understand payments".}

## Success looks like
- {A specific, observable thing the user will be able to do}

## Constraints
- {Time, prior knowledge, how they like to learn}

## Out of scope
- {Nearby topics the user does not want to chase now}
```

Keep it under one screen. If it grows into a plan, it has stopped working as a mission. When the user's goal moves, update it, confirm the change with the user, and write a learning record about the shift.

## Learning records

`learning-records/NNNN-<slug>.md`. Take the highest number in the folder and add one.

```md
# {What was learned or established}

{1 to 3 sentences: what the user now knows, or knew already, and why it changes what to teach next.}
```

Add these only when they help:

- `Status: superseded by NNNN` when a later record corrects this one. Keep the old record.
- **Evidence**: how the user showed it (a question answered, an exercise done, experience they cited).
- **Implications**: what this unlocks or rules out for later lessons.

Write a record when the user shows real understanding of something non-trivial, states prior knowledge (with its depth), corrects a misconception, or shifts the mission. Those four events are the only reasons to write one.

## RESOURCES.md

```md
# {Topic} resources

## Project
- `src/payments/` and the Why file of `ace-explain` on the retry logic. Use for: how payments run here.

## Docs
- [Library docs, version the project uses](https://example.com). Use for: API details.

## Gaps
- {Areas the mission needs that no good source covers yet}
```

Annotate every entry with what it covers and when to use it. Prefer primary sources. Remove a source that turned out wrong or shallow.
