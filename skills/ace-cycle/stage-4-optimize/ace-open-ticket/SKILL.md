---
name: ace-open-ticket
description: Opens one ticket in the project's ticket tracker, with a body in the shared ace shape. Use when the user or another skill asks to open, create, or file a ticket or issue.
---

# Open ticket

Write one ticket body and open the ticket. Done means the ticket exists, its body uses the headings below in this order with no other `###` heading, and its URL is handed back.

## Constraints

- Open the ticket only as the "Open a ticket" section of `ace/TICKET_TRACKER.md` says. That section is the only way to open it.
- Find each adapter section by its job. Its heading may differ from the one named here. If the file or the section is missing, name it and say what it must hold, before you write the body. Offer to add it, and go on once the user agrees. With nobody to ask, or when the user declines, stop.
- Send type, Priority, Size, and Risk to the ticket tracker as its "Open a ticket" section says, outside the body.
- Use only the `###` headings below.
- Omit Rules when there are none.
- Omit Parent and Blocked by unless the caller supplied them. Leave the caller's text in those two sections.

## Inputs

The caller supplies the title, type, Priority, Size, Risk, the role for Who this is from, and the facts for Goal, Task, and Done when. It may also supply Rules, Parent, and Blocked by. When a required input is missing, take it from the conversation. Ask only for what the conversation does not settle.

A caller may add a rule for what goes inside a section. Follow that rule. The headings stay the ones below.

## Type, Priority, Size, and Risk

The caller chooses these. They go to the ticket tracker, not the body.

Type is `Bug` for a fix, `Feature` for new behavior, `Chore` when nothing a person using the product would notice changes.

Priority is `Urgent`, `High`, `Medium`, or `Low`.

Size is how much work it is:

- `S`: a few lines in one file
- `M`: inside one feature, and fits one agent session
- `L`: crosses features, or needs more than one session
- `XL`: too big for one ticket. Split it into sub-tickets with `ace-to-ticket`

Risk is what breaks if the change is wrong, whatever its size:

- `High`: it touches auth, permissions, tenant isolation, payments, webhooks, secrets, or stored data and its migrations
- `Low`: everything else

## Workflow

```
- [ ] 1. Read the ticket tracker
- [ ] 2. Write the body
- [ ] 3. Open the ticket
```

## 1. Read the ticket tracker

Read `ace/TICKET_TRACKER.md` and find the section on opening a ticket.

## 2. Write the body

```markdown
### Who this is from

The role that filed it, such as Security Auditor or Ticket.

### Goal

What should be true when this is done, from the person's point of view.

### Task

What to do.

### Done when

- A check a reviewer can fail.

### Rules

- A constraint on how to do the task.

### Parent

The parent ticket, when the caller supplied one.

### Blocked by

The blocking tickets, when the caller supplied them.
```

Fold any other top-level heading into Task or Rules.

## 3. Open the ticket

Open it as the "Open a ticket" section says, with the caller's title, type, Priority, Size, and Risk. Hand back the ticket URL.
