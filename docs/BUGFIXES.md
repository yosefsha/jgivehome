# Bug Fixes

Bugs and visual/behavioral discrepancies found while comparing the live app against the reference site, grouped by severity. Each checked-off item is sized to be its own commit, same cadence as `TASKS.md`.

## Critical
- [x] Submitting a donation on production raises a 500 and Turbo can't recover gracefully
  ```
  POST https://jgivehome.onrender.com/campaigns/orange-garden/donations 500 (Internal Server Error)
  Uncaught (in promise) Nt: The response (500) did not contain the expected
  <turbo-frame id="donation_modal"> and will be ignored. To perform a full page
  visit instead, set turbo-visit-control to reload.
  ```
  **Root cause** (reproduced locally against a fresh Postgres DB primed exactly the way the
  production entrypoint does — `RAILS_ENV=production ... bin/rails db:prepare`): the donation
  *saves* fine; the 500 comes from the post-save Turbo Stream broadcast
  (`DonationsController#broadcast_campaign_updates`) raising
  `ArgumentError: No unique index found for id` from `solid_cable`'s `insert_all`, because the
  `solid_cable_messages` table doesn't exist.

  `database.yml` pointed `cache`/`queue`/`cable` at the *same* `DATABASE_URL` as `primary`
  (Render's free tier only provides one Postgres instance), each with its own
  `migrations_paths`. But since they share one physical database, they also share one
  `schema_migrations` table — once the primary's migrations run, Rails sees a non-zero
  migration version for the cache/queue/cable configs too and concludes their schemas are
  already loaded, so `db:prepare` silently never creates `solid_cache_entries`,
  `solid_queue_*`, or `solid_cable_messages`.

  **Fix**: stop declaring solid_cache/solid_queue/solid_cable as separate database configs.
  Generated their table definitions as ordinary migrations into `db/migrate`
  (`20260608130000_create_solid_cache_tables.rb` and friends) so their tables live in the
  primary database and are created by the normal migration run; removed the now-unused
  `connects_to`/`database:`/`migrations_paths` entries from `database.yml`,
  `config/cable.yml`, `config/cache.yml`, and `config/environments/production.rb`, and
  deleted the orphaned `db/{cache,queue,cable}_schema.rb` files. Verified end-to-end against
  a from-scratch production-config database: `db:prepare` now creates all `solid_*` tables,
  and `campaign.broadcast_replace_to`/`donation.broadcast_prepend_to` (the exact calls made
  on donation creation) succeed.

## High
*(none yet)*

## Medium
*(none yet)*

## Low
- [x] Campaign show page doesn't resemble the reference design
  Compared https://www.jgive.com/new/he/ils/donation-targets/159183 against https://jgivehome.onrender.com/campaigns/orange-garden — the page is split into a nav bar and a main section; main contains (1) a campaign banner with a link to a YouTube video (https://www.youtube.com/watch?v=4Z_xXXR3ddU&t=1s) in the middle, and (2) a donation menu.

  **Addressed**: added a fixed nav bar (`layouts/application.html.erb`) and grouped the donate button into a bordered "donation menu" card with a tax-credit note, closer to the reference's bit/donate/tax-info grouping.

  Banner video — superseded the initial iframe-embed approach with a reusable `campaigns/_media_banner` component: a wide background image with a centered "watch the video" link/button (play icon + label) that opens the campaign's YouTube video in a new tab. Simpler, avoids iframe-loading/CSP overhead, and reads more like "a link to a video" than an autoplay-prone embedded player. `Campaign#video_url` is stored on the model and seeded for הגן הכתום with the linked video; the component takes `image_url`/`image_alt`/`video_url` so it can be reused for any campaign banner.
- [x] Donation form text inputs/textarea had invisible borders
  `donor_name`, `donor_email`, `custom_amount`, `dedication_message` were missing the `border` width utility — `border-gray-300` alone sets a color with no visible border, so fields looked borderless/floating. Added `border` alongside the color class in all four partials.
