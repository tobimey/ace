---
name: ace-how
description: Explains how a part of the codebase works now, from the code. Use for "how does X work", walkthroughs before a change, and "where should this live" or "which layer owns this" questions. Use ace-why for the reasons behind it.
---

# How

Answer "how does X work?" from the code as it is now. Done means the user holds a mental model good enough to start working in that area.

## Constraints

- Read only.
- Use the glossary terms.
- Back each claim with a `path:line` reference. Mark what you could not confirm in the code as a guess.
- Answer how it works. Leave "why is it built this way" to `ace-why`, and name the open why-questions at the end.

## Steps

1. If the scope is unclear, state how you read the question and go on. The user can redirect.
2. If your harness can start sub-agents, start one read-only sub-agent with the question and the brief below, so the exploration stays out of your context. Otherwise follow the brief yourself.

   > Explore the codebase and write an explanation of how this works for a senior engineer who has never seen this area. After reading it, they should be able to start working here with confidence. Cover the entry points, the runtime flow from trigger to result, the key types and where they live, the boundaries to other parts of the system, and the parts a newcomer would get wrong. For a placement question, say where the code belongs and which existing code proves the convention. Cite `path:line` for each claim. You have read-only access.

3. Present the result. Keep its content. Edit only for clarity or to connect it to the conversation.

**Reply:** the explanation, then the open why-questions worth asking `ace-why`.
