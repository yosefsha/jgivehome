---
status: accepted
---

# Solid Cache/Queue/Cable tables live in the primary database, not separate database configs

Rails 8 apps default to giving `solid_cache`, `solid_queue`, and `solid_cable` their own
databases via `connects_to`/`migrations_paths`/`database.yml` entries. Render's free tier
only provisions a single Postgres instance, so we initially pointed all four configs
(`primary`, `cache`, `queue`, `cable`) at the same `DATABASE_URL` while keeping them as
separate logical databases with their own `migrations_paths`.

That setup is silently broken on a shared physical database: every config also shares one
`schema_migrations` table, so once the primary's migrations run, Rails sees a non-zero
migration version for `cache`/`queue`/`cable` too and concludes *their* schemas are already
loaded. `db:prepare` never creates `solid_cache_entries`, `solid_queue_*`, or
`solid_cable_messages` — and the app doesn't fail at boot, only later, the first time
something tries to use one of those tables (for us: the post-donation Turbo Stream broadcast,
surfacing as a 500 on every donation submission). See `docs/BUGFIXES.md` (Critical) for the
full repro and stack trace.

We decided to stop declaring them as separate databases entirely. Their table definitions
now live as ordinary migrations in `db/migrate` (`20260608130000`–`20260608130002`,
copied from the gems' own schema templates), so the tables are created in the primary
database as part of the normal migration run — no separate `connects_to`, `database:`, or
`migrations_paths` config to keep in sync, and no shared-`schema_migrations` trap.

## Considered options

- **Give each gem its own physical database** — the "correct" multi-DB setup these gems are
  designed for, but Render's free tier only provides one Postgres instance; provisioning
  more isn't an option without a paid plan.
- **Keep separate logical-database configs sharing one URL** (the original approach) —
  rejected because it's exactly what's broken: shared `schema_migrations` masks the missing
  schemas until runtime.
- **Fold the tables into the primary database** (chosen) — simplest correct option for a
  single-Postgres deployment; the tables just become more rows/tables in the one database we
  already have, managed the same way as the app's own schema.

## Consequences

- If the project ever moves to a host with multiple databases (or a paid Render plan), these
  tables would need to be migrated out to dedicated databases and the corresponding
  `connects_to`/`database.yml` config restored — that's a real (if unlikely) reversal cost.
- `db/migrate` now contains gem-owned table definitions alongside app migrations; if
  `solid_cache`/`solid_queue`/`solid_cable` ship schema changes in future versions, we'd need
  to hand-write a new migration to apply them (no `bin/rails solid_x:install` shortcut,
  since that generator assumes the separate-database layout).
