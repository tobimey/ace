# Glossary

The project's terms, in two tiers: a core that every session loads, and a full glossary read when needed. Only the root has a glossary, also in a monorepo.

- **Core: the Glossary section of the root agents file.** Harnesses load that file into every session, so it holds only the terms most tasks meet, and the terms whose everyday meaning misleads here. One line per term: `- **term**: what it means here. Not: other words for it.` It leaves out words a senior engineer already knows. Keep it to about 25 terms.
- **Full: `ace/GLOSSARY.md`, optional.** Every term, the core ones included, with what does not fit on one line: how terms relate, examples, words to avoid, a section per bounded context. Its format is free. It is the truth, and a core line is the short form of its entry. Once it exists, the core section ends with ``Read `ace/GLOSSARY.md` for every other term and for detail.``

Until the full glossary exists, the core holds every term. Create it once the core passes about 25 terms, or once one word means different things in different parts of the project.

`ace-grill` adds terms, and `ace-explain` proposes them. With a full glossary, a new term goes there, and into the core only when the user agrees it is core. A change to a core term changes both in the same edit.

**Default.** No terms. `ace-grill` adds the Glossary section to the root agents file with the first term it settles. With no root agents file, it lists the terms in its summary instead.
