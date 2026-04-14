---
name: ai-ready
description: Score a repository's AI-readiness across 9 categories (project context, architecture, AI tooling, DevOps, dev environment, type safety, tests, modularity, docs) by running the commands an agent would. Produces a 0–100 score, a verdict, strengths/weaknesses, and a top-3 improvement list.
user-invocable: true
allowed-tools: Bash Read Grep Glob
argument-hint: path-to-repo
context: fork
agent: Explore
---

Assess the AI-readiness of a repository. If `$ARGUMENTS` is provided,
use it as the repo path; otherwise, assess the current working
directory.

For the human-side counterpart — how developers should *use* agents —
see [references/AI_DEVELOPER_ONBOARDING.md](references/AI_DEVELOPER_ONBOARDING.md).
Ecosystem-specific filenames and configs live in
[references/AGENT_REFERENCES.md](references/AGENT_REFERENCES.md).
Scoring rubric detail lives in
[references/AI_READINESS_GUIDE.md](references/AI_READINESS_GUIDE.md).

## Verify by doing, not just looking

A `justfile` that exists but fails on `just test` is worse than no
`justfile` — it gives false confidence. For each signal, **run the
command an agent would run** and score based on what actually happens.
Record the exact command and a one-line summary of the result in the
report's "What I tried" table.

## Scoring

Score each of the 9 categories from 0–3:

- **0** — nothing present
- **1** — minimal / partial
- **2** — solid coverage
- **3** — exemplary

Compute total as `round(sum_of_category_scores / 27 × 100)`. The
denominator is 9 categories × max 3 = 27, so equal weighting across
categories. Per-category notes in the report can flag that some
categories (project context, dev environment, tests) have outsized
impact on real agent workflows — consider that when prioritizing the
top-3 improvements.

Verdict by total:

- **0–25** — Not Ready
- **26–50** — Needs Improvement
- **51–75** — Ready
- **76–100** — Highly Optimized

Claude and Codex are the two primary agent examples throughout.
Additional filenames, directories, and ecosystem examples are in
[AGENT_REFERENCES.md](references/AGENT_REFERENCES.md).

---

## Categories and signals

Each signal links to its explanation in the readiness guide. For
ecosystem-specific filenames, see `AGENT_REFERENCES.md`.

