---
status: accepted
---

# `Campaign#raised_amount` counts `pending` *and* `paid` donations, not just `paid`

`Donation#status` is an enum (`pending` / `paid` / `cancelled`) anticipating a future payment
integration, but this demo has no payment gateway wired up — nothing ever flips a donation
from `pending` to `paid`. `Campaign#raised_amount` (and therefore the progress bar, raised
amount, and donor count) sums donations in *either* `pending` or `paid` status.

The alternative — counting only `paid` — is the "obviously correct" accounting choice and is
what a reader would assume. We deliberately deviated from it: with no payment integration, a
donation submitted through the form would stay `pending` forever, the progress bar would
never move, and the brief's core "submitting a donation visibly updates the campaign's
progress" requirement would be unobservable. Counting `pending` is what makes that requirement
demonstrable end to end without a payment gateway behind it.

## Consequences

This is explicitly a demo-environment trade-off, not a real-world accounting model — a real
deployment with Stripe (or similar) wired up would need to revisit this once `pending` →
`paid` transitions actually happen on a webhook, at which point counting only `paid` becomes
correct (and counting `pending` would double-count or show optimistic totals). The code
comment on `Campaign#raised_amount` and the README's payment write-up should make this
explicit so nobody mistakes it for the intended production behavior.
