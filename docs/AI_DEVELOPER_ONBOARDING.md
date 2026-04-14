# AI-Ready Developer Onboarding

A checklist for developers who want to get real results from AI coding
agents — not just set up tools. Organized by impact; start at the top.

**Companion docs:**

- [QUIZ.md](QUIZ.md) — 30-question self-assessment.
- [EXERCISES.md](EXERCISES.md) — 9 hands-on drills, easiest first.
- [AGENT_REFERENCES.md](../skills/ai-ready/references/AGENT_REFERENCES.md) — concrete filenames,
  configs, tools per agent ecosystem.
- [AI_READINESS_GUIDE.md](../skills/ai-ready/references/AI_READINESS_GUIDE.md) — scoring rubric used
  by `SKILL.md`.

## TL;DR — the short version

- **Parallel work is the point.** Hardware, monitors, and worktrees
  exist to let you run multiple agents and review in parallel.
- **Task description is the skill that multiplies everything else.**
  Clear goal, verification path, pointers, constraints.
- **Fix the rules, not just the output.** Every correction should
  update the instructions so the same mistake can't recur.
- **Make verification one command.** If `just test`/`just lint` don't
  exist, the agent (and you) will skip them.
- **Safety by default, not by interruption.** Pre-approve routine work
  in a sandbox; interrupt during planning only.
- **Agents sound confident when they're wrong.** Incomplete context
  becomes confident fabrication. Give them the context explicitly.
- **Agents degrade with noise.** Stale docs, giant files, and
  unstructured notes summarize badly.

## Hardware — set up for parallel work

AI-assisted development is parallel by nature: multiple agents, builds,
and tests running while you review. Under-specced hardware turns every
workflow below into a waiting game.

### Minimum hardware

| Component | Target | Why |
| --- | --- | --- |
| Disk | 2 TB NVMe | Multiple worktrees, container images, build artifacts, model caches. Running out of disk mid-build is a top disruptor. |
| RAM | 32 GB (64 preferred) | Agents, containers, builds, tests, IDE all compete. 16 GB swaps the moment two things run. |
| CPU | 16+ cores | Parallel builds and agents don't wait politely. Three agents × one build each = serialized on low core counts. |
| Cooling | No throttling | Sustained load throttles laptops. Use a cooling pad/dock; desktops need airflow. |

**The fan test:** open three agents, kick off a build, and do real
work. If your fans max out for more than 30 seconds or the machine
feels sluggish, you're under-specced. Absolute numbers age; this test
doesn't.

### Monitors

