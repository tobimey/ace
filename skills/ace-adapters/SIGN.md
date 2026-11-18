# Sign what you post

Everything you write to a ticket tracker or a code host starts with one line that names the model that wrote it: `Model: <model id>`, such as `Model: claude-opus-5-5`. That covers a pull request body, a pull request comment, a reply in a review thread, an inline comment, a ticket body, and a ticket comment. It holds for every adapter, also a project's own file in `ace/`.

- When the text carries a marker such as `<!-- ace-review -->`, the marker comes first and the model line second, so the model line is the first visible line.
- When you edit an earlier comment, write the line again with your own model.
- Take the model id from the `ACE_MODEL` environment variable when it is set. Otherwise use the id your harness gives you, or its name for the model when it gives no id.
- When a default puts the text into the reply instead, such as a ticket with no ticket tracker, the reply holds the model line too.
