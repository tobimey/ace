# Pass-through

Code whose only job is forwarding: a wrapper that adds nothing, or a value carried through layers that never use it.

## Before scanning

Read [CODEBASE_DESIGN.md](../ace-mode/shared/codebase-design/CODEBASE_DESIGN.md), for its deletion test.

## Find

- A wrapper with one caller that fails the deletion test: its body is one element around its children, one call, or a constant. Names such as Wrapper, Shell, Frame, or Container that own no layout, state, or seam are typical.
- A value passed through two or more layers that neither read nor change it, such as a prop drilled through components that only hand it on.

## Drop

- Two or more callers. Tests and stories count.
- A seam the code needs: a code-split target, a client and server or process boundary, a module that keeps state alive.
- Framework entry files, such as routes, pages, and layouts.
- A public export of a package.
- A unit with a job of its own, even with one caller.
- A value that must cross a seam, such as serializable props into a client component.

## Fix

Take the first of these that keeps behavior:

1. Inline the wrapper into its caller and delete it, with the types and constants only it used. Pick another fix when the caller would then mix two jobs.
2. Pass the value from its owner to its user directly, past the layers that only forwarded it.
3. Let the owner render the user as a child of those layers.
4. Let the user load the value itself, through the data access the project already has.

Add new shared state, such as a context or a store, only when several consumers at different depths read the same value.
