# Self-assessment quiz

30 questions mapped to the checklist and the AI-readiness assessment.
Answers at the end. If you miss more than five, re-read
[AI_DEVELOPER_ONBOARDING.md](AI_DEVELOPER_ONBOARDING.md) before the
exercises.

## Writing tasks for agents

**Q1.** Which task description will produce better results?

- (a) "Add rate limiting to the API."
- (b) "Add per-user rate limiting (100 req/min) to the `/api/v2/` routes
  in `src/api/routes.py`. Use the existing `redis_client` from
  `src/infra/cache.py`. Add tests in `tests/api/`. Don't change the
  public response format."

**Q2.** An agent refactors a module cleanly but breaks an integration
test in another service. What was most likely missing?

- (a) A list of every file in the repo
- (b) Explicit constraints about boundaries and what must not change
- (c) A longer description of the refactoring technique

**Q3.** The agent keeps generating `pytest.mark.asyncio` but your
project uses `trio` with a custom decorator. Best long-term fix?

- (a) Correct it each time in the conversation
- (b) Add the convention to `CLAUDE.md`/`AGENTS.md` and test-runner docs
- (c) Switch to pytest-asyncio so the agent's guess is correct

## Meta-prompting

**Q4.** Agent created a PR but forgot the `needs-review` label. You
fixed it manually. Now what?

- (a) Nothing
- (b) Ask the agent to update the PR workflow skill or `AGENTS.md` so
  it always adds the label
- (c) Add a reminder to your personal notes

**Q5.** Agent consistently writes SQL migrations without transactions.
After fixing one, what's the meta-prompting move?

- (a) Tell the agent "always use transactions" in this conversation
- (b) Fix the migration, then have the agent document the convention
  and update the migration skill
- (c) Add a pre-commit hook that rejects migration files

## Safety and approvals

**Q6.** Agent paused 15 times during a feature for edit/command
approvals. What to change?

- (a) Nothing — more approval is safer
- (b) Pre-approve routine operations; only gate destructive or
  external-facing actions
- (c) Disable all approval checks

**Q7.** When should an agent interrupt you?

- (a) Before every file write
- (b) During planning — to clarify scope or confirm approach
- (c) Never

**Q8.** Cleanest safety boundary?

- (a) Host machine with sudo
- (b) Dev container with pre-approved routine operations
- (c) Shared staging server

## Verification and feedback loops

**Q9.** Agent says "Done — all changes look correct" but there's no
test output. What's the problem?

- (a) The agent is lying
- (b) Verification wasn't fast or obvious; the agent skipped it
- (c) The agent doesn't know how to run tests

**Q10.** Test suite takes 20 minutes. Impact on AI-assisted dev?

- (a) None — the agent can wait
- (b) Agent (and you) will skip verification or run once at the end
- (c) Remove the slow tests

## Repo readiness

**Q11.** A 2,000-line file mixes business logic, routes, queries, and
utilities. Why is this bad for agents?

- (a) Agents can't read files that large
- (b) Summarization loses critical details; locally plausible but
  globally wrong changes
- (c) Large files are always bad regardless of AI

**Q12.** Architecture docs are 8 months stale. What happens?

- (a) The agent notices and ignores them
- (b) The agent treats them as truth and produces changes that fit the
  old design
- (c) Stale docs are better than no docs

**Q13.** 50 markdown files in `docs/` with no index, no cross-links,
inconsistent terminology. Effect?

- (a) Agent reads them all and figures it out
- (b) Summarization amplifies the mess
- (c) Agents don't summarize docs

## Tool and workflow knowledge

**Q14.** GitHub MCP token has read-only access. Agent tries to create
a PR and fails silently. Readiness category?

- (a) Project context (1)
- (b) AI tool config (3)
- (c) DevOps and workflow integration (4)

**Q15.** "Why both `CLAUDE.md` AND `AGENTS.md`?"

- (a) Redundant — pick one
- (b) `AGENTS.md` is the cross-agent format; `CLAUDE.md` adds
  Claude-specific instructions. Use both with mixed tooling.
- (c) `AGENTS.md` is deprecated

**Q16.** 7-step release process lives in a wiki page. Best move?

- (a) Copy into `CLAUDE.md`
- (b) Encode as a skill, command, or task-runner target
- (c) Trust the agent to find the wiki page

## Reviewing agent output

**Q17.** Agent refactored auth middleware. Tests pass, linter happy.
Still check:

- (a) Nothing
- (b) Boundary violations, hidden assumptions, preserved design
  decisions
- (c) Only syntax

**Q18.** Agent adds a feature and "cleans up" three unrelated files.
What's wrong?

- (a) Nothing
- (b) Scope creep — unsolicited changes raise review burden and
  regression risk
- (c) Should have cleaned more

## Models and agents

**Q19.** Complex 15-file refactor with subtle interdependencies. Model
tier?

