# ADR-0004 — Split the skill pipeline: assess, then open tickets

- **Status:** Accepted
- **Date:** 2026-04-14
- **Deciders:** Repo maintainer

## Context

The rubric produces a report with a "Follow-up tickets" section. We
had to decide whether issue creation belonged inside the `ai-ready`
skill or in a separate skill that consumes the report.

## Options

1. **Single skill that assesses and opens tickets.** Fewer moving
   parts; one invocation. Cons: mixes read-only analysis with
   side-effecting writes to external systems; makes dry-runs and
   review harder; tightly couples the rubric to `gh`.
2. **Two skills with a stable report format as the contract.**
   `ai-ready` emits a report; `ai-ready-tickets` parses it and writes
   to GitHub. Users can review the report before anything is filed.
   The report stays portable — other automations can consume the
   same format.
3. **One skill with a flag.** Same as option 1 with `--create-issues`.
   Hides the coupling under a flag but keeps it.

## Decision

Option 2. [skills/ai-ready](../../skills/ai-ready/SKILL.md) stays
read-only; [skills/ai-ready-tickets](../../skills/ai-ready-tickets/SKILL.md)
is the side-effecting step. The "Follow-up tickets" section in the
report is the contract between them.

## Consequences

- Users can run the assessment without side effects — useful for CI
  self-scoring and for reports that should never create tickets.
- The report format is load-bearing. Changes to the "Follow-up
  tickets" section require updating both skills in the same PR.
- Adding more consumers (a Slack summary, a dashboard feed) follows
  the same pattern without re-running the assessment.
