# Verify

How to prove a change works in this project. Every ace skill that runs checks or verifies behavior follows this file.

## Checks

Run every command below: lint, typecheck, tests, build, and any other check CI runs. A change is done only when each one passes.

```bash
<CHECK_COMMANDS>
```

## Run the app

<RUN_APP>

## Check behavior

How to try a change, by what it touches. Use every line that matches the change. Each line names the tool, where to start, and what to look at. `ace-verify` adds a line when it finds a kind of change this list misses, and fixes a line that is wrong.

<CHECK_BEHAVIOR>
