---
status: accepted
---

# Campaign cover images are static files in `public/images/`, not Active Storage

`Campaign#cover_image_url` is a plain string column pointing at a file under
`public/images/` (e.g. `/images/background_orange.jpg`, downloaded from the reference
campaign), rather than an Active Storage attachment.

## Considered options

- **Active Storage** — the idiomatic Rails way to handle user-uploaded images, with variants,
  cloud storage backends, etc. Right tool if campaigns were created/edited through an admin
  UI with image uploads.
- **Self-hosted static file + URL column** (chosen) — there is no admin UI in this brief;
  every campaign is seeded, not uploaded, and there are exactly two of them. A column holding
  a path is the simplest thing that works, avoids provisioning cloud storage credentials for
  a demo deploy, and keeps `db:seed` self-contained (no upload step to script).

## Consequences

If campaign management ever grows an admin/upload flow, `cover_image_url` would need to be
replaced with (or backed by) an Active Storage attachment — a real migration, not just a
config change. `TASKS.md`'s "what you'd do with more time" list already names this.
