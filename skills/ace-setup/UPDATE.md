# Update existing setup

Brings an existing `ace/` setup up to date after an Ace release, updating only the files the project already has.

## Step 0 · Silent audit

Inspect what already exists (including monorepo package `ace/` folders):

1. For each existing file in `ace/` (and `PACKAGE/ace/`), list the sections named in its matching file in [contract/](../ace-mode/shared/adapters/contract/) and check whether each section exists (found by its job). Skip sections covered by a selected built-in provider.
2. Check `ace/config.json` (when present) per "Schema update" below.
3. Check the root agents file for missing Glossary lines and missing `## Ace` lines (from [CORE.md](CORE.md)).

If nothing is missing or outdated, print this and stop:

```markdown
✅ **Your Ace setup is up to date!**

All existing files in `ace/` and `<root agents file>` already have every current section and setting. Run `/ace-help` anytime to see what's configured or add optional modules.
```

## Step 1 · Preview & confirm updates

Print the step card with the heading `🔄 **Ace Setup Update**` in place of the step line.

- **Why:** A newer version of Ace added sections or updated settings. Your existing choices stay intact; only missing pieces will be added.
- **Planned updates:** `<file>`: add `<section names>` (or remove retired setting `<key>`) · `<root agents file>`: <missing Glossary / `## Ace` lines, if any>
- **Question:** Apply these updates? **A)** Yes, apply updates · **B)** Skip specific items (tell me which)
- **Recommend:** **A)** Keeps your setup aligned with the installed Ace version.

## Step 2 · Apply & verify

On confirm:

1. For each missing section in an existing `ace/` file, copy it from its template in [templates/](templates/) (or the matching module guide when the template omits it) and fill placeholders. For a non-GitHub ticket tracker, write the missing section using that tracker's tool as [TICKETS.md](TICKETS.md) says.
2. Update `ace/config.json` (when present) per "Schema update" below, and add any missing Glossary or `## Ace` lines in the root agents file per [CORE.md](CORE.md).
3. If any verify file gained a new section, run Step 3 (**Test your checks**) from [CORE.md](CORE.md) for that file before finishing.

End with a compact recap:

```markdown
🎉 **Ace setup updated!**

**Updated:**
- ✅ `<file>`: <sections added or keys removed>
```

## Schema update

For an existing `ace/config.json`, ask no settings questions:

1. Keep every value whose key is still in [config.schema.json](config.schema.json).
2. Remove keys no longer listed in the schema and note each removed key in the summary.
3. Add `"ticket_tracker": "github-issues"` if missing and the project uses GitHub Issues.
4. Leave all other missing settings absent so their defaults apply.
