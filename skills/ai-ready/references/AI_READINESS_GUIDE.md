# AI Readiness Guide

Why each category in the AI-readiness assessment matters, what the signals
mean in practice, and how they affect an AI coding agent's ability to work
effectively in your repository.

Each numbered subsection below matches the checklist number in
`ai/skills/ai-ready/SKILL.md`, so the assessment prompt can link directly to
the rationale for each signal.

Claude and Codex are the two primary IDE examples in this guide. Additional
filenames, directories, and ecosystem examples are collected in [the
references section](AGENT_REFERENCES.md).

---

## 1. Project context for AI agents

AI agents start every session cold. Project-context files are how the repo
transfers team conventions, constraints, and navigation hints into that new
session quickly, before the agent starts opening random files.

### 1.1 Agent instruction files

Instruction files encode repo-specific rules about style, tools, testing,
boundaries, and workflow. This is necessary because otherwise the agent has
to reverse-engineer your norms from existing code, which is slower and much
less reliable. Per-directory instruction files are especially valuable
because they tell the agent how rules change across subsystems without
forcing everything into one giant doc. Concrete file examples live in [the
references section](AGENT_REFERENCES.md#11-agent-instruction-files).

### 1.2 Entry-point instruction file links to specification

The main instruction file should act as the front door for an agent and
clearly point to the repository specification, architecture overview, or
other system-design docs. This is necessary because that entry-point file is
often the first high-signal document an agent reads. If it tells the agent
how to behave but not where to find the system-level truth, the agent still
has to hunt for the spec on its own. A clear link turns the instruction file
from a rules sheet into a navigation hub. Concrete file examples live in
[the references section](AGENT_REFERENCES.md#12-entry-point-instruction-file-links-to-the-spec).

### 1.3 AI ignore files

AI ignore files tell AI tooling which paths are noisy, sensitive, generated,
or not worth indexing. This is necessary because agents and AI-enabled
editors will otherwise spend context and attention on build outputs, vendor
trees, binary assets, or secrets that do not help solve the task. Good
ignore boundaries improve both focus and safety. Concrete filename examples
live in [the references section](AGENT_REFERENCES.md#13-ai-ignore-files).

### 1.4 Contribution conventions

A useful contribution guide gives machine-parseable rules for how work should
be done: commit format, test expectations, review standards, branch naming,
or release steps. This is necessary because agents follow explicit rules far
better than implied ones. Vague guidance produces vague output; concrete
conventions produce repeatable behavior. Concrete file examples live in [the
references section](AGENT_REFERENCES.md#14-contribution-conventions).

### 1.5 Build and run docs

The main onboarding doc is usually the first thing an agent checks to
understand how to build, run, and verify the project. This is necessary
because the fastest way for an agent to become productive is to find
copy-pasteable commands for setup and verification. If that doc is
incomplete or outdated, the agent starts its work with guesswork. Concrete
file examples live in [the references section](AGENT_REFERENCES.md#15-build-and-run-docs).

### Why it matters

This category is about onboarding speed, navigation, and behavioral fit.
Strong context docs make the agent act more like a teammate who knows the
repo and less like a generic code generator.

---

## 2. Specification and architecture

Architecture documentation gives an agent the system map it cannot infer
quickly from source code alone. Without that map, the agent can still edit
files, but it has to guess where responsibilities start and stop.

### 2.1 Architecture docs exist

Dedicated architecture docs tell the agent how the system is supposed to fit
together before it starts reading implementation details. This is necessary
because source code shows how one piece works, but not always how multiple
pieces are meant to collaborate. Without architecture docs, the agent burns
time exploring the repo file by file and can easily mistake a local pattern
for a system-wide rule. Concrete file examples live in [the references
section](AGENT_REFERENCES.md#21-architecture-docs-exist).

### 2.2 Progressive disclosure

A strong doc set starts with the big picture, then links to component-level
detail. This is necessary because an agent needs to decide what matters
before it decides what to read deeply. If every document is equally detailed
or equally flat, the agent cannot prioritize, and its context window gets
spent on low-value implementation detail instead of the parts that control
the current task.

The same rule applies to entry-point instruction files like `AGENTS.md` and
`CLAUDE.md`. These files are loaded into context on every session, so they
must stay concise: a short orientation plus links to deeper docs (architecture,
conventions, runbooks). A long, detail-heavy `AGENTS.md` burns context on
every turn and crowds out the material the current task actually needs.

### 2.3 Diagrams present

System, sequence, and data-flow diagrams communicate structure far faster
than prose. This is necessary because many AI mistakes come from getting the
shape of the system wrong: which service calls which, where state lives, or
which component owns an interaction. A diagram makes those relationships
explicit, which reduces wrong assumptions before code is changed. Concrete
format examples live in [the references section](AGENT_REFERENCES.md#23-diagrams-present).

### 2.4 Docs are cross-linked and indexed

A top-level index or table of contents helps the agent navigate directly to
relevant material instead of searching blindly. This is necessary because
agents do not have persistent memory of your documentation layout; they need
clear paths between overview docs, component docs, and operational docs every
session. When docs are not cross-linked, useful information often exists but
is effectively invisible.

### 2.5 Design decisions recorded

Recorded design decisions explain why the team chose one path over another.
This is necessary because an agent that only sees the code may "improve"
away an intentional tradeoff, such as eventual consistency, backward
compatibility, or a performance workaround. Decision records protect those
hidden constraints by making the rationale legible. Concrete examples live
in [the references section](AGENT_REFERENCES.md#25-design-decisions-recorded).

### Why it matters

This category determines whether an agent can make system-aware changes
instead of isolated edits. Good architecture context is what lets an agent
avoid locally correct but globally wrong changes.

---

## 3. AI tool configuration

Tool configuration determines whether the agent can do more than edit files.
It defines what the agent can inspect, automate, and verify without manual
human handoffs.

### 3.1 MCP servers

Project-level MCP configuration exposes shared tools like docs search,
database access, or internal APIs in a standard way. This is necessary
because ad hoc, per-user tool setup leads to inconsistent agent capabilities
across the team. Shared configuration turns "it works on my machine" into
"the agent can reliably use this tool in the project." Concrete file
examples live in [the references section](AGENT_REFERENCES.md#31-mcp-servers).

### 3.2 Custom commands and skills

Reusable commands, skills, and prompt templates capture workflows the team
uses repeatedly. This is necessary because without them, the agent has to
reconstruct deployment, triage, or review procedures from scratch each time.
Encoding those workflows once reduces drift, shortens setup time, and keeps
automation closer to how the team actually works.

### 3.3 Hooks and guardrails

Hooks and sandbox settings enforce the rules around what the agent may do and
what checks must run. This is necessary because "remember to run lint" is not
the same as "lint always runs before a risky step." Guardrails reduce the
chance that a fast agent path skips the safety checks the team depends on.

### 3.4 IDE AI config

Workspace AI config in editor settings ensures the same indexing boundaries,
tooling assumptions, and AI behavior across contributors. This is necessary
because inconsistent editor-level configuration means two agents can see
different projects while operating in the same repo. Consistency matters when
you want repeatable results.

### Why it matters

This category sets the agent's practical operating surface. The more of the
real workflow that is encoded as tooling instead of tribal knowledge, the
more autonomous and predictable the agent becomes.

---

## 4. DevOps and workflow integration

Local code edits are only part of the development loop. An AI agent becomes
meaningfully useful when it can participate in the same issue, PR/MR, review,
and CI systems your team already uses.

### 4.1 Pull / merge request automation

The ability to create, update, and comment on pull requests (GitHub) or merge
requests (GitLab) lets the agent turn finished work into a reviewable artifact
without a human manually copying changes upstream. This is necessary because
otherwise every completed task stalls at the point where collaboration begins.
PR/MR automation is the bridge from local coding to team workflow.

### 4.2 Code review workflow

Reading review comments, requesting reviewers, and responding to feedback are
what let an agent stay inside the review loop. This is necessary because most
real changes are not done at first draft; they evolve through reviewer input.
If the agent cannot participate there, a human has to translate every review
comment back into local work.

### 4.3 Issue tracking workflow

Issue-system access lets an agent discover work, claim it, update status, and
record follow-up tasks. This is necessary because issue trackers are how work
is prioritized and remembered over time. Without that integration, the agent
can complete code changes but cannot manage the context around them.

### 4.4 CI/CD access

An agent needs to list workflow runs, trigger builds, and inspect logs to
verify that changes succeed outside the local environment. This is necessary
because local success is only part of the truth; CI defines the merge gate.
If the agent cannot see CI, it cannot fully validate or debug its own work.

### 4.5 Tooling availability and auth

Installed CLIs, configured tokens, and correct write permissions are the
difference between a nominal capability and a usable one. This is necessary
because a repo may document the right CLI, API, or bot account and still
leave the agent unable to do anything if authentication is missing.
Availability without access is not readiness. Concrete examples live in
[the references section](AGENT_REFERENCES.md#45-tooling-availability-and-auth).

### Why it matters

This category measures how far the agent can travel on its own through the
delivery pipeline. Missing integrations create handoff points; handoff points
slow teams down.

---

## 5. Dev environment reproducibility

Reproducibility is what makes verification believable. If the environment is
unstable, every green result becomes suspicious because nobody knows whether
the same command will behave the same way tomorrow or on another machine.

### 5.1 Dev container definition

A dev container definition describes a standard development environment that
can be recreated consistently. This is necessary because it gives the agent
and human contributors a shared baseline for tools, runtimes, and
dependencies. A good dev container lowers setup friction and reduces "works
only in my shell" failures. Concrete file examples live in [the references
section](AGENT_REFERENCES.md#51-dev-container-definition).

### 5.2 Containerized runtime

Container runtime definitions capture the runtime assumptions of the
application and its dependencies. This is necessary because an agent often
needs to understand not just source code, but the operating environment that
code expects. Container specs make those assumptions explicit and testable.
Concrete file examples live in [the references
section](AGENT_REFERENCES.md#52-containerized-runtime).

### 5.3 Nix environment

Nix environment definitions provide even stronger reproducibility by pinning
tooling and dependencies declaratively. This is necessary when small version
differences meaningfully affect behavior, such as in compilers, build tools,
or native libraries. Nix narrows the gap between "configured" and "exactly
repeatable." Concrete file examples live in [the references
section](AGENT_REFERENCES.md#53-nix-environment).

### 5.4 direnv environment loading

direnv-based environment loading automatically brings in the right
environment variables and PATH adjustments when entering the repo. This is
necessary because manual shell setup is easy to forget and hard for agents
to infer. Automatic loading removes a whole class of hidden prerequisites.
Concrete file examples live in [the references
section](AGENT_REFERENCES.md#54-direnv-environment-loading).

### 5.5 Lock files

Lock files pin dependency versions precisely. This is necessary because
without them, the agent may test against one set of transitive dependencies
while CI or a teammate gets another. Dependency drift creates false
confidence and hard-to-reproduce failures. Concrete file examples live in
[the references section](AGENT_REFERENCES.md#55-lock-files).

### 5.6 Runtime version pins

Runtime version pin files declare the language runtime expected by the repo.
This is necessary because syntax, tooling, and dependency behavior often
depend on the exact runtime version. A pinned runtime tells the agent which
language features and commands are actually valid. Concrete file examples
live in [the references section](AGENT_REFERENCES.md#56-runtime-version-pins).

### 5.7 Task runner

A task runner provides a stable menu of sanctioned commands for building,
testing, and linting. This is necessary because agents do best when
verification is one obvious command away. A task runner reduces command
guesswork and makes automation easier to keep current. Concrete file
examples live in [the references section](AGENT_REFERENCES.md#57-task-runner).

### Why it matters

This category determines whether the agent can verify its work with
confidence. Reproducible environments turn successful runs into trustworthy
signals instead of lucky outcomes.

---

## 6. Type safety and static analysis

Static analysis gives the agent rapid feedback before it spends time on full
test runs. That short feedback loop is one of the biggest multipliers for AI
coding productivity.

### 6.1 Type checking

Type checkers catch interface mismatches, missing fields, and invalid value
flow early. This is necessary because agents often synthesize code by pattern
matching, and type systems are an efficient way to detect when the inferred
pattern was wrong. Fast structural feedback helps the agent self-correct
before reviewers ever see the change. Concrete tool examples live in [the
references section](AGENT_REFERENCES.md#61-type-checking).

### 6.2 Linting

Linters enforce local quality rules and flag suspicious constructs. This is
necessary because agents are good at producing plausible code, but plausible
is not always acceptable inside a specific codebase. Linting converts style
and correctness expectations into something the agent can reliably execute
against. Concrete tool examples live in [the references
section](AGENT_REFERENCES.md#62-linting).

### 6.3 Formatting

Formatters normalize code layout automatically. This is necessary because
formatting is a poor use of both human attention and model context. When the
formatter is authoritative, the agent can focus on behavior while still
producing output that matches the repo's style exactly. Concrete tool
examples live in [the references section](AGENT_REFERENCES.md#63-formatting).

### 6.4 EditorConfig

Cross-editor consistency settings provide a lightweight baseline for
whitespace, indentation, and line endings across editors. This is necessary
because not every repo has full formatters for every file type. Shared
baseline settings close part of that gap and prevent avoidable noise in
diffs. Concrete file examples live in [the references
section](AGENT_REFERENCES.md#64-cross-editor-consistency).

### 6.5 Pre-commit hooks

Pre-commit hooks make verification automatic at commit time. This is
necessary because even a careful agent can forget a step if the workflow is
manual. Hooks provide defense in depth by catching issues near the handoff
point. Concrete file and tool examples live in [the references
section](AGENT_REFERENCES.md#65-pre-commit-hooks).

### Why it matters

This category reduces review burden. The more correctness and consistency can
be checked mechanically, the less humans have to spend time spotting routine
issues in AI-generated changes.

---

## 7. Test infrastructure

Tests are the agent's main way to turn a code change into an evidence-backed
change. They are what separate "this looks right" from "this was verified."

### 7.1 Organized test files

Tests grouped by unit, integration, or end-to-end scope tell the agent what
to run first and what to run later. This is necessary because an agent needs
to trade off speed and confidence throughout a task. Clear organization lets
it choose targeted checks instead of defaulting to either too little
verification or unnecessarily expensive full-suite runs.

### 7.2 Test runner documentation

Documented test commands tell the agent exactly how the repo expects tests to
be run. This is necessary because guessing test commands is slow and often
wrong once projects need environment variables, wrappers, or task runners.
One authoritative command shortens the path from edit to validation.

### 7.3 Mocking and isolation

Fixtures, dependency injection, and test doubles allow components to be
tested without live external dependencies. This is necessary because agents
work best with deterministic feedback. When tests require real services,
agents become more hesitant to write them and less able to trust failures.

### 7.4 CI pipeline

CI configuration describes the checks that truly gate merges. This is
necessary because the local workflow is not always the authoritative one; CI
may include extra environments, extra linters, or extra test stages. Reading
the pipeline helps the agent align its local verification with reality.

### 7.5 Coverage configuration

Coverage tooling shows which parts of the codebase are already exercised and
which are fragile or untested. This is necessary because it helps the agent
decide where new tests are most valuable. Coverage turns "please be careful"
into concrete evidence about where caution is actually needed.

### 7.6 Minimal test output

Test output should stay compact by default and expand only when needed. This
is necessary because long raw logs bury the one thing the agent or human
actually needs first: did the check pass, and if not, what failed? A minimal
summary with a simple error message makes failures easier to triage, while
progressive discovery preserves the option to inspect deeper detail only when
the summary is not enough.

### 7.7 Visual testing

If the project has visual or UI components, the agent must be able to start
the dev server, navigate to the running app, interact with it, and take
screenshots to verify changes. This is necessary because type checking and
test suites verify code correctness, not feature correctness — an agent that
cannot see the rendered UI is unable to catch layout regressions, broken
interactions, or styling issues. Concrete tooling examples live in [the
references section](AGENT_REFERENCES.md#77-visual-testing).

This signal only applies to projects with visual components (web apps, desktop
apps, mobile apps, CLI tools with TUI interfaces). For projects without a UI
layer, this signal is not applicable and should not affect the score.

### Why it matters

This category measures how well the repo supports self-verification. Strong
test infrastructure is what lets an agent close the loop on its own changes
instead of handing uncertainty back to a human.

---

## 8. Code modularity and structure

Modularity affects whether the agent can hold enough of the system in context
to make correct changes. Even a capable model becomes unreliable if the code
it needs is too large or too entangled to reason about cleanly.

### 8.1 File size

Keeping most files reasonably small makes it more realistic for an agent to
read a whole module before editing it. This is necessary because partial
visibility increases the odds of duplicated logic, missed edge cases, or
edits in the wrong section. Smaller files are not just cleaner for humans;
they fit better into the way agents actually work.

### 8.2 Separation of concerns

When business logic, UI, persistence, and integration layers are separated,
the agent can localize a change to the right boundary. This is necessary
because mixed concerns force the agent to understand too much unrelated code
at once. Clear boundaries shrink the blast radius of every modification.

### 8.3 Predictable naming

Descriptive, consistent names help the agent find the right files and extend
the existing patterns instead of creating parallel ones. This is necessary
because agents rely heavily on names when navigating unfamiliar repos. Good
naming is a routing system for both search and design intent.

### Why it matters

This category sets the practical ceiling on change complexity. Better
modularity means larger tasks remain understandable instead of collapsing
into risky, context-fragmented edits.

---

## 9. Documentation quality

Documentation quality determines how much intent survives outside the heads of
the people who wrote the code. Agents benefit when the repo explains not just
what exists, but what future changes need to preserve.

### 9.1 Non-obvious inline comments

Comments are most useful when they explain intent, constraints, or known
pitfalls that are not obvious from the code itself. This is necessary because
agents are quick to simplify code that looks redundant unless the reason for
that shape is documented. A well-placed comment can prevent a subtle
regression.

### 9.2 API docs

Generated or structured API docs explain inputs, outputs, and expected usage
without forcing the agent to reverse-engineer every interface from
implementation. This is necessary because interface understanding is one of
the highest-frequency tasks in AI-assisted coding. Good API docs reduce both
search time and contract mistakes.

### 9.3 Changelog or conventional commits

A changelog or structured commit history tells the agent how the project has
been evolving and what kinds of changes are recent or normal. This is
necessary because recency and pattern history help the agent avoid suggesting
work that conflicts with the direction the team is already taking. It turns
history into usable context.

### Why it matters

This category helps the agent preserve intent. Better documentation quality
means fewer changes that technically work but ignore the reasons the code was
written that way in the first place.
