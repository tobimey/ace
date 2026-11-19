# Direction

The Which level of `ace-grill`: help the user pick the one direction to take the project, or one part of it, next. Done means the user picked one direction or chose none, the directions they did not pick are parked, and the user said whether to plan the pick now.

## Scope

The whole project, or the feature, page, service, or area the message names, such as `checkout`. With no scope named, it is the whole project.

## Constraints

- Read only, except `ace/PRODUCT.md` and the tickets step 5 opens.
- Settle the anchor before you offer any direction. Rank every direction against it.
- Offer one set of three to five directions per round, and at most two rounds, plus one set after the user corrects the anchor.
- Let the user pick. Recommend one direction, then wait. After the pick, go on with step 5 and offer no further direction.

## Workflow

```
- [ ] 1. Anchor
- [ ] 2. Gather facts
- [ ] 3. Offer directions
- [ ] 4. Pick
- [ ] 5. Park the rest
- [ ] 6. Record
- [ ] 7. Plan now, or stop
```

### 1. Anchor

The anchor is what makes one direction better than another. Read `ace/PRODUCT.md`, then ask one round of four questions, each with your recommended answer:

1. **Who** the scope is for.
2. **Goal**: the one outcome "better" means now, such as more people signing up, people coming back, faster work for them, fewer support requests, or a codebase that is cheaper to build on.
3. **Appetite**: how much work the next direction may take, such as a day, a week, or a month.
4. **Off-limits**: what the direction must leave alone, such as a part of the product, a dependency, or a kind of user.

Take each recommendation from `ace/PRODUCT.md` when it has the answer, otherwise from the README, the code, and the tickets. When the file answers all of Who, Goal, and Off-limits, ask a single question instead: still true, or what changed? Add the appetite to that question.

Wait for the answers. When the user names several goals, ask which one wins when they conflict.

### 2. Gather facts

When the harness can start sub-agents, start one for this step before you send the step 1 questions, so it runs while the user answers. Have it hand back facts only, without ideas. Otherwise do it yourself after step 1. Collect, for the scope:

- What it does today, from the README, the code, and the docs.
- Open tickets, searched as `ace/TICKET_TRACKER.md` says, including audit findings.
- What changed lately, from the git log.
- Any usage numbers, user feedback, or support notes the repo holds.

### 3. Offer directions

Write three to five directions. A direction is one bet on the goal and can hold several features. Keep only the ones that move the goal, fit the appetite, and stay clear of the off-limits list. Make them differ in kind: three versions of one idea count as one direction.

For each direction write:

- **Name**: a few words.
- **What**: what changes for the people in the scope, in one or two sentences.
- **Why**: how it moves the goal, with the fact from step 2 behind it.
- **Size**: `S`, `M`, `L`, or `XL`, as [OPEN_TICKET.md](../ace-to-ticket/OPEN_TICKET.md) defines them.
- **Rules out**: what picking it means the project leaves undone for now.

Then ask one question: which direction? List each name and `none` as choices. Recommend one and say why in one sentence. In the same question, say what happens next: the directions not picked are parked as tickets in needs-human, unless the user names ones to drop, and the anchor and the pick go into `ace/PRODUCT.md`. With no ticket tracker, the parked directions stay as a list in the reply.

The user's answer is the go-ahead for steps 5 and 6. Wait for it.

### 4. Pick

- **One direction**: that is the pick.
- **A changed or combined direction**: write it as one direction with all five fields, and ask for a yes.
- **None, and the user wants others**: in round one, ask what the set missed and offer one new set built on that answer. In round two, the anchor is wrong. Ask which part of it. When the user corrects it, offer one set against the new anchor, and that set is the last. When the user leaves it as it is, stop with nothing picked.
- **None, and done**: stop with nothing picked. Park and record nothing, unless the user asks.

### 5. Park the rest

For each direction the user neither picked nor dropped, search the tickets for one that already holds it, as `ace/TICKET_TRACKER.md` says, and skip it when one does. Open a ticket for each of the rest with [OPEN_TICKET.md](../ace-to-ticket/OPEN_TICKET.md):

- Title: the direction's name.
- Type: `Feature`, or `Chore` when nobody using the product would notice the change.
- Priority `Low`. Size as step 3 rated it. Risk as that file defines it.
- Who this is from: Grill.
- Goal: the direction's What. Task: its Why, its Rules out, and one line that says it was parked when the user picked another direction, and is planned with `ace-grill` before anyone builds it.
- Done when: `- [ ] A person picked this direction, and its plan is settled in tickets.`

Leave each ticket in needs-human, whatever `autonomy` says. Nobody has planned it.

With no ticket tracker, write one line per parked direction in the reply instead: its name, What, and Size.

### 6. Record

Write the anchor and the pick into `ace/PRODUCT.md`. When the file is missing, create it from [the template](../ace-setup/templates/PRODUCT.md). Otherwise change only the sections whose answer changed. In Directions, the scope gets one line, `- <scope>: <name>. <What> (picked <date>)`, which replaces that scope's earlier line. The appetite stays out of the file: it belongs to one run.

### 7. Plan now, or stop

Report in this shape, then ask one question: plan the pick now, or stop? Recommend planning now, unless the user said it should wait.

```
Direction: <name>. <What>
Anchor: <goal>, for <who>, within <appetite>
Parked: <ticket URLs, one line per direction, or "none">
Recorded: ace/PRODUCT.md <created | updated | unchanged>
```

Now: go on with How in `ace-grill`, with the pick as the plan. Its premise is settled. Stop: stop, and say that `Plan <name>` picks it up later.
