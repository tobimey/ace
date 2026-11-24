# `ace/VERIFY.md`

| Section | What it holds | Default |
|---|---|---|
| Checks | The commands that must pass: lint, typecheck, tests, build | The commands the CI workflow runs. Add a lint, typecheck, test, or build script from `package.json`, `Makefile`, or the build tool's config when CI does not run that kind. In a workspace, run only the touched packages, with the filter CI uses. When there are none, there are no checks. Say so. |
| Run the app | How to start the app, or that nothing runs | The dev or start script, with the port and setup the README names. None when the project has no app, such as a library. |
| Check behavior | How to try each kind of change: the tool, the command that shows the tool is ready, where to start, and what to look at | None. `ace-verify` picks a tool as "Pick the tool" says. |

## Pick the tool

Use the fastest tool made for agents, so each try takes few steps and tokens. Take the first that fits:

1. A control CLI or script the repo has for driving its app.
2. The tool for the surface in the table. Pin it in the repo when the user agrees, such as `npm install agent-browser`. Otherwise name its install command in the line, so every agent and runner can get it.
3. A tool built into this agent environment, such as a browser MCP or a preview pane, only when 1 and 2 cannot run here. Propose the tool from 2 for the line.

Write no one-off Playwright or Puppeteer script, and click no screenshot coordinates, while a tool above does the job. For a surface the table lacks, pick the newest tool made for agents to drive it, and say why.

| Surface | Tool | Ready |
|---|---|---|
| Web page, Electron app, Safari in the iOS Simulator | [`agent-browser`](https://github.com/vercel-labs/agent-browser): `open` a URL, `snapshot -i` for element refs, act on a ref, such as `click @e1`. Attach to a running Electron app or Chrome with `--cdp`. `--help` lists the rest. | `agent-browser doctor --offline --quick` |
| API endpoint | `curl`: send the request, check the status and body | `curl --version` |
| CLI or TUI | The CLI itself. For an interactive one, `tmux`: `send-keys`, then `capture-pane -p` | `tmux -V` |
