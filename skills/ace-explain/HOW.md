# How

Find out how the code works now, from the code as it is. Done means a senior engineer new to this area holds a mental model good enough to start working in it.

## Constraints

- Read only.
- Cite `path:line` for each claim. Mark what you could not confirm in the code as a guess.
- Answer how it works. Name the open why-questions at the end instead of guessing the reasons.

## Steps

1. If your harness can start sub-agents, start one read-only sub-agent with the question and the brief below, so the exploration stays out of your context. Otherwise follow the brief yourself.

   > Explore the codebase and write an explanation of how this works for a senior engineer who has never seen this area. After reading it, they should be able to start working here with confidence. Cover the entry points, the runtime flow from trigger to result, the key types and where they live, the boundaries to other parts of the system, and the parts a newcomer would get wrong. For a placement question, say where the code belongs and which existing code proves the convention. Cite `path:line` for each claim. You have read-only access.

2. Keep the content of the result. Edit it only for clarity or to connect it to the conversation.

**Output:** the explanation, then the open why-questions.
