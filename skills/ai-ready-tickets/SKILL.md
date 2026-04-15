---
name: ai-ready-tickets
description: "Turn an AI-readiness report into GitHub issues — one epic summarizing the score and verdict, plus one sub-ticket per follow-up item. Idempotent: re-running updates the epic rather than creating duplicates."
user-invocable: true
allowed-tools: Bash Read Grep Glob
argument-hint: "[report-path] [--repo owner/repo] [--dry-run]"
context: fork
---

Create a tracking epic on GitHub plus one issue per follow-up item
from an AI-readiness report. If `$ARGUMENTS` includes a path, read
that report; otherwise look for the most recent report under the
current repo (see "Locating the report"). Pairs with the
[ai-ready](../ai-ready/SKILL.md) skill, whose output format this skill
parses.

## Arguments

- `report-path` (optional) — path to a Markdown report produced by the
  `ai-ready` skill. If omitted, search the current directory for the
  most recent `*ai-ready*.md` / `*readiness*.md` file. If none found,
  ask the user whether to run `ai-ready` first.
- `--repo owner/repo` (optional) — target repo. Defaults to the repo
  inferred from `gh repo view --json nameWithOwner -q .nameWithOwner`
  in the current working directory.
- `--dry-run` (optional) — print the planned epic body and sub-ticket
  table without calling `gh`.

## Prerequisites

Run these checks first and stop with an actionable error if any fail:

1. `gh auth status` — authenticated.
2. `gh repo view --json nameWithOwner` — resolves target repo (unless
   `--repo` was passed).
3. Report file exists and contains a `## Follow-up tickets` heading.
4. The authenticated user can create issue dependencies in the target
   repo. Use `gh api repos/<owner>/<repo>` or another lightweight read
   check to confirm the repo is reachable before attempting writes.

## Parsing the report

Extract these sections from the report:

- **Title** — first `# ...` line (usually `AI Readiness Report: <repo>`).
- **Score** and **Verdict** — from `**Score:**` / `**Verdict:**` lines.
- **Scores table** — the `## Scores` Markdown table (keep verbatim).
- **Strengths**, **Weaknesses**, **Top 3 improvements** — bullet lists
  under those headings.
- **Follow-up tickets** — bullet list under `## Follow-up tickets`.
  Each line follows:

  ```text
  - `[type:<feature|task|bug>] [priority:<0-4>] <title>` — <description>
  ```

  Parse `type`, `priority`, `title`, `description` per line. Skip
  malformed lines and warn once at the end.

## Idempotency

Before creating anything, compute the epic title as:

```text
AI Readiness: <owner/repo>
```

Then search for an existing epic:

```bash
gh issue list --repo <owner/repo> --search 'in:title "AI Readiness: <owner/repo>"' --state all --json number,title,url,state
```

- If more than one candidate matches, prefer the one whose body
  contains the exact marker line "_Tracked by the ai-ready-tickets
  skill._" and stop with an actionable error if the match is still
  ambiguous.
- If an open epic exists → update it in place (edit body, add any
  missing sub-tickets, and refresh dependencies without recreating
  existing ones).
- If a closed epic exists → ask the user whether to reopen or create a
  new one. Do not silently reopen.
- If none exists → create a new epic.

For sub-tickets, match by exact title among issues that already point
back to the epic via `**Parent epic:** #<epic-num>` in the body or
already block the epic via issue dependencies. Never create a second
ticket with the same title for the same epic.

## Dependencies

Do not create or rely on labels for epic tracking. Use GitHub issue
dependencies as the source of truth for the epic/sub-ticket
relationship.

Use the epic as the blocked issue and each follow-up ticket as a
blocking issue. In other words, the epic should be "blocked by" every
open follow-up ticket.

Use these REST calls through `gh api`:

```bash
gh api repos/<owner>/<repo>/issues/<epic-num>/dependencies/blocked_by
gh api --method POST \
  repos/<owner>/<repo>/issues/<epic-num>/dependencies/blocked_by \
  -f issue_id=<sub-ticket-id>
```

