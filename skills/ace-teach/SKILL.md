---
name: ace-teach
description: Explains a change, a subsystem, or the agent's own work so the user understands what it is, how it works, and why it is built that way. Use for "teach me this", "help me understand X", "explain this PR to me", or "why did you build it this way".
---

# Teach

Explain what a thing is, how it works, and why it is built that way, at the user's pace. Done means the user understands it. You change nothing.

Agents write most of the code in an Ace project. The user still has to review it, debug it, and decide where it goes next. This skill closes the gap between what the agent built and what the user understands.

## Requires

- `ace-how`
- `ace-why`
- `ace-unslop`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Constraints

- Read only.
- Write through `ace-unslop` and use the terms in `ace/GLOSSARY.md`.
- Keep the hedges from `ace-why` intact. They are findings, not style.
- Explain, then stop and let them answer. Leave out quizzes, "pause" markers, requests to repeat it back, and "the tricky part" flags.
- Start with the point itself. Leave out framing labels such as "key insight", "TL;DR", or "at its core".

## Steps

1. **Pick what they should walk away with.** Choose a few points from why they ask (about to change it, reviewing it, debugging it, new to it) and what they already know. Read both from the conversation. Skip what they plainly know.
2. **Gather.** Read the code yourself to get oriented. Then follow [ace-how](../ace-how/SKILL.md) for how it works and [ace-why](../ace-why/SKILL.md) for why, in parallel when your harness allows it. For a small change, one of them may be enough. Build on their output. When the user asks about your own choices, also answer from the session: what you considered, what you traded off, and why.
3. **Start with a plain definition.** Name the thing and say what it is in general terms, with its common name if it has one. Then tie it to this project ("here we use it to ...") and build from there: how it works, the deeper reasons, the edge cases. For each part, say what problem it solves and the mechanism that solves it. Listing functions is reference, not teaching.
4. **Give the smallest complete answer first.** One or two sentences, then stop. Add depth when they ask.
5. **Show it.** Open the diff or the code when that is the fastest way to land a point. For anything with three or more moving parts, draw a series of diagrams, each one redrawing the last and adding one part, so the user watches the system assemble. A single all-at-once diagram is reference, not teaching. A simple point needs no diagram.
6. **Follow their lead.** Offer to go deeper or move on. With no live user, deliver it in one pass and put the offer to go deeper at the end.
7. **Close the loop.** If the user and you settled on a term that `ace/GLOSSARY.md` lacks or defines differently, propose the glossary change. If the user wants to keep learning this area over several sessions, point them to `ace-learn`.

**Reply:** the explanation itself. Lead with the main point, then the plain account of what, how, and why, then the threads worth following with `ace-how` or `ace-why`.
