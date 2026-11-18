# `ace/VERIFY.md`

| Section | What it holds | Used by | Default |
|---|---|---|---|
| Checks | The commands that must pass: lint, typecheck, tests, build | `ace-verify`, `ace-implement`, `ace-review` | The commands the CI workflow runs. Add a lint, typecheck, test, or build script from `package.json`, `Makefile`, or the build tool's config when CI does not run that kind. In a workspace, run only the touched packages, with the filter CI uses. When there are none, there are no checks. Say so. |
| Run the app | How to start the app, or that nothing runs | `ace-verify`, which proposes a fix for a wrong step | The dev or start script, with the port and setup the README names. None when the project has no app, such as a library. |
| Check behavior | How to try each kind of change | `ace-verify`, which proposes missing lines and fixes for wrong ones | None. `ace-verify` finds a way with the tools this environment has. |
