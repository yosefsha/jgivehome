# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Architecture decisions

Notable architectural decisions are recorded as ADRs in `docs/adr/`:

* [ADR-001: Solid Cache/Queue/Cable tables live in the primary database, not separate database configs](docs/adr/ADR-001-solid-tables-share-primary-database.md)
* [ADR-002: Hotwire (Turbo + Stimulus) over a client-side SPA for live campaign updates](docs/adr/ADR-002-hotwire-over-spa.md)
* [ADR-003: Postgres for every environment and every Rails 8 "solid" subsystem](docs/adr/ADR-003-postgres-everywhere.md)
* [ADR-004: Donation amount tiers are a `DonationOption` model, not hardcoded view constants](docs/adr/ADR-004-db-backed-donation-options.md)
* [ADR-005: `frequency` and `display_preference` are Rails enums, not free-text or lookup tables](docs/adr/ADR-005-enum-based-frequency-and-display-preference.md)
* [ADR-006: `Campaign#raised_amount` counts `pending` *and* `paid` donations, not just `paid`](docs/adr/ADR-006-pending-and-paid-count-toward-progress.md)
* [ADR-007: Campaign cover images are static files in `public/images/`, not Active Storage](docs/adr/ADR-007-self-hosted-cover-image.md)
* [ADR-008: Render all six reference tabs, with "coming soon" placeholders for out-of-scope ones](docs/adr/ADR-008-full-tab-bar-with-placeholders.md)