- Fetch the existing `blocked_by` list before the loop and keep it
  updated as tickets are created or matched.
- Only add a dependency when the sub-ticket's numeric `id` is not
  already present in the epic's dependency list.
- Keep `type` and `priority` as metadata in the issue body and epic
  checklist, not as labels.

## Epic body

Use this template. Fill the task list after sub-tickets are created
(or during a dry-run, with placeholder numbers).

```markdown
# AI Readiness Epic

**Score:** X/100 · **Verdict:** <verdict>
**Report:** <path or link to report, if in repo>
**Generated:** <ISO date>
**Relationship model:** GitHub issue dependencies (`blocked by`)

## Scores

<verbatim scores table from report>

## Strengths

<bullets>

## Weaknesses

<bullets>

## Top 3 improvements

1. ...
2. ...
3. ...

## Follow-up tickets

- [ ] #<num> <title> — `type:<t>` `priority:<p>`
- ...

---

_Tracked by the `ai-ready-tickets` skill._
_Re-run the skill to refresh this epic; it will not create duplicate
sub-tickets and will restore missing dependencies._
```

## Sub-ticket body

```markdown
<description from report>

---

**Type:** <feature|task|bug>
**Priority:** <0-4>
**Parent epic:** #<epic-num>
**Source:** AI Readiness Report (<date>)
**Category:** <if inferable from the report context, else omit>
```

## Execution

1. Resolve report path and target repo. Compute the epic title
   `AI Readiness: <owner/repo>`. Print:
   `Repo: <owner/repo> · Report: <path> · Epic: <title> · <N> follow-up items`.
2. Find or create the epic (empty task list for now). Capture its
   `number` and numeric `id`.
3. Read the epic's current `blocked_by` dependency list and task list.
4. For each follow-up item, in report order:
   - Compute canonical title: strip surrounding backticks/brackets;
     keep the human title text only.
   - If a sub-ticket with that title already exists in the repo and is
     already linked to this epic, reuse it and record its `number` and
     `id`.
   - Otherwise create it with:

     ```bash
     gh issue create --title "<title>" --body "<body>"
     ```

     Record the returned `number`, then fetch the issue's numeric `id`
     with `gh issue view`.
   - Ensure the epic depends on the sub-ticket with `gh api --method
     POST .../dependencies/blocked_by -f issue_id=<sub-ticket-id>`.
     Skip the POST if that dependency already exists.
5. Edit the epic body so the task list references every sub-ticket in
   report order with `- [ ] #<num> <title> — type:<t> priority:<p>`.
6. Print a summary table:

   ```text
   | # | Title | Type | Priority | URL |
   ```

   Include the epic as the first row.

If `--dry-run` is set, stop after step 1 and print the planned epic
body and the summary table with `(dry-run)` in place of URLs.

## Locating the report

If no path was passed, search in this order and pick the most recent
modification time:

1. `./*ai-ready*.md`, `./*readiness*.md` in CWD.
2. `./reports/*ai-ready*.md`, `./reports/*readiness*.md`.
3. `./docs/*ai-ready*.md`, `./docs/*readiness*.md`.

If none found, print one line telling the user to either pass a path
or run the `ai-ready` skill first.

## Safety

- **Writes are visible to others** — creating issues shows up to every
  repo watcher. Always print the planned epic and ticket list and
  require user confirmation before the first `gh issue create`, unless
  the user already said "go" / "create them" in this turn.
- Treat dependency writes the same way: show the intended blocked-by
  relationships before the first `gh api --method POST` call unless
  the user already approved creation in this turn.
- Never close, delete, or reassign existing issues.
- If a `gh issue create`, `gh issue edit`, or dependency `gh api` call
  fails mid-loop, stop and print which tickets and dependencies were
  created so the user can re-run (idempotency will skip or repair
  them).

## Output

Keep the final response concise: one line per created or updated
issue, then the summary table. Do not paste the full epic body back
unless the user asks.
