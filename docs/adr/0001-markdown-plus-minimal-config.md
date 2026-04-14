# ADR-0001 — Markdown plus minimal config, no application code

- **Status:** Accepted
- **Date:** 2026-04-14
- **Deciders:** Repo maintainer

## Context

The repo's purpose is a rubric and a skill that grades repos. The
rubric itself demands concrete artifacts (task runner, lint, CI) to
score well on categories 5, 6, and 7. The original spec forbade
"executable code of any kind" and "automated CI enforcement", which
made it impossible for the repo to pass its own rubric.

## Options

1. **Pure markdown, no CI.** Preserves the original "toolchain-free"
   purity. Cost: the repo permanently fails its own rubric on
   categories 5.7, 6.x, 7.4 — undermining the "dogfood" claim.
2. **Markdown plus minimal config.** Allow declarative config files
   (justfile, markdownlint, prettier, CI yaml) but no runtime or
   application code. The skill stays portable; the repo passes its
   own rubric.
3. **Full executable reference implementation.** Add scripts that
   automate parts of the rubric. Cost: scope creep, language lock-in,
   maintenance burden.

## Decision

Option 2. The repo now ships the thinnest possible configuration
(justfile, linter configs, one CI workflow) to pass its own rubric
without introducing application code.

## Consequences

- Agents running inside the repo can rely on `just check` as a single
  entry point, matching rubric signal 5.7.
- CI enforces lint, link-check, and anchor consistency on every PR.
- Any new config addition must justify itself against a specific
  rubric signal in the PR description ([CONTRIBUTING.md](../../CONTRIBUTING.md)).
- The "out of scope" list in [SPECIFICATION.md](../SPECIFICATION.md)
  still excludes runtime and application code — that line is load-bearing.