At least two screens, at least one wide enough for two shells/IDE
windows side by side (32"+ or ultrawide works). Every active stream of
work should be visible without window-switching — three parallel
agents you can only see one at a time erodes the whole point of
parallelism.

## 1. Highest leverage — daily habits

### 1.1 Write good task descriptions

**TL;DR:** Clear goal, verification path, pointers, constraints — or
expect vague output.

The single highest-leverage skill. A good task has:

- **Goal:** what should be different when it's done?
- **Verification:** how do we know it worked?
- **Pointers:** which files or modules matter?
- **Constraints:** what must not change?

Quality of output tracks quality of input almost linearly. If you
catch yourself writing "maybe" or "I think," you need the Ask-iterate
workflow (item 2.3), not a better description.

### 1.2 Fix the rules, not just the output

**TL;DR:** Every correction updates the instructions, so the same
mistake can't recur for any agent or developer.

When the agent makes a mistake, patch the system that allowed it —
`AGENTS.md`, a spec file, a skill, a task-runner target, or the tool
itself. Fixing only the output is like fixing a typo in a print run
without correcting the manuscript.

In practice:

- Wrong test command → fix the test, update `AGENTS.md`/`CLAUDE.md`.
- Boundary violation → fix the code, encode the boundary in a spec.
- Skipped step → fix the result, encode the step in a skill or
  task-runner target.

Do this for yourself too: periodically review what went wrong and
right, then update docs, rules, and tooling. The repo should be smarter
after every session.

### 1.3 Make verification fast

**TL;DR:** One-command lint/test/format or it gets skipped.

```shell
just lint
just test
just format
```

If verification is slow or manual, the agent will guess — and so will
you. Add fast subsets (`just test-unit`) for the inner loop; save
heavyweight suites for CI and pre-push.

### 1.4 Set up a safe execution environment

**TL;DR:** Dev container + pre-approved routine ops. Agent interrupts
for planning, not execution.

Dev containers give agents a clean, isolated environment with no host
risk. If containers aren't practical, use OS-level sandboxing and
explicit approval rules.

Approvals should almost never interrupt execution. Pre-approve routine
work (reads, edits, builds, tests, lints) so the agent can run
autonomously. The only time the agent should pause is during planning
— to clarify scope or validate an approach before committing.

### 1.5 Work on multiple tasks in parallel with git worktrees

**TL;DR:** One branch per worktree, one agent per worktree, zero
stashing. You're a dispatcher now.

A worktree is a separate working directory linked to the same repo.
Each has its own branch, index, and file state; they share git history.
No stashing, no context-switch cost, no waiting.

```shell
# Create a worktree for a new feature
git worktree add ../myrepo-feature-x feature-x

# Create one on a new branch from main
git worktree add -b fix-auth ../myrepo-fix-auth main

# List and clean up
git worktree list
git worktree remove ../myrepo-feature-x
```

Why it matters:

- **Multiple agents can work simultaneously** without stepping on each
  other's changes.
- **Review while the agent works** — open one worktree for review in
  one editor while the agent works in another.
- **Agents can create worktrees themselves.** Claude Code's
  `isolation: "worktree"` makes a temporary sandbox per task without
  touching your main checkout.

Rules of thumb: name directories clearly (`../myrepo-<task>`); don't
edit the same branch from two worktrees; audit periodically with
`git worktree list`.

## 2. Interaction workflows — pick the right one

Six workflows, lightest to heaviest. Picking the right one avoids
under-steering (too little guidance on a hard problem) and
over-steering (planning a trivial change).

**First — sometimes the right workflow is no agent at all.**

### 2.0 When not to use an agent

Your IDE's refactoring tools and a shell one-liner are often faster
than any agent. Mechanical transformations with no judgment calls —
use mechanical tools.

- **IDE refactorings:** rename symbol, extract method/variable, inline,
  move class with imports, change method signature, generate
  getters/setters/`equals`/`hashCode`. All atomic, AST-aware, faster
  than any agent.
- **Shell one-liners:** project-wide find-and-replace (`sed`, IDE
  search), format/lint the whole project (`just format`), counting or
  listing (`grep -r 'TODO' | wc -l`).

Agents shine when judgment is needed: intent, design choices,
cross-file reasoning, synthesis.

### 2.1 Explain

**TL;DR:** No code changes. Ask focused questions and build your
mental model before you touch anything.

**Use when:** You don't understand the code you're about to modify.

Ask focused questions. "Explain this file" produces a generic summary.
"Explain why `processQueue` retries three times and what happens when
the retry budget is exhausted" produces insight.

### 2.2 Do

**TL;DR:** Complete task description in, execution out. Review when
done.

**Use when:** The task is clear and well-scoped and you trust execution
without back-and-forth.

Most common workflow. Quality of output is almost entirely determined
by the task description (item 1.1). If you catch yourself correcting
the agent mid-task, you needed Ask-iterate (2.3) or Plan-iterate (2.4).

### 2.3 Ask, iterate, do

**TL;DR:** Converse until the approach is clear, then execute.

**Use when:** General idea but need to nail down details or explore
options.

Discuss trade-offs, pick an approach, then execute. The conversation
*is* the planning. Know when to stop iterating — three rounds without
progress means you need 2.4.

### 2.4 Plan, iterate, do

**TL;DR:** Agent produces a structured plan; you review, iterate on
the plan, then execute the agreed version.

**Use when:** Multi-file refactors, migrations, or anything where a
wrong first step is expensive.

Plans are cheap to change, code is expensive to change — invest
review energy here. Check for missing steps, wrong assumptions,
ordering problems. Many agents have a plan mode (e.g., Claude Code's
`/plan`).

### 2.5 Orchestrate

**TL;DR:** Decompose into independent units, one agent per unit, you
coordinate and merge.

**Use when:** Throughput is the bottleneck; multiple tasks can run in
parallel.

The hard part is decomposition, not running agents in parallel. Two
agents modifying the same file aren't independent — sequence them or
merge carefully.

### 2.6 Agent swarm + memory

**TL;DR:** Multi-session, multi-agent work sharing persistent context.
Curate the memory like production code.

**Use when:** Sustained, multi-week efforts where continuity across
sessions matters.

Each agent reads shared context at start, writes back what future
agents need. You prune stale entries, resolve conflicts, keep signal
high. Stale or noisy memory degrades every future session.

### Choosing the right workflow

| Complexity | Uncertainty | Workflow |
| --- | --- | --- |
| Low | Low | **Do** (2.2) |
| Low | High | **Ask-iterate** (2.3) |
| Any | — | **Explain** (2.1) first |
| High | Low | **Orchestrate** (2.5) |
| High | High | **Plan-iterate** (2.4) |
| Sustained/team | Any | **Swarm + memory** (2.6) |

## 3. Repo readiness — make the codebase agent-friendly

These shape how every agent session works because they determine what
the agent can understand.

### 3.1 Know your repo before tuning the agent

**TL;DR:** Read the context files and architecture docs yourself.
You can't improve what you don't understand.

### 3.2 Keep files focused and well-named

**TL;DR:** Agents search, read, and summarize; large or mixed-concern
files summarize badly.

Avoid: large files mixing concerns, scattered/duplicate docs, vague
names, constraints buried in unrelated files.

### 3.3 Write docs that survive summarization

**TL;DR:** Clear headings, consistent terms, short sentences,
cross-links. Messy source produces a messier summary.

### 3.4 Make implicit knowledge explicit

**TL;DR:** If "oh, you have to run X before Y" lives only in someone's
head, the agent won't know it.

Agents interact through shell commands, built-in tools, and structured
interfaces. Whatever isn't written down in one of those three channels
is invisible to them.

## 4. Review and continuous improvement

### 4.1 Review agent output for the right things

**TL;DR:** Tests verify behavior, not intent. Check boundaries,
assumptions, and scope.

Most common agent failure modes:

- **Boundary violations** — changes cross module/service boundaries.
- **Hidden assumptions** — the agent assumed something false.
- **Skipped validation** — tests pass but edge cases weren't considered.
- **Stale context** — worked from outdated info.
- **Wrong tool usage** — shell hack instead of the right API.
- **Scope creep** — unsolicited "cleanup" in unrelated files.

### 4.2 Encode repeated workflows as skills

**TL;DR:** Done it more than twice? Turn it into a skill, command, or
task-runner target.

Release processes, PR templates, migration patterns. Don't rely on the
agent to infer the right steps every time.

### 4.3 Set up and understand MCP servers

**TL;DR:** For every MCP: know capabilities, auth, and failure modes.

Silent MCP failures look like model mistakes from the outside.

### 4.4 Track what you find

**TL;DR:** File issues for gaps as you hit them; don't keep them in
your head.

## 5. Background knowledge

### 5.1 Know the major agents

**TL;DR:** Each has different interaction models, strengths, and
constraints.

- **Claude Code** — Anthropic's CLI + IDE. Strong at multi-step
  reasoning, large refactors, agentic workflows. Skills, MCP, hooks,
  memory. Terminal, VS Code, JetBrains, web.
- **Codex** — OpenAI's coding agent. Cloud-sandboxed per task (naturally
  safe; can't reach local services). Good for parallelizing independent
  tasks. Reads `AGENTS.md`.
- **Pi** — Interactive pair-programming style; approachable,
  conversational. Good for exploring new codebases.
- **OpenCode** — Open-source terminal agent, multi-backend (Claude,
  GPT, Gemini, local). Good when self-hosting or custom providers
  matter.

### 5.2 Know the major model tiers (not names)

**TL;DR:** Tiers age slowly; specific model names age in months. Pick
by tier, not marketing.

- **Frontier reasoning tier** — slowest, most expensive, fewest
  mistakes on hard problems. Use for complex multi-file refactors,
  architecture, migration planning.
- **Everyday workhorse tier** — balanced speed, cost, capability.
  Default for routine coding.
- **Fast/cheap tier** — simple edits, quick lookups, high-volume bulk
  tasks.
- **Reasoning-specialized tier** — "thinks" before answering. Best for
  problems with a clear correct answer (algorithms, math).
- **Open-weight tier** — self-hosted, private, offline. Trades
  capability for control; lags frontier on hard tasks.

Rules of thumb:

- Use the strongest tier you can afford for planning and complex
  refactors; cheaper for routine edits.
- Context-window size matters — if you need to read 20 files at once,
  pick a tier that can.
- For open-ended coding, standard workhorse often beats reasoning-
  specialized (less thinking-overhead).

For specific current models, check vendor docs — the tier names above
will still apply after the names change.

### 5.3 Read the AI-ready skill end to end

**TL;DR:** `SKILL.md`, `AI_READINESS_GUIDE.md`, and `AGENT_REFERENCES.md`
together explain the rubric and why each category matters.

## Common pitfalls

| Pitfall                              | What goes wrong                                |
| ------------------------------------ | ---------------------------------------------- |
| "The agent will figure it out"       | It won't. Hidden rules stay hidden.            |
| Tools installed but never explained  | The agent doesn't know when to use them.       |
| MCPs without clear auth/permissions  | Silent failure; looks like a model mistake.    |
| Skills that nobody maintains         | Workflows drift; skills produce wrong results. |
| Docs present but flat/stale          | Summarization amplifies the mess.              |
| "Be safe" without a safety model     | The agent can't follow rules it doesn't have.  |

## Next steps

- Take the quiz: [QUIZ.md](QUIZ.md). If you miss more than five, re-read
  the relevant sections before the exercises.
- Start the drills: [EXERCISES.md](EXERCISES.md). Exercise 1 has no
  prerequisites.
- Assess a real repo: run the `ai-ready` skill against a project you
  own.

---

## Appendix: minimum viable AI-ready repo

Five things that take a repo from 0 to ~50 on the scorecard. Start
here if you're bootstrapping.

### 1. `AGENTS.md` — minimal template

```markdown
# Agent instructions

## Build and test
- Install:    `just install` (or direct equivalent)
- Build:      `just build`
- Test:       `just test`
- Lint:       `just lint`
- Format:     `just format`

## Project structure
- `src/`       — application code; see `docs/architecture.md`
- `tests/`     — unit and integration tests
- `scripts/`   — developer and CI scripts

## Conventions
- New modules go in `src/<domain>/`, never in `src/utils/`.
- All shell scripts use `#!/usr/bin/env bash` and `set -euo pipefail`.
- Commits follow Conventional Commits; tests required with any
  behavior change.

## Boundaries
- Do not modify files under `vendor/` or `generated/`.
- Do not touch migrations once merged; write a new migration instead.

## Links
- Architecture: `docs/architecture.md`
- ADRs: `docs/adr/`
- Contributing: `CONTRIBUTING.md`
```

Symlink for IDE-specific entry points: `ln -s AGENTS.md CLAUDE.md`.

### 2. `justfile` — minimal template

```make
default:
    @just --list

install:
    # language-specific: pip install -r requirements.txt / npm ci / ...

build:
    # language-specific build

test:
    # fast default suite
test-all:
    # full suite including slow tests

lint:
    # language-specific linter(s)

format:
    # formatter(s) — idempotent

ci: lint test
    @echo "CI checks passed"
```

### 3. `.devcontainer/devcontainer.json` — minimal template

```json
{
  "name": "project-dev",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {},
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "postCreateCommand": "just install",
  "customizations": {
    "vscode": {
      "extensions": []
    }
  }
}
```

### 4. Architecture summary — one-page template

```markdown
# Architecture

One paragraph: what this system does and for whom.

## Components
- **API** (`src/api/`) — HTTP surface, auth, routing.
- **Core** (`src/core/`) — business logic; no I/O.
- **Adapters** (`src/adapters/`) — DB, queue, external APIs.

## Data flow
HTTP → API → Core → Adapters → external systems.

## Key decisions
- See `docs/adr/` for rationale behind current choices.

## Invariants
- Core has no external dependencies; always testable in isolation.
- Adapters never import from API.
```

### 5. CI minimum — single workflow

```yaml
# .github/workflows/ci.yml
name: ci
on: [push, pull_request]
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: just install
      - run: just lint
      - run: just test
```

Five files, one hour, dramatically more agent-friendly repo. Run the
`ai-ready` skill before and after to see the score change.
