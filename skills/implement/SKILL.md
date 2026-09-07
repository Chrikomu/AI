---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the user passed no reference, take the next ticket from the offline tracker described in [../to-tickets/TICKET-FORMAT.md](../to-tickets/TICKET-FORMAT.md): the frontier ticket with the lowest `priority`. Tell the user which one you picked.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

Commit your work to the current branch. If you worked a ticket, set its `state` to `Implemented`.