- (a) Cheapest/fastest
- (b) Strongest reasoning tier you can afford
- (c) Doesn't matter

**Q20.** 200 independent lint fixes across a codebase. Approach?

- (a) One long sequential session
- (b) Parallelize — Codex tasks or multiple agent sessions
- (c) Fix manually

## Parallel work

**Q21.** Feature in progress, urgent bug arrives, you also want an
agent on a refactor. Best handling?

- (a) Stash, fix bug, pop, then start refactor
- (b) Two worktrees — bug fix and refactor — all three run in parallel
- (c) Three separate clones

**Q22.** Key advantage of worktrees over multiple clones?

- (a) Share the same git object store (instant, no redownload); all
  branches visible
- (b) Less disk; otherwise identical
- (c) No difference

## Interaction workflows

**Q23.** Add multi-tenancy: 12 tables, migrations, query changes
across codebase. Workflow?

- (a) Do
- (b) Ask, iterate, do
- (c) Plan, iterate, do

**Q24.** You're about to modify `reconcileState` — an unfamiliar
function. Start with?

- (a) Do
- (b) Explain
- (c) Plan, iterate, do

**Q25.** Update copyright headers in 300 files, lint fixes in 50
modules, type annotations in 80 functions. All independent. Workflow?

- (a) Do, sequentially
- (b) Orchestrate
- (c) Plan, iterate, do

**Q26.** Two weeks into a large migration. Multiple developers run
daily sessions that need shared context. Workflow?

- (a) Orchestrate
- (b) Agent swarm + memory
- (c) Do, with full task description each time

**Q27.** Agent's caching design has bounced three times between Redis
and in-memory. What now?

- (a) Let the agent pick
- (b) The Ask-iterate-do loop isn't converging — decide or upgrade to
  Plan-iterate-do
- (c) Start a fresh conversation

## Practical scenarios

**Q28.** Fresh repo: no `CLAUDE.md`/`AGENTS.md`, no architecture docs,
no task runner, undocumented tests. First three actions to make it
AI-ready?

**Q29.** Agent keeps making three mistakes in your repo: wrong DB
client, wrong directory for new files, skipping an env check. Write
exactly what you'd put in `AGENTS.md` to prevent all three.

**Q30.** Reviewing an agent's PR that adds a new API endpoint. List
five specific things you check beyond "compiles and tests pass."

---

## Answer key

- **Q1:** (b). Specifics beat vague instructions.
- **Q2:** (b). Boundaries have to be stated, not implied.
- **Q3:** (b). Fix the root cause in project instructions.
- **Q4:** (b). Always fix the system, not the instance.
- **Q5:** (b). Document the convention. (c) is fine as
  defense-in-depth, not instead.
- **Q6:** (b). Pre-approve routine; gate destructive.
- **Q7:** (b). Interrupt during planning, not execution.
- **Q8:** (b). Dev container with pre-configured permissions.
- **Q9:** (b). No fast verification → verification skipped.
- **Q10:** (b). Add fast subset commands (`just test-unit`).
- **Q11:** (b). Summarization loses detail.
- **Q12:** (b). Agents treat docs as ground truth.
- **Q13:** (b). Messy source → messier compressed version.
- **Q14:** (c). DevOps/workflow gap at signal 4.5.
- **Q15:** (b). `AGENTS.md` shared; `CLAUDE.md` Claude-specific.
- **Q16:** (b). Encode as a skill or task-runner target.
- **Q17:** (b). Tests verify behavior, not intent.
- **Q18:** (b). Unsolicited changes exceed scope.
- **Q19:** (b). Strongest reasoning tier — rework costs more than
  model cost.
- **Q20:** (b). Independent tasks parallelize well.
- **Q21:** (b). Worktrees keep all three tasks parallel.
- **Q22:** (a). Shared object store + visible branches.
- **Q23:** (c). High complexity + high blast radius → plan first.
- **Q24:** (b). Understand before modifying.
- **Q25:** (b). Textbook orchestration.
- **Q26:** (b). Persistent shared context for multi-week, multi-session
  work.
- **Q27:** (b). Upgrade to a structured plan.
- **Q28:** Open. Strong: add `AGENTS.md` with build/test/structure; add
  a task runner with `lint`/`test`/`format`; write a one-paragraph
  architecture summary.
- **Q29:** Open. Strong answer is specific and file-anchored, e.g.:
  "Use `db.async_client` from `src/infra/db.py`, not `psycopg2`. New
  files go in `src/modules/<domain>/`. All service functions must call
  `check_env()` from `src/infra/config.py` before reading config."
- **Q30:** Open. Strong items: auth/authz middleware respected, input
  validation consistent with existing endpoints, URL/naming
  conventions, rate-limit/logging/observability parity, migration
  rollback, edge cases (empty/duplicate/large), new dependencies
  justified.
