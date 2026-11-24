# Open ticket

Opens one ticket in the project's ticket tracker, with a body in the shared Ace shape. `ace-to-ticket`, `ace-audit`, and `ace-mode` open every ticket with this file.

Write one ticket body and open the ticket. Done means the ticket exists, its body uses the headings below in this order with no other `###` heading, and its URL is handed back. With no ticket tracker, done means the ticket is in the reply instead, as the default in [contract/TICKET_TRACKER.md](../ace-mode/shared/adapters/contract/TICKET_TRACKER.md) says.

## Constraints

- Open the ticket only as the "Open a ticket" section of `ace/TICKET_TRACKER.md`, or its default, says. Read that section before you write the body.
- Send type, Priority, Size, and Risk to the ticket tracker as that section says, and leave Priority and Size out when it records none. Keep all four out of the body.
- Use only the `###` headings below.
- Omit Rules when there are none.
- Omit Parent and Blocked by unless the caller supplied them. Leave the caller's text in those two sections.

## Inputs

The caller supplies the title, type, Priority, Size, Risk, the role for Who this is from, and the facts for Goal, Task, and Done when. It may also supply Rules, Parent, and Blocked by, and say to set the ticket ready. When a required input is missing, take it from the conversation. Ask only for what the conversation does not settle.

A caller may add a rule for what goes inside a section. Follow that rule. The headings stay the ones below.

## Type, Priority, Size, and Risk

The caller chooses these.

Type is `Bug` for a fix, `Feature` for new behavior, `Chore` when nothing a person using the product would notice changes.

Priority is `Urgent`, `High`, `Medium`, or `Low`.

Size is how much work it is:

- `S`: a few lines in one file
- `M`: inside one feature, and fits one agent session
- `L`: crosses features, or needs more than one session
- `XL`: too big for one ticket. Split it into sub-tickets with [SKILL.md](SKILL.md)

Risk is what breaks if the change is wrong, whatever its size:

- `High`: it touches auth, permissions, tenant isolation, payments, webhooks, secrets, or stored data and its migrations
- `Low`: everything else

## Workflow

```
- [ ] 1. Write the body
- [ ] 2. Open the ticket
- [ ] 3. Set it ready, when the caller says so
```

## 1. Write the body

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

## 2. Open the ticket

Open it with the caller's title, type, Priority, Size, and Risk.

## 3. Set it ready, when the caller says so

When the caller said to set the ticket ready, move it from needs-human to ready as the "Set a ticket state" section of `ace/TICKET_TRACKER.md` says. Otherwise leave it in needs-human.

Hand back the ticket URL and its state.
