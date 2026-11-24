---
name: ace-explain
description: Explains how a part of the codebase works, why it is built that way, or both, for a question, a change, or the agent's own work. Also writes an explainer for a change, with a walkthrough and a quiz, and posts it on the pull request.
disable-model-invocation: true
---

# Explain

Answer a question about the code: how it works now, why it is built that way, or both. Done means the user understands it well enough to act on it.

When the caller asks for an explainer of a change, or to post one on a pull request, follow [Explainer](EXPLAINER.md) instead of the steps below.

## Constraints

- Read only. The one exception is the glossary change in step 6, and only once the user agrees.
- Use the glossary terms.
- Back each claim with a source: `path:line` for how (omitted when `communication` is `product`), a commit, pull request, ticket, or doc for why. Mark what no source confirms as a guess or an inference. These hedges are findings, so keep them in the reply.
- Explain, then stop and let the user answer. Leave out quizzes, "pause" markers, requests to repeat it back, and "the tricky part" flags.
- Start with the point itself. Leave out framing labels such as "key insight", "TL;DR", or "at its core".

## Sources

Pick the sources the question needs:

- [How](HOW.md): how the code works now, from the code. For "how does X work", walkthroughs before a change, and "where should this live".
- [Why](WHY.md): why it is this way, from commits, pull requests, and tickets. For "why does X work this way", "why did we pick Y", "does this reason still hold", regressions, and thresholds.
- Both: an explanation of a change or a subsystem, "teach me this", "help me understand X", "explain this PR".

When the user asks about your own choices in this session, also answer from the session: what you considered, what you traded off, and why.

## Steps

1. **Pick what they should walk away with.** Choose a few points from why they ask (about to change it, reviewing it, debugging it, new to it) and what they already know. Read both from the conversation. Skip what they plainly know. When the scope is unclear, say how you read the question and go on. The user can redirect.
2. **Gather.** Follow each source file you picked, in parallel when your harness allows it. For a small change, one source may be enough.
3. **Start with a plain definition.** Name the thing and say what it is in general terms, with its common name if it has one. Then tie it to this project ("here we use it to ...") and build from there: how it works, the reasons, the edge cases. For each part, say what problem it solves and the mechanism that solves it. A list of functions is reference, not an explanation.
4. **Size the answer to the ask.** A "how does X work" before a change asks for a working mental model: give it in full. A why question gets the answer first, then the evidence. Teaching a change or a concept starts with the smallest complete answer, one or two sentences, and adds depth when they ask.
5. **Show it.** Open the diff or the code when `communication` is `code` and that is the fastest way to land a point. For anything with three or more moving parts, draw a series of diagrams, each one redrawing the last and adding one part, so the user watches the system assemble. A simple point needs no diagram.
6. **Close the loop.** When the user and you settled on a term that the glossary lacks or defines differently, propose the change to the glossary, as [its contract](../ace-mode/shared/adapters/contract/GLOSSARY.md) says.

**Reply:** the main point first, then the plain account of what, how, and why, with each source's hedges intact. End with the open questions worth following up, such as a why the record left open. With no live user, deliver it in one pass and put the offer to go deeper at the end.
