---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the user passed no reference, take the next ticket as defined in [../to-tickets/TICKET-FORMAT.md](../to-tickets/TICKET-FORMAT.md) and tell the user which one you picked.

Use /tdd where possible, at the seams the spec or ticket agreed.

Typecheck and run single test files as you go; run the full suite once at the end.

Once done, mark the ticket `Implemented` if you worked one, then run /code-review against the ticket or spec, with the commit you started from as the fixed point.

Commit your work to the current branch.
