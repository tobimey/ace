# Deepening

How to merge a cluster of shallow modules into one deep module, given its dependencies. Uses the terms in [SKILL.md](SKILL.md).

## Dependency kinds

Sort each dependency of the cluster into one kind. The kind decides how the deep module is tested across its seam.

1. **In-process.** Pure computation or in-memory state, no I/O. Merge the modules and test through the new interface. No adapter.
2. **Local stand-in.** A dependency with a local test double, such as an in-memory database or filesystem. Run the stand-in in the tests. The seam stays internal, and the interface gets no port.
3. **Remote, owned.** Your own service across a network. Put a port at the seam. The deep module holds the logic, the transport is an injected adapter. Tests use an in-memory adapter, production uses the network adapter.
4. **Remote, third party.** A service you do not control, such as a payment provider. The deep module takes it as an injected port, and tests pass a mock adapter.

## Tests: replace, then delete

- Write the new tests at the deep module's interface. They assert on what a caller can observe.
- Delete the old tests of the shallow modules once the new tests cover their behavior.
- A test that has to change when only the implementation changes reaches past the interface. Rewrite it at the interface.
