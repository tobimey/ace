---
name: ace-learn
description: Runs a course over several sessions so the user builds lasting skill in a topic tied to their project, such as a subsystem, a library the project depends on, or a technique. Keeps a learning workspace with a mission, learning records, lessons, and reference sheets. Use for "I want to learn X", "get me fluent in this codebase", or to continue a course.
argument-hint: "What do you want to learn?"
---

# Learn

Teach the user a topic over several sessions, so they can do something new without the agent. Done for one session means the user finished one lesson and the workspace records what they now know.

`ace-teach` explains one thing once. `ace-learn` is for when the user wants the knowledge to stay.

## Requires

- `ace-how`
- `ace-why`
- `ace-teach`

Before you start, check that each skill above is installed: its folder sits next to this skill's folder. If one is missing, stop and tell the user to install it with `npx skills add tobimey/ace --skill NAME`.

## Constraints

- Ground every claim in a primary source and cite it, including what you think you already know.
- One mission per workspace. Two unrelated topics are two workspaces.
- Teach one lesson per session.
- Confirm with the user before you change the mission.

## The workspace

Learning state is personal, so it lives outside the project. Default to `~/.ace/learn/<topic>/`. Use another directory if the user names one. Create files only when you first need them.

- `MISSION.md`: why the user wants this. Every lesson traces back to it. Format in [FORMATS.md](./FORMATS.md).
- `RESOURCES.md`: the trusted sources, each with one line on when to reach for it.
- `learning-records/NNNN-<slug>.md`: what the user has shown they know, prior knowledge they stated, and misconceptions they corrected. Not a journal.
- `lessons/NNNN-<slug>.html`: one lesson per file.
- `reference/*.html`: short cheat sheets distilled from the lessons. The user comes back to these, rarely to lessons.
- `assets/`: a shared stylesheet and reusable widgets every lesson links to.
- `GLOSSARY.md`: topic terms the user can already use correctly. Terms the project defines stay only in the project glossary.
- `NOTES.md`: how the user likes to be taught.

## Sources

- **The project.** For anything about the codebase, the code is the primary source. Follow [ace-how](../ace-how/SKILL.md) for how it works and [ace-why](../ace-why/SKILL.md) for why. Cite `path:line`, commits, and pull requests.
- **Outside the project.** Use official docs, specs, and source code of the library or tool. Prefer the version the project actually depends on. Record each one in `RESOURCES.md`.

## Steps

1. **Load the workspace.** If it does not exist or `MISSION.md` is empty, interview the user about why they want this and write the mission first. A vague mission ("understand X") is not enough. Push for what they will be able to do ("review payment PRs without help").
2. **Warm up with retrieval.** From the second session on, start with two or three short questions on earlier learning records. Recall from memory is what makes knowledge last. Pick older records first, so practice spreads over time.
3. **Pick the next lesson.** Read the learning records and the mission. Choose the most useful next step that the user is ready for: hard enough to stretch them, close enough to what they know to land. If the user names a topic, teach that.
4. **Write the lesson.** One self-contained HTML file that links the shared stylesheet. Short enough to finish in one sitting, with one concrete win. Teach only the knowledge the win needs, with plain language and citations. Then make the user practice with feedback, ideally against the real project: trace a request, predict what a change breaks and run the tests to check, find where a rule lives. For quizzes, make every answer the same length and vary the position of the right one. End with one primary source to read next and a reminder to ask you questions.
5. **Open the lesson** with a CLI command if you can. Answer questions as [ace-teach](../ace-teach/SKILL.md) would.
6. **Record what was learned.** Write a learning record only on evidence: the user used the idea correctly, stated prior knowledge, or corrected a misconception. Covering a topic is not learning. Add terms to the workspace glossary once the user uses them correctly. Update or add a reference sheet. Note teaching preferences in `NOTES.md`.

**Reply:** what this lesson teaches and why it is next, the path to the lesson, and the one thing to try first.
