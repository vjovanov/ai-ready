# AGENTS.md

Entry point for AI coding agents. `CLAUDE.md` is a symlink to this
file. When in doubt about what "good" looks like here, run the
`ai-ready` skill against this repo and fix whatever it flags.

## Start here

- [docs/SPECIFICATION.md](docs/SPECIFICATION.md) — purpose, scope, structure, and how the pieces relate.
- [skills/ai-ready/SKILL.md](skills/ai-ready/SKILL.md) — the rubric this repo is graded by.
- [skills/ai-ready/references/](skills/ai-ready/references/) — scoring rubric rationale and per-ecosystem filenames.

## For developers

- [docs/AI_DEVELOPER_ONBOARDING.md](docs/AI_DEVELOPER_ONBOARDING.md) — how to get real results from AI agents.
- [docs/EXERCISES.md](docs/EXERCISES.md) — nine hands-on drills, easiest first.
- [docs/QUIZ.md](docs/QUIZ.md) — 30-question self-assessment.
- [docs/LOCAL_TOOLING.md](docs/LOCAL_TOOLING.md) — required local tools and install commands.

## Reference

- [skills/ai-ready/references/AI_READINESS_GUIDE.md](skills/ai-ready/references/AI_READINESS_GUIDE.md) — rationale for each rubric item.
- [skills/ai-ready/references/AGENT_REFERENCES.md](skills/ai-ready/references/AGENT_REFERENCES.md) — filenames and configs per ecosystem.

## Conventions

- Markdown is the primary language; keep lines wrapped at a natural clause boundary (~80 cols).
- Every rubric item in `SKILL.md` must resolve to an anchor in
  [AI_READINESS_GUIDE.md](skills/ai-ready/references/AI_READINESS_GUIDE.md).
- Progressive disclosure: top-level files stay short and link out; detail lives in `docs/` or `references/`.
- No inline rubric detail in this file or `SKILL.md` — if it grows, move it into a reference.
- Conventional Commits for commit messages.

## Workflow for agents

1. Read this file, then [docs/SPECIFICATION.md](docs/SPECIFICATION.md).
2. For any change that touches the rubric, verify that
   [SKILL.md](skills/ai-ready/SKILL.md) and
   [AI_READINESS_GUIDE.md](skills/ai-ready/references/AI_READINESS_GUIDE.md)
   still agree on categories, numbering, and anchors.
3. Before finishing, run `just check` and confirm internal links resolve.

## Contributing and history

- [CONTRIBUTING.md](CONTRIBUTING.md) — how to propose changes.
- [CHANGELOG.md](CHANGELOG.md) — notable changes, per Keep a Changelog.
- [docs/adr/](docs/adr/) — Architecture Decision Records.

## Running checks locally

```bash
just doctor   # verify local tools before running repo checks
just check    # lint, format-check, links, anchors — same as CI
just fmt      # apply prettier to markdown
just install-hooks   # wire up pre-commit after installing it
just self-score   # invoke the ai-ready skill from your agent on this repo
```

See [justfile](justfile) for all targets.

## Out of scope

No application code, runtime, or test suite — this repo is
documentation, skill definitions, and the minimum config required to
lint, link-check, and CI itself. If runtime code is ever added,
update [docs/SPECIFICATION.md](docs/SPECIFICATION.md) and this file
in the same change.