### 1. Project context for AI agents
- [ ] [1.1](references/AI_READINESS_GUIDE.md#11-agent-instruction-files) Agent instruction files are present (`AGENTS.md`, `CLAUDE.md`, `SYSTEM.md`, or nested variants)
- [ ] [1.2](references/AI_READINESS_GUIDE.md#12-entry-point-instruction-file-links-to-specification) The main instruction file links to architecture or spec docs
- [ ] [1.3](references/AI_READINESS_GUIDE.md#13-ai-ignore-files) AI ignore files exclude secrets, assets, or build dirs
- [ ] [1.4](references/AI_READINESS_GUIDE.md#14-contribution-conventions) Contribution conventions are documented in a machine-parseable way
- [ ] [1.5](references/AI_READINESS_GUIDE.md#15-build-and-run-docs) Build and run docs are clear and easy to follow

### 2. Specification and architecture
- [ ] [2.1](references/AI_READINESS_GUIDE.md#21-architecture-docs-exist) Architecture docs exist
- [ ] [2.2](references/AI_READINESS_GUIDE.md#22-progressive-disclosure) Progressive disclosure: high-level overview links to detailed component docs. The same rule applies to `AGENTS.md` / `CLAUDE.md` — they must stay concise and link out to detail rather than inline it.
- [ ] [2.3](references/AI_READINESS_GUIDE.md#23-diagrams-present) Diagrams are present
- [ ] [2.4](references/AI_READINESS_GUIDE.md#24-docs-are-cross-linked-and-indexed) Docs are cross-linked and indexed
- [ ] [2.5](references/AI_READINESS_GUIDE.md#25-design-decisions-recorded) Design decisions are recorded with rationale

### 3. AI tool configuration
- [ ] [3.1](references/AI_READINESS_GUIDE.md#31-mcp-servers) MCP server configuration is present (optional — prefer shell commands and skills when they cover the same capability)
- [ ] [3.2](references/AI_READINESS_GUIDE.md#32-custom-commands-and-skills) Custom commands, skills, or tool definitions
- [ ] [3.3](references/AI_READINESS_GUIDE.md#33-hooks-and-guardrails) Hooks, sandbox settings, or approval policies
- [ ] [3.4](references/AI_READINESS_GUIDE.md#34-ide-ai-config) Repo-checked workspace AI settings for standardized IDEs (TODO Agnts)

### 4. DevOps and workflow integration
- [ ] [4.1](references/AI_READINESS_GUIDE.md#41-pull--merge-request-automation) PRs/MRs: can the agent create, update, and comment on pull/merge requests?
- [ ] [4.2](references/AI_READINESS_GUIDE.md#42-code-review-workflow) Code review: can the agent request reviewers, read review comments, and post responses?
- [ ] [4.3](references/AI_READINESS_GUIDE.md#43-issue-tracking-workflow) Issues: can the agent create, read, update, assign, and close issues?
- [ ] [4.4](references/AI_READINESS_GUIDE.md#44-cicd-access) CI/CD: can the agent list pipeline runs, trigger builds, and read CI logs?
- [ ] [4.5](references/AI_READINESS_GUIDE.md#45-tooling-availability-and-auth) Required tooling and access paths are available

### 5. Dev environment reproducibility
- [ ] [5.1](references/AI_READINESS_GUIDE.md#51-dev-container-definition) Dev container definition
- [ ] [5.2](references/AI_READINESS_GUIDE.md#52-containerized-runtime) Containerized runtime definition
- [ ] [5.3](references/AI_READINESS_GUIDE.md#53-nix-environment) Nix environment definition
- [ ] [5.4](references/AI_READINESS_GUIDE.md#54-direnv-environment-loading) direnv-based environment loading
- [ ] [5.5](references/AI_READINESS_GUIDE.md#55-lock-files) Dependency lock files
- [ ] [5.6](references/AI_READINESS_GUIDE.md#56-runtime-version-pins) Runtime versions pinned
- [ ] [5.7](references/AI_READINESS_GUIDE.md#57-task-runner) Task runner

### 6. Type safety and static analysis
- [ ] [6.1](references/AI_READINESS_GUIDE.md#61-type-checking) Type checking is configured
- [ ] [6.2](references/AI_READINESS_GUIDE.md#62-linting) Linting is configured
- [ ] [6.3](references/AI_READINESS_GUIDE.md#63-formatting) Formatting is configured
- [ ] [6.4](references/AI_READINESS_GUIDE.md#64-editorconfig) Cross-editor consistency settings
- [ ] [6.5](references/AI_READINESS_GUIDE.md#65-pre-commit-hooks) Pre-commit hooks

### 7. Test infrastructure
- [ ] [7.1](references/AI_READINESS_GUIDE.md#71-organized-test-files) Test files exist and are organized
- [ ] [7.2](references/AI_READINESS_GUIDE.md#72-test-runner-documentation) Test runner configured and documented
- [ ] [7.3](references/AI_READINESS_GUIDE.md#73-mocking-and-isolation) Mocking / isolation for external dependencies
- [ ] [7.4](references/AI_READINESS_GUIDE.md#74-ci-pipeline) CI pipeline configured
- [ ] [7.5](references/AI_READINESS_GUIDE.md#75-coverage-configuration) Code coverage configuration
- [ ] [7.6](references/AI_READINESS_GUIDE.md#76-minimal-test-output) Test output is minimal and progressive
- [ ] [7.7](references/AI_READINESS_GUIDE.md#77-visual-testing) Visual testing for UI components

### 8. Code modularity and structure
- [ ] [8.1](references/AI_READINESS_GUIDE.md#81-file-size) File size: most files under 300–500 lines
- [ ] [8.2](references/AI_READINESS_GUIDE.md#82-separation-of-concerns) Separation of concerns: business logic separated from UI and data
- [ ] [8.3](references/AI_READINESS_GUIDE.md#83-predictable-naming) Predictable naming across variables, functions, files

### 9. Documentation quality
- [ ] [9.1](references/AI_READINESS_GUIDE.md#91-non-obvious-inline-comments) Inline comments where logic is non-obvious
- [ ] [9.2](references/AI_READINESS_GUIDE.md#92-api-docs) API docs or generated docs
- [ ] [9.3](references/AI_READINESS_GUIDE.md#93-changelog-or-conventional-commits) Changelog or conventional commits

---

## Output format

```
# AI Readiness Report: <repo-name>

**Score:** X/100
**Verdict:** [Not Ready | Needs Improvement | Ready | Highly Optimized]

## Scores

| Category | Score | Notes |
|----------|-------|-------|
| Project context | X/3 | ... |
| Spec & architecture | X/3 | ... |
| AI tool config | X/3 | ... |
| DevOps integration | X/3 | ... |
| Dev environment | X/3 | ... |
| Type safety | X/3 | ... |
| Test infra | X/3 | ... |
| Code modularity | X/3 | ... |
| Documentation | X/3 | ... |
| **Total** | **X/100** | |

## Strengths

- [2-3 areas where the repo already excels for AI interaction]

## Weaknesses

- [2-3 areas where an AI agent would struggle based on current repo state]

## Top 3 improvements

1. [highest-impact action]
2. ...
3. ...

## What I tried

| What | Command | Result |
|------|---------|--------|
| Build | `just build` | ✅ passed / ❌ failed: <one-line error> |
| Test | `just test` | ✅ passed (12s) / ❌ failed: <one-line error> |
| Lint | `just lint` | ... |
| Format check | `just format --check` | ... |
| Pre-commit hooks | `pre-commit run --all-files` | ... |
| DevOps CLI | `gh repo view` | ... |
| ... | ... | ... |

(Include every command you ran. Omit rows for tools that don't apply.)

## Follow-up tickets

- `[type:feature|task|bug] [priority:0-4] <title>` — [1 sentence describing the concrete work to open as a ticket]
- ...
```

## Reporting style

- Keep validation and test logs minimal in the main response.
- On failure, show a simple error message with the failed command or artifact.
- Progressive discovery: highest-level conclusion first, more detail only where relevant (a note, weakness, or improvement).
- Do not paste raw test output unless the user explicitly asks.
