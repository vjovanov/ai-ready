# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Conventional Commits](https://www.conventionalcommits.org/).

## Unreleased

### Added

- `CONTRIBUTING.md`, `.github/CODEOWNERS`, PR and issue templates — rubric signals 1.4.
- `.editorconfig`, `.markdownlint.yaml`, `.prettierrc`, `.prettierignore` — signals 6.3, 6.4.
- `docs/LOCAL_TOOLING.md` and `.pre-commit-config.yaml` — reproducible local setup for `just`, `rg`, `lychee`, `pre-commit`, and repo hooks.
- `justfile` with `doctor`, `check`, `lint`, `format-check`, `fmt`, `links`, `anchors`, `install-hooks`, `self-score` targets — signal 5.7.
- GitHub Actions workflow `check.yml` (markdownlint + prettier + lychee + anchor consistency) — signal 7.4.
- `.aiexclude`, `.gitignore` — signal 1.3. `.claudeignore` is a
  symlink to `.aiexclude`, mirroring the `AGENTS.md → README.md`
  pattern so every agent reads the same rules.
- `CHANGELOG.md` — signal 9.3.
- `docs/adr/` with ADR-0001 (markdown plus minimal config), ADR-0002 (equal weighting), ADR-0003 (verify by doing), ADR-0004 (split skill pipeline) — signal 2.5.
- Mermaid architecture diagram in `docs/SPECIFICATION.md` — signal 2.3.
- Cross-link from `ai-ready` SKILL.md to `ai-ready-tickets` SKILL.md.

### Changed

- `just lint`, `just format-check`, and `just links` now ignore hidden
  skill-mirror symlink directories so local and CI checks only score
  repo-owned content once.
- `just anchors` now validates GitHub-style heading slugs without the
  broken shell expression that previously stopped the recipe.
- `docs/SPECIFICATION.md` "Out of scope" now excludes only application
  code; allows minimal config for lint, link-check, and CI.
- `skills/ai-ready/SKILL.md` signal 3.4: replaced `(TODO Agnts)` with
  concrete filename examples.
- DevOps scoring guidance now treats missing current PR artifacts as
  neutral evidence; repo access and workflow availability matter more
  than whether the checked-out branch already has an open PR.

## 0.1.0 — 2026-04-14

### Added

- Initial rubric and `ai-ready` skill.
- `ai-ready-tickets` skill for turning reports into GitHub issues.
- Reference docs: `AI_READINESS_GUIDE.md`, `AGENT_REFERENCES.md`.
- Developer-facing docs: `AI_DEVELOPER_ONBOARDING.md`, `EXERCISES.md`, `QUIZ.md`.
