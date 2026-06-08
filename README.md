# jgivehome

A small Rails 8 app that reproduces the donor-facing part of a Jgive campaign
donation page — browsing a campaign (story, cover image/video, goal, progress)
and submitting a donation — modeled on
[this live campaign](https://www.jgive.com/new/he/ils/donation-targets/159183).
Payment/checkout, accounts, and admin are explicitly out of scope; submitting
the donation form creates a `pending` donation and updates the campaign's
progress live via Turbo Streams.

**Live app**: https://jgivehome.onrender.com

## Running locally

Requirements: Ruby 3.3.11, PostgreSQL, and a `config/master.key` (ask for it,
or generate your own with `bin/rails credentials:edit` if you don't need the
existing seeded secrets).

```bash
bundle install
bin/rails db:setup    # creates the DB, loads the schema, runs db/seeds.rb
bin/dev               # runs the Rails server + Tailwind build/watch (see Procfile.dev)
```

The app seeds two campaigns — הגן הכתום (with real donation tiers and a
banner video) and ספריית השכונה — plus a handful of donations, so the page
isn't empty on first load.

Run the test suite with `bundle exec rspec` (model, request, and system specs;
system specs use headless Chrome via Capybara).

## Deploying

The app deploys to [Render](https://render.com) as a Docker web service plus a
single managed Postgres database, configured via `render.yaml` (Render reads
this blueprint to provision both). Notes:

- `RAILS_MASTER_KEY` is set as a secret env var on the service; `DATABASE_URL`
  is wired automatically from the managed database.
- Render's free tier provides only one Postgres instance, so Solid
  Cache/Queue/Cable share the primary database rather than using separate
  database configs (see ADR-001).
- `bin/docker-entrypoint` runs `db:prepare` and `db:seed` on every boot —
  both are idempotent, which matters because the free tier has no shell access
  to run one-off migration/seed commands.
- Pushing to the connected branch triggers a new build and deploy automatically.

## Wiring in real payments

Submitting the donation form creates a `Donation` in `pending` status and
nothing moves it to `paid` — there's no payment integration in this demo. To
add one (e.g. Stripe):

1. On `DonationsController#create`, after persisting the `pending` `Donation`,
   create a Stripe Checkout Session (or PaymentIntent) for its amount and
   redirect the donor there instead of closing the modal; store the returned
   session/intent id on the `Donation`.
2. Add a webhook endpoint that listens for `checkout.session.completed` /
   `payment_intent.succeeded`, looks up the `Donation` by the stored id, and
   transitions it `pending` → `paid` (and a `payment_failed` event would move
   it to `cancelled`).
3. Make the transition idempotent — webhooks can be retried/duplicated, so the
   handler should no-op if the `Donation` is already `paid`, and the lookup
   should be on a unique external id rather than re-deriving state from the
   payload.
4. `Campaign#raised_amount` already counts `pending` and `paid` together (see
   ADR-006); once real payments exist, that's worth revisiting — it was a
   deliberate stand-in for the "no payment integration" gap, not a permanent
   design choice.

## Key decisions (ADRs)

Notable architectural decisions, with the trade-offs behind them, are recorded
in `docs/adr/`:

* [ADR-001: Solid Cache/Queue/Cable tables live in the primary database, not separate database configs](docs/adr/ADR-001-solid-tables-share-primary-database.md)
* [ADR-002: Hotwire (Turbo + Stimulus) over a client-side SPA for live campaign updates](docs/adr/ADR-002-hotwire-over-spa.md)
* [ADR-003: Postgres for every environment and every Rails 8 "solid" subsystem](docs/adr/ADR-003-postgres-everywhere.md)
* [ADR-004: Donation amount tiers are a `DonationOption` model, not hardcoded view constants](docs/adr/ADR-004-db-backed-donation-options.md)
* [ADR-005: `frequency` and `display_preference` are Rails enums, not free-text or lookup tables](docs/adr/ADR-005-enum-based-frequency-and-display-preference.md)
* [ADR-006: `Campaign#raised_amount` counts `pending` *and* `paid` donations, not just `paid`](docs/adr/ADR-006-pending-and-paid-count-toward-progress.md)
* [ADR-007: Campaign cover images are static files in `public/images/`, not Active Storage](docs/adr/ADR-007-self-hosted-cover-image.md)
* [ADR-008: Render all six reference tabs, with "coming soon" placeholders for out-of-scope ones](docs/adr/ADR-008-full-tab-bar-with-placeholders.md)

## What I'd do with more time

- Populate the placeholder tabs (Ambassador board, Groups, About the charity,
  Updates) with real content/components instead of "coming soon" panels.
- A multi-step donation wizard closer to the reference site's flow, rather
  than a single modal form.
- Active Storage for campaign cover images instead of static files in
  `public/images/` (see ADR-007) — would matter once campaigns are
  user-managed rather than seeded.
- Donor accounts, so a donor's `display_preference` and details could be
  remembered rather than re-entered per donation.

## Tools, process, and AI

I used Claude Code throughout — for scaffolding, implementation, debugging
(e.g. the production 500 documented in `docs/BUGFIXES.md`), and writing specs.
I worked from a planning session captured in `CONTEXT.md` and a commit-sized
checklist in `docs/TASKS.md`, comparing against the reference site as I went
and recording notable decisions as ADRs. AI was most useful for scaffolding
boilerplate (migrations, specs, Stimulus controllers) and for working through
the Solid Cache/Queue/Cable bug quickly; I steered it most on RTL/Hebrew
styling details and on which scope to cut versus keep, where the reference
site's actual behavior had to be the tie-breaker rather than a guess.

The full chat transcript of this project is in [`transcript/`](transcript/index.html).
