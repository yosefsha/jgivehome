# jgivehome

A small Rails app that reproduces the donor-facing part of a Jgive campaign donation page (browsing a campaign and submitting a donation), stopping short of actual payment processing.

## Language

**Campaign**:
A fundraising project page with a title, story, cover image, goal amount, and running total raised. Corresponds to what Jgive calls a "donation target."
_Avoid_: Donation target, project, fund

**Donation**:
A single donor's pledge toward a Campaign — amount, frequency, donor identity, display preference, and an optional dedication message. Created in a `pending` state on submission (no payment integration exists to move it to `paid`).
_Avoid_: Pledge, contribution, gift

**Donation option**:
A preset donation amount offered on a Campaign's form, paired with impact-framing copy describing what that amount accomplishes (e.g. "₪180 — plants a tree"), and an optional "featured" flag highlighting one option as most-chosen. Belongs to a Campaign — different campaigns offer different options.
_Avoid_: Preset, suggested amount, tier

**Donor display preference**:
The donor's choice of how their identity appears publicly alongside their donation: full name, first name only, or anonymous. Stored per-Donation (no donor accounts exist to hold this as a standing preference).
_Avoid_: Privacy setting, visibility

**Dedication message**:
An optional note a donor attaches to their Donation (e.g. "in memory of...").
_Avoid_: Note, comment, tribute

**Progress**:
The relationship between a Campaign's raised amount and its goal amount, shown as a bar/percentage. In this project, "raised" sums `pending` and `paid` donations together — a deliberate simplification documented in the README, since no donation can ever reach `paid` without a payment integration this app doesn't implement.
_Avoid_: Raised amount (on its own — "progress" is the relationship between raised and goal, not just the raised figure)

**Reference site**:
The live Jgive campaign page (jgive.com's donation-target #159183) this app's Campaign page is modeled on — the comparison point for "does it clearly resemble the original."
_Avoid_: jgive, original, source

**Tab**:
One of the six sections a Campaign's details are organized into: About the project, Recent donations, Ambassador board, Groups, About the charity, Updates. Some are placeholders pending content explicitly out of this project's scope.
_Avoid_: Panel, section (on its own), page

**Banner video**:
An optional YouTube video linked from a Campaign's cover-image banner, opened in a lightbox rather than played inline.
_Avoid_: Media, embed, player

**ADR (Architecture Decision Record)**:
A short document in `docs/adr/` recording a notable, hard-to-reverse technical decision and the trade-off behind it (e.g. why pending donations count toward Progress).
_Avoid_: Design doc, spec, RFC

**Render**:
The hosting platform this app deploys to — a single Docker web service plus a managed Postgres database, configured via `render.yaml`.
_Avoid_: Production, host, server
