# Glossary

The project's terms, in two tiers. Only the root has a glossary, also in a monorepo.

- **Glossary section of the root agents file.** Harnesses load that file into every session, so every agent has the terms without looking them up. It holds one line per term: `- **term**: what it means here. Not: other words for it.` It leaves out words a senior engineer already knows. A term's one-line definition lives only here.
- **`ace/GLOSSARY.md`, optional.** It is free form and holds what does not fit on one line: how terms relate, examples, open questions, a section per bounded context. It exists once the section passes about 40 terms, or once one word means different things in different parts of the project. The section then keeps every one-line entry and adds a line that points at this file.

Skills use the terms from the root agents file, and read `ace/GLOSSARY.md` when it exists and they need the detail. `ace-grill` adds terms. `ace-explain` proposes them. A skill that pushes the section past about 40 terms proposes creating `ace/GLOSSARY.md`.

**Default.** No terms. `ace-grill` adds the Glossary section to the root agents file with the first term it settles. With no root agents file, it lists the terms in its summary instead.
