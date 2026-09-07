# Ticket format

The offline issue tracker is a flat directory, `.scratch/tickets/`, holding one JSON file per ticket, named `<id>.json`. Humans review and reprioritise through a GUI; agents read and write the files directly.

```json
{
  "id": "auth-02",
  "title": "Log in with email and password",
  "state": "Ready",
  "priority": 20,
  "blockedBy": ["auth-01"],
  "spec": ".scratch/auth/spec.md",
  "body": "## What to build\n\n...\n\n## Acceptance criteria\n\n- [ ] ...\n- [ ] ..."
}
```

- `id`: `<feature-slug>-<NN>`, `NN` zero-padded from `01` in dependency order (blockers first). Unique across the directory.
- `state`: `Ready`, `Implemented`, or `Reviewed`.
- `priority`: integer, lower runs first. New tickets continue from the directory's current maximum. Ids keep dependency order; priority decides what runs next.
- `blockedBy`: ids of tickets that must be `Reviewed` before this one can start. Empty when it can start immediately.
- `spec`: path of the originating spec, or omitted.
- `body`: Markdown. "What to build" is the end-to-end behaviour from the user's perspective, not a layer-by-layer list, followed by checkbox acceptance criteria.

The **frontier** is every `Ready` ticket whose blockers are all `Reviewed`. The next ticket to work is the frontier ticket with the lowest `priority`.
