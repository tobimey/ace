# Package folders

In a monorepo, a package can have its own `ace` folder, such as `apps/web/ace/`. It holds only `VERIFY.md` and `CODING_STANDARDS.md`. For a path, an adapter is the root file in `ace/` plus the same file in each `ace` folder between that path and the repo root. A package file adds to the root one:

- `VERIFY.md`: run the checks of the root file and of every package file. Start the app and try a behavior as the nearest file with that section says.
- `CODING_STANDARDS.md`: the rules of all files apply. The root file wins on conflict.

No file lists the package folders. A skill finds them from the paths it works on: for a diff, walk up from each changed path; for the whole repo, run `git ls-files '*/ace/VERIFY.md' '*/ace/CODING_STANDARDS.md'`.

The glossary, ticket tracker, code hosting, cycle, and settings exist only at the root.
