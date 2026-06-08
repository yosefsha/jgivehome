---
status: accepted
---

# Hotwire (Turbo + Stimulus) over a client-side SPA for live campaign updates

The brief requires that submitting a donation visibly updates the campaign's progress for
everyone viewing the page, without a reload. We built this with Rails 8's default Hotwire
stack — Turbo Frames for the donation modal, Turbo Streams broadcast over Action Cable
(`broadcast_replace_to`/`broadcast_prepend_to`) for live stat/donation-list updates, and
Stimulus controllers for client-side interactivity (modal, tabs, donation form) — rather than
building a separate JSON API and a React/Vue SPA on top of it.

## Considered options

- **SPA + JSON API** — would need a separate frontend build/deploy, client-side state
  management for "live" updates (polling or a hand-rolled WebSocket layer), and duplicated
  validation/rendering logic between server and client. More moving parts for a single-page
  demo.
- **Hotwire** (chosen) — server-rendered views stay the single source of truth; "live update"
  is just broadcasting a re-rendered partial over the websocket connection Turbo already
  manages. Matches the scale of the app (one campaign page) and is what Rails 8 ships with by
  default, minimizing infrastructure to keep working.

## Consequences

Real-time delivery now depends on Action Cable's pubsub backend being correctly wired up —
see [ADR-001](ADR-001-solid-tables-share-primary-database.md) for how a misconfigured
`solid_cable` setup turned this into a production 500 on every donation.
