---
status: accepted
---

# Render all six reference tabs, with "coming soon" placeholders for out-of-scope ones

The reference campaign page has six tabs (About the project, Recent donations, Ambassador
board, Groups, About the charity, Updates). The brief only requires "About the project" and
"Recent donations" to have real content. We built the full six-tab bar via a Stimulus
`tabs_controller`, with the other four rendering a visually-consistent "coming soon" panel
instead of real content.

## Considered options

- **Only build the two required tabs** — less work, but the page would visually diverge from
  the reference (a four-tab bar vs. a six-tab bar) in a way that's immediately obvious to
  anyone comparing them side by side, undermining the "resemble the reference" goal.
- **Full tab bar with placeholders** (chosen) — matches the reference's visual structure and
  navigation exactly; the placeholders make the *scope boundary* explicit and intentional
  ("coming soon," not a bug or missing feature) rather than silently absent.

## Consequences

`TASKS.md` already lists "populate placeholder tabs" under "what you'd do with more time" —
the placeholder panels are a deliberate, named seam for that future work, not a TODO left by
accident.
