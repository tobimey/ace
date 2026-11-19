# Naming

A name fails when a reader cannot tell from it why the thing exists and what it does.

## Before scanning

Read the glossary in the root agents file, and `ace/GLOSSARY.md` when it exists. Its terms are the product's words.

## Find

Read what a reader sees without opening a body: file names, exports, and local functions that are the only map of their file. Guess what each does from its name, then read the body. A wrong guess is a finding:

- Opaque: the name says neither why it exists nor what it does.
- Off-glossary: a synonym or vendor word where the glossary has a term.
- Implementation: it names the tool, storage, or shape, such as `stripeWrapper` or `memberArray`, instead of the concept.
- Vague verb: `process`, `handle`, or `run` with no object.
- Steps: it lists how, such as `fetchThenSave`, instead of the outcome.
- Overclaim: it promises more than the body does, such as `syncAllContacts` that sets one field.
- Misaligned: nearby code uses another word for the same thing.
- Unnameable: no few honest words fit, because the unit does several jobs.

## Drop

- What a linter or the coding standards own: case, prefixes, suffixes, file-name punctuation.
- An honest name you would only rephrase.
- A name that code outside the repository depends on.

## Fix

Rename one cluster: one concept, or the names that must change together to stay aligned. Rename a file and its main symbol together. Report as candidates an Unnameable unit, with the jobs it mixes, and a name that needs a word the glossary lacks.
