# Development Tasks

Concrete, commit-sized tasks derived from `docs/assignment.md` and the planning session captured in `CONTEXT.md`. Each checked-off item is sized to be its own commit — see "Commit cadence" at the bottom.

Strategy: get a minimal app deployed to Render *first* (hello-world + basic test + live URL), so the deploy pipeline is proven early and every later feature just needs `git push` to go live.

## 0. Environment setup
- [x] Install rbenv + ruby-build via Homebrew; install current-stable Ruby (3.3.x); set as the local Ruby version for this project (system Ruby is 2.6, too old for Rails 8)
- [x] Install Rails 8 (`gem install rails`)
- [x] Confirm local Postgres 14 (already installed via Homebrew) is running; create a dev role if needed

## 1. Hello world scaffold + basic test + first deploy
- [x] `rails new . --database=postgresql --css=tailwind` (Rails 8 ships Hotwire/Turbo/Stimulus by default)
- [x] Configure `config/database.yml` for local Postgres; run `rails db:create`
- [x] Add a trivial `HomeController#index` route + view ("hello world") so there's something to see and deploy
- [x] Add RSpec + FactoryBot (`rspec-rails`, `factory_bot_rails`); run `rails generate rspec:install`
- [x] Write one basic request spec (e.g. `GET / returns 200 and renders the hello text`) with orientation comments explaining how `bundle exec rspec` discovers and runs specs, the role of `rails_helper`/`spec_helper`, and the `describe`/`it`/`expect` structure — a one-time learning aid, not boilerplate to repeat per file
- [x] Commit: scaffold boots locally, test passes (`bundle exec rspec` green)
- [x] Set up Render: web service + managed Postgres, `RAILS_MASTER_KEY` as secret env var, confirm build step runs `assets:precompile`/Tailwind build (`render.yaml` blueprint added; consolidated solid_cache/queue/cable onto a single Postgres database for the free-tier single-DB setup)
- [ ] Deploy hello-world to Render; confirm the live URL serves the page — this proves the whole pipeline before any real feature work lands
- [ ] Commit: deployment config (`render.yaml` or notes on dashboard config)

## 2. Data model
- [ ] `Campaign`: title, story (text), cover_image_url, goal_amount (decimal), slug — migration + model
- [ ] `DonationOption`: belongs_to :campaign; amount (decimal), label (string), featured (boolean, default false) — migration + model + association
- [ ] `Donation`: belongs_to :campaign; amount (decimal), frequency (enum: one_time/monthly), status (enum: pending/paid/cancelled, default: pending), donor_name, donor_email, display_preference (enum: full_name/first_name/anonymous), dedication_message (text, optional) — migration + model + association
- [ ] Validations: presence on required fields, numericality on amounts (> 0), email format on donor_email
- [ ] `Campaign#raised_amount` / `#progress_percentage`: sum pending + paid donations against the goal. Add a short code comment explaining *why* pending counts (no payment integration exists in this demo, so excluding pending would mean progress never visibly moves — documented further in the README)
- [ ] **Tests**: FactoryBot factories for Campaign, DonationOption, Donation; model specs covering validations, enum behavior, and `raised_amount`/`progress_percentage` (including that pending counts toward progress)
- [ ] Commit + push (deploy auto-updates; run `rails db:migrate` against production)

## 3. Seed data
- [ ] Download a copy of הגן הכתום's cover image into `public/images/`
- [ ] `db/seeds.rb`: seed הגן הכתום with its real title, Hebrew story, cover image path, goal ₪5,000,000, and its 5 real donation options (₪180 "נטיעת עץ" … ₪5,000 "בוני הגן הכתום", ₪360 marked `featured`)
- [ ] Seed a second, simpler fictional campaign with its own donation options
- [ ] Seed 8–12 Donation records spread across both campaigns, varying frequency/status/display_preference/dedication so the page and "Recent donations" tab show realistic variety
- [ ] **Tests**: a seed smoke-test (e.g. a spec or rake task assertion that `db:seed` runs cleanly and produces the expected campaign/donation counts) — optional but cheap insurance against a broken demo on first load
- [ ] Commit + push; run `rails db:seed` against production

## 4. Campaign show page — header
- [ ] Routes + `CampaignsController#show` (by slug or id)
- [ ] Header: cover image, title, tagline, raised amount, goal amount, donor count, progress bar — Tailwind-styled, `dir="rtl"` on Hebrew content
- [ ] "Donate" button that opens the donation modal (wiring lands in section 6)
- [ ] **Tests**: request/system spec asserting the show page renders the campaign's title, raised amount, goal, and progress bar correctly for seeded data
- [ ] Commit + push

