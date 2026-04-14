# ADR-0002 — Equal weighting across all nine rubric categories

- **Status:** Accepted
- **Date:** 2026-04-14
- **Deciders:** Repo maintainer

## Context

The rubric has nine categories covering very different concerns
(project context, architecture, AI tooling, DevOps, dev environment,
type safety, tests, modularity, docs). Real-world impact is not
uniform — project context, dev environment, and tests matter more
for agent productivity than, say, changelog hygiene. We had to decide
whether to encode that into the score.

## Options

1. **Weighted scoring.** Assign higher multipliers to high-impact
   categories. Pros: score tracks perceived value. Cons: encodes a
   strong opinion into the single number users cite; the weights
   become a bikeshed every release.
2. **Equal weighting.** Every category is worth 3 of 27 points. Pros:
   simple, defensible, reproducible. Cons: over-weights low-impact
   categories relative to real-world value.
3. **Categorical tiers.** Separate "critical" vs. "recommended"
   categories. Pros: captures prioritization. Cons: produces two
   scores, harder to cite; still requires per-category judgments.

## Decision

Option 2. The rubric reports one total (0–100) computed as
`round(sum_of_category_scores / 27 × 100)`. The skill's prose flags
high-impact categories when recommending the top-3 improvements, so
prioritization happens at the advisory layer rather than in the
scalar score.

## Consequences

- The number stays comparable across repos and over time.
- Prioritization is advisory, not baked-in. Reviewers can override.
- Any future re-weighting requires superseding this ADR, not a
  silent tweak.
