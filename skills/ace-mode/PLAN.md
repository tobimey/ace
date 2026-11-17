# Plan and Prototype

The playbooks that settle what to build before any code changes. `ace-mode` routes here. Its constraints and its "Questions" format apply.

## Plan

1. `ace-grill` with the message, until the design tree has no open branch. When grill stops after a verdict or with no direction picked, stop. When a decision turns on something only running code shows, such as speed or how a layout feels, run Prototype below for it and bring its result to that question.
   `ace-grill` writes the settled plan into a ticket, unless the user chose no ticket.
2. Ask one question in the format of the "Questions" section of `ace-mode`: implement it here now, or stop? Recommend stopping when grill opened sub-tickets, or when the work should wait. Otherwise recommend implementing here. Wait for the answer.
3. Here: run the Build playbook of `ace-mode` with the settled plan, or with its ticket, and hand off as Build. Stop: stop.

## Prototype

1. Write the question and the result that settles it, in two lines.
2. Build the smallest sketch that shows that result, on a throwaway branch or in a scratch folder. It needs no tests, review, or coding standards.
3. Run it and look at the result. Try each option the same way.
4. Answer with what you saw and the choice it points to. Delete the sketch, unless the user wants to keep it.