## 5. Tabs
- [ ] Stimulus `tabs_controller` for switching between the 6 reference tabs: About the project, Recent donations, Ambassador board, Groups, About the charity, Updates
- [ ] Populate "About the project" with the campaign's story
- [ ] Placeholder panels for Ambassador board / Groups / About the charity / Updates ("coming soon," visually consistent with the rest — these are explicitly out of the brief's required scope)
- [ ] "Recent donations" tab content is built in section 7 (needs Donation data first)
- [ ] **Tests**: system spec asserting that clicking each tab reveals the corresponding panel and the "About the project" tab shows the campaign's story
- [ ] Commit + push

## 6. Donation form (modal)
- [ ] `DonationsController#new` / `#create`, rendered as a Turbo Frame modal opened/closed via a Stimulus `modal_controller`
- [ ] Build the form from separable partials for future extensibility: `_amount_options` (preset tiles + "other amount" custom field), `_frequency_toggle` (one-time/recurring → `frequency` enum), `_donor_fields` (name + email), `_display_preference` (full name / first name only / anonymous), `_dedication_message` (optional textarea behind a "want to add a note?" checkbox reveal)
- [ ] Visually flag the `featured` donation option (e.g. "🧡 most chosen" badge), matching the reference
- [ ] Validation: required fields, amount > 0, valid email format — server-side with inline error display
- [ ] **Tests**: system spec opening the modal, selecting/entering an amount, filling donor details, and asserting validation errors show for missing/invalid input
- [ ] Commit + push

## 7. Donation creation & live progress update
- [ ] `DonationsController#create`: build the Donation in `pending` status, associate to its Campaign, persist
- [ ] On success: close the modal, show a brief "thank you — your donation is pending" message, and broadcast a Turbo Stream updating the raised-amount, progress bar, and donor count in place (no full reload) — this is the part that makes the brief's "submitting updates the campaign's progress" requirement directly observable
- [ ] "Recent donations" list: donor name resolved per `display_preference` (e.g. "Yosef S." for first-name-only, "Anonymous" for anonymous), amount, dedication message when present, recurring badge — appended live via Turbo Stream when a new donation lands
- [ ] **Tests**: request/system spec — submitting the donation form creates a `pending` Donation, the campaign's raised amount/progress visibly increases, and the new donation appears in the "Recent donations" list with the name rendered per its `display_preference`
- [ ] Commit + push

## 8. Styling pass
- [ ] RTL check across the page (`dir="rtl"`, Tailwind logical utilities `ms-`/`me-`/`ps-`/`pe-`/`rtl:`)
- [ ] Compare against the reference page; adjust spacing/color/type to "clearly resemble" without chasing pixel-perfection — note anything you deliberately changed and why (per the brief's invitation to improve things that strike you as off)
- [ ] Responsive check at mobile width for header, tabs, and modal
- [ ] **Tests**: none new — this is a visual pass; rerun the existing system specs to confirm styling changes haven't broken any selectors/assertions
- [ ] Commit + push

## 9. README
- [ ] How to run locally: Ruby/Rails/Postgres versions, `bundle install`, `rails db:setup`, `bin/rails server`
- [ ] Key decisions & trade-offs and *why*: Hotwire over SPA, Postgres everywhere, DB-backed donation options with per-amount messaging, enum-based frequency/display-preference, pending+paid counting toward progress, self-hosted cover image, full tab bar with placeholders
- [ ] What you'd do with more time: populate placeholder tabs, multi-step donation wizard, Active Storage for images, donor accounts
- [ ] Payment write-up: how you'd wire in Stripe — Checkout/PaymentIntent flow, webhook-driven `pending` → `paid` transition, idempotency
- [ ] A few sentences on tools, process, and where AI helped or got in the way (link the transcript)
- [ ] Commit + push

## 10. Final deployment check
- [ ] Confirm `rails db:migrate db:seed` has run against production and the live site shows real data
- [ ] Smoke-test the live URL end to end (browse campaign, switch tabs, submit a donation, watch progress update)
- [ ] Capture the live link and confirm it's in the README/deliverables

## Commit cadence
Per the brief's ask for "real commit history rather than a single squashed commit": commit after each item above lands, with a descriptive message (e.g. "Add Campaign and Donation models," "Build donation form modal with Stimulus," "Seed הגן הכתום campaign data").
