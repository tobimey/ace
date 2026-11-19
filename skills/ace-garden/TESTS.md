# Tests

A test that cannot fail guards nothing. For each assertion, ask which product fact could break unnoticed once it is deleted.

## Before scanning

Read the Tests section of the coding standards.

## Find

- Echo: it asserts that an identity or pass-through returns its input.
- Mock echo: it asserts that a mock returns what it was told to return, and the code under test never ran.
- Mirror: it builds the expected value with the same code the implementation uses.
- Valid echo: it parses a valid fixture and asserts the result equals the fixture, while reject cases exist.
- Too specific: it pins an incidental detail, such as a call count on an internal helper, beside an assertion that already checks the behavior.

## Drop

- Missing tests, flaky tests, and test style.
- A test that checks something important, even with more cases than you would write.
- A test that fails because the code is wrong. That is a bug.

## Fix

Change only the flagged tests. Delete the tautological ones, or the whole file when nothing important remains, and cut a too-specific test down to the assertion worth keeping. The fix ends there, with no replacement tests.
