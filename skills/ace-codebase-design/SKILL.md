---
name: ace-codebase-design
description: Shared vocabulary and principles for module design, built on deep modules, that other Ace skills load.
disable-model-invocation: true
---

# Codebase design

Design deep modules: a lot of behavior behind a small interface, placed at a clean seam, tested through that interface. Callers get leverage, maintainers get locality, and tests survive refactors. This skill is a reference. Use its terms and principles wherever code is designed, reviewed, or audited for its shape.

## Constraints

- Use the terms below exactly. Say module, not component, service, or unit. Say interface, not API or signature. Say seam, not boundary.
- Name modules with the domain terms in the glossary.
- Treat decisions the coding standards or tickets record as settled. Propose a shape against one only when its reason no longer holds, and name the decision.

## Terms

- **Module**: anything with an interface and an implementation, at any scale: a function, a class, a package, or a slice across tiers.
- **Interface**: everything a caller must know to use the module correctly. The types, plus invariants, ordering, error modes, required config, and performance.
- **Implementation**: the code inside a module.
- **Depth**: leverage at the interface, the behavior a caller or test can use per unit of interface it has to learn. A module is deep when a lot of behavior sits behind a small interface, and shallow when the interface is nearly as complex as the implementation.
- **Seam**: the place where a module's interface lives, where behavior can change without editing that place. Where the seam goes is its own decision, apart from what goes behind it.
- **Adapter**: a concrete thing that fills an interface at a seam. The word names its role, not its contents.
- **Leverage**: what callers get from depth. One implementation pays back across every caller and test.
- **Locality**: what maintainers get from depth. Change, bugs, and knowledge sit in one place. Fix once, fixed everywhere.

## Principles

- **Depth belongs to the interface.** A deep module may be built from small parts inside. They stay out of its interface. A module can have internal seams for its own tests and one external seam at its interface.
- **Deletion test.** Imagine deleting the module. When its complexity vanishes, it was a pass-through. When the complexity reappears across its callers, it was earning its keep.
- **The interface is the test surface.** Callers and tests cross the same seam. A test that has to reach past the interface means the module has the wrong shape.
- **One adapter is a hypothetical seam. Two adapters make a real one.** Add a seam only when something varies across it, such as production and test.
- **Testable by shape.** A module takes its dependencies as inputs, returns results instead of changing what it was given, and keeps its interface small.

## Going deeper

- [DEEPENING.md](DEEPENING.md): how to deepen a cluster of shallow modules by the kind of dependency it has, and how its tests change.
