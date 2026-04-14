# ADR-0003 — Verify rubric signals by running commands, not file presence

- **Status:** Accepted
- **Date:** 2026-04-14
- **Deciders:** Repo maintainer

## Context

Earlier drafts of the rubric scored on file existence: a `justfile`
was worth points whether or not `just test` succeeded, a `pre-commit`
config counted even if the hooks were broken. Teams noticed that
agents confidently reported "all tooling present" against repos
where nothing actually worked. False confidence is worse than
absence.

## Options

1. **Existence-based scoring.** Fast, deterministic, and wrong.
2. **Execution-based scoring.** For each signal, the agent runs the
   command a new contributor would run and scores based on the
   result. Slower, requires a sandbox, occasionally flaky — but
   honest.
3. **Hybrid.** Score existence by default; only execute for a subset
   of high-value signals. Concession to speed; reintroduces the
   "false confidence" failure mode for the rest.

## Decision

Option 2. [SKILL.md](../../skills/ai-ready/SKILL.md) opens with
"Verify by doing, not just looking", and reports include a "What I
tried" table so every claim is traceable to a command.

## Consequences

- Agents need shell access inside the repo under assessment.
- Assessments are slower than pure file scans but catch far more real
  breakage.
- The skill's output is reproducible by humans — they can re-run the
  commands in the table.
- Signals that can't be executed (docs quality, architecture clarity)
  still rely on inspection; the rubric acknowledges this.
