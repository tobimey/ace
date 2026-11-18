# `ace/PRODUCT.md`

Optional. Who the product is for and where it is going, so each run of `ace-grill` ranks directions against the same goal.

| Section | What it holds | Used by |
|---|---|---|
| Users | Who the product is for | `ace-grill` |
| Goal | The one outcome "better" means right now | `ace-grill` |
| Non-goals | What the project leaves alone, even when it would help | `ace-grill` |
| Directions | The direction picked for each scope, with the date it was picked | `ace-grill`, which replaces a scope's line after each pick |

**Default.** No file. `ace-grill` asks for Users, Goal, and Non-goals in its anchor round, no direction is picked yet, and it creates the file from [templates/PRODUCT.md](../../ace-setup/templates/PRODUCT.md) once the user picks one.
