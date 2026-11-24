# Deps

Outdated dependencies.

## Before scanning

Run the package manager's outdated command for every workspace, such as `pnpm outdated -r`. Read the Dependencies section of the coding standards when it has one.

## Find

Each outdated package once, current against latest, not only what its range allows.

- Patch and minor: bump.
- Major: bump only when its official changelog or release notes show no breaking change this project hits.
- Careful packages, at any bump size: read the official changelog first, and bump when nothing in it breaks how this project uses them. Careful are frameworks, compilers, runtimes, auth, database clients, and what the Dependencies section names.

## Drop

- Packages from this workspace.
- Majors of frameworks, compilers, and runtimes, and the majors the Dependencies section keeps for a person. They are migrations.
- A major or careful bump with no official changelog.
- A bump whose code change is a migration. A small change the changelog asks for belongs to the bump.

When in doubt, skip the package.

## Fix

Bump each version where it is pinned: a shared catalog, or each manifest that declares it. Move peer sets together, such as a framework and its types. When the install rejects a version as too new, take the newest it accepts. When the checks fail from one bump, fix the code or revert that bump and skip it.

## Report

Three tables, also for the pull request summary: Updated (package, from, to, kind, notes), Skipped (package, from, latest, reason), and Risky to merge (each bump that needed a code change or leaves doubt, or "None"). When nothing was bumped, report the Skipped table only.
