---
status: accepted
---

# `frequency` and `display_preference` are Rails enums, not free-text or lookup tables

A donation has a small, fixed set of possible frequencies (one-time / monthly) and donor
display preferences (full name / first name only / anonymous). We modeled both as
ActiveRecord `enum`s on `Donation` backed by integer columns, rather than free-text strings
or separate lookup-table associations.

## Considered options

- **Free-text string columns** — no validation that the value is one of the allowed options,
  every comparison is a string match (typo-prone: `"montly"` vs `"monthly"`), and the set of
  allowed values lives only in view code/seed data, not the schema.
- **Lookup-table associations** (e.g. a `Frequency` model) — appropriate when the set of
  options is data the business changes at runtime, but these are fixed, code-meaningful
  states (`Donation#display_name` branches on `display_preference`, broadcasts and views key
  off `frequency`) — a join and an extra table would be pure overhead.
- **Rails `enum`** (chosen) — integer storage (compact, indexable), generated predicate
  methods (`donation.monthly?`, `donation.anonymous?`) make the model code read naturally,
  and the valid set is declared once, in the model, enforced at the database/ORM boundary.
