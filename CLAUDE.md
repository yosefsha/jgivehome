# jgivehome

A Rails 8 (Hotwire/Turbo/Stimulus + Postgres + Tailwind) demo donation-campaign
site, modeled on jgive.com and deployed to Render's free tier. Summary of the
work so far (see `docs/TASKS.md` for the full checklist and `docs/adr/` for
the reasoning behind notable decisions):

- Scaffolded the app, data model (`Campaign`/`DonationOption`/`Donation`), and
  seed data, then deployed it to Render with a single shared Postgres database
  (including the solid_cache/queue/cable infrastructure tables).
- Built the campaign show page: header/stats, donation modal flow, live
  progress updates over Turbo Streams, a tabbed info section, and a
  click-to-play video lightbox for the campaign cover banner.
- Fixed and documented bugs as they came up (see `docs/BUGFIXES.md`), e.g. a
  donation-submission 500 caused by shared `schema_migrations` masking missing
  solid_* table schemas, and a missing campaign video caused by a seed
  backfill gap.

# Working in this repo

- Keep the local Rails/puma dev server running once it's started — don't `pkill`/stop it
  after using it to verify a change in the browser. It stays up across sessions; killing it
  is unwanted churn.
