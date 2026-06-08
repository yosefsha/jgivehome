---
status: accepted
---

# Postgres for every environment and every Rails 8 "solid" subsystem

Rails 8 defaults to SQLite for new apps, and ships `solid_cache`/`solid_queue`/`solid_cable`
expecting their own databases. We chose Postgres as the *only* database engine across
development, test, and production, and — per [ADR-001](ADR-001-solid-tables-share-primary-database.md)
— ultimately one single Postgres database for the app's own tables and all three solid_*
subsystems.

## Considered options

- **SQLite (Rails 8 default)** — works locally and even has decent production support now,
  but Render's free web-service tier wipes the local filesystem on every deploy, so a
  file-backed database would lose all data. Postgres on Render's managed free-tier database
  persists independently of app deploys.
- **Postgres for production, SQLite for dev/test** — would mean developing against a
  different engine than production runs on, risking dialect-specific surprises (e.g.
  `numericality`/decimal handling, index types) showing up only after deploy.
- **Postgres everywhere** (chosen) — one engine, one mental model, dev/test faithfully mirror
  production. The cost is a one-time local Postgres install, which the brief already implies
  given Rails 8's production-readiness expectations.
