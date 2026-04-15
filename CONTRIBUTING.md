# Contributing

Both humans and AI coding agents contribute to this repo. The rules are
the same for both. If anything below conflicts with
[AGENTS.md](AGENTS.md) or [docs/SPECIFICATION.md](docs/SPECIFICATION.md),
the spec wins — update this file in the same change.

## Ground rules

- **Markdown plus minimal config only.** No application code. If you
  need a new config file, justify it in the PR description against a
  specific rubric signal.
- **Dogfood the rubric.** Every change must keep the repo green against
  its own [SKILL.md](skills/ai-ready/SKILL.md). If you lower a score,
  say so in the PR and open a follow-up issue.
- **Progressive disclosure.** Keep [README.md](README.md),
  [AGENTS.md](AGENTS.md), and [SKILL.md](skills/ai-ready/SKILL.md)
  short. Detail belongs in `docs/` or `references/`.

## Commit messages

Conventional Commits. The type set in use:

- `feat:` — new rubric item, skill, or doc section
- `fix:` — correct an error or broken link
- `docs:` — prose-only change to existing docs
- `chore:` — tooling, config, CI, housekeeping
- `refactor:` — reshape docs without changing meaning
- `test:` — lint, link-check, or anchor-consistency changes

Subject in imperative mood, under ~70 chars. Body optional; explain
_why_, not _what_.

## Pull request checklist

Before requesting review:

- [ ] `just doctor` passes (or you used the equivalent setup from
      [docs/LOCAL_TOOLING.md](docs/LOCAL_TOOLING.md)).
- [ ] `just check` is green locally (or you explain why it isn't).
- [ ] If you touched [SKILL.md](skills/ai-ready/SKILL.md), every new
      rubric item resolves to an anchor in
      [AI_READINESS_GUIDE.md](skills/ai-ready/references/AI_READINESS_GUIDE.md).
- [ ] If you added a filename to the rubric, it is also in
      [AGENT_REFERENCES.md](skills/ai-ready/references/AGENT_REFERENCES.md).
- [ ] Internal links resolve (`just links`).
- [ ] [CHANGELOG.md](CHANGELOG.md) updated under `## Unreleased`.

## Agent-specific guidance

Agents should read [AGENTS.md](AGENTS.md) first, then
[docs/SPECIFICATION.md](docs/SPECIFICATION.md). Follow the workflow in
AGENTS.md's "Workflow for agents" section. Do not invent new rubric
categories without an ADR under [docs/adr/](docs/adr/).

## Review and ownership

See [.github/CODEOWNERS](.github/CODEOWNERS). All PRs require one
owner review. Security-sensitive changes (adding new tooling, CI
secrets, anything that runs in CI) require two.
