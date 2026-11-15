---
name: ace-create-ticket
description: Creates one ticket body in the shared shape.
disable-model-invocation: true
---

# Create ticket

Write one ticket body. Done means the body uses the headings below, in this order, and no other `###` heading.

## Constraints

- Do not open the ticket. Do not set labels, type, Priority, Size, assignee, or project.
- Do not put Priority or Size in the body.
- Do not invent a `###` heading.
- Omit Rules when there are none.
- Omit Parent and Blocked by unless the caller supplied them. Leave the caller's text in those two sections.

## Inputs

The caller supplies the role for Who this is from, and the facts for Goal, Task, and Done when. It may also supply Rules, Parent, and Blocked by.

A caller may add a rule for what goes inside a section. Follow that rule. The headings stay the ones below.

## Type, Priority, and Size

The caller chooses these and passes them to the ticket tracker, not the body.

Type is `Bug` for a fix, `Feature` for new behavior, `Chore` when nothing a person using the product would notice changes.

Priority is `Urgent`, `High`, `Medium`, or `Low`.

Size is the concrete work:

- `S`: a few lines in one file
- `M`: inside one feature
- `L`: crosses features
- `XL`: auth, tenant isolation, webhooks, or stored data

## Workflow

```
- [ ] 1. Take the caller's facts
- [ ] 2. Write the body
- [ ] 3. Stop
```

## 1. Take the caller's facts

Use the role and the section facts the caller supplied.

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

## 3. Stop

Hand the body back. Do not open the ticket.
