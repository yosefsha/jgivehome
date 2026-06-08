---
status: accepted
---

# Donation amount tiers are a `DonationOption` model, not hardcoded view constants

Each campaign on the reference site offers a fixed set of preset donation amounts, each with
its own label/message (e.g. ₪180 "נטיעת עץ", ₪360 "נטיעת 2 עצים" marked as the most-chosen
option) plus a free-form "other amount" field. We modeled this as a `DonationOption`
(`belongs_to :campaign`, `amount`, `label`, `featured`) rather than hardcoding the tiers in
the view or campaign model.

## Considered options

- **Hardcode amount/label pairs in the view or as a campaign-model constant** — faster to
  write for a single campaign, but the brief seeds *two* campaigns with different tiers, and
  hardcoding would mean amounts/labels can't vary per campaign or be edited without a code
  deploy.
- **`DonationOption` model** (chosen) — each campaign owns its own ordered set of options,
  `featured` drives the "most chosen" badge declaratively, and seeding/editing tiers is just
  data, matching how the reference site clearly manages this (per-amount custom messaging,
  presumably admin-editable).

## Consequences

The donation form (`_amount_options` partial) renders whatever `campaign.donation_options`
returns, ordered by amount — adding, removing, or relabeling a tier for a campaign requires
no code change, only a data change (seed or future admin UI).
