---
name: ai-ready-tickets
description: Turn an AI-readiness report into GitHub issues — one epic summarizing the score and verdict, plus one sub-ticket per follow-up item. Idempotent: re-running updates the epic rather than creating duplicates.
user-invocable: true
allowed-tools: Bash Read Grep Glob
argument-hint: [report-path] [--repo owner/repo] [--dry-run]
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

## Parsing the report

Extract these sections from the report:

- **Title** — first `# ...` line (usually `AI Readiness Report: <repo>`).
- **Score** and **Verdict** — from `**Score:**` / `**Verdict:**` lines.
- **Scores table** — the `## Scores` Markdown table (keep verbatim).
- **Strengths**, **Weaknesses**, **Top 3 improvements** — bullet lists
  under those headings.
- **Follow-up tickets** — bullet list under `## Follow-up tickets`.
  Each line follows:

  ```
  - `[type:<feature|task|bug>] [priority:<0-4>] <title>` — <description>
  ```

  Parse `type`, `priority`, `title`, `description` per line. Skip
  malformed lines and warn once at the end.

## Idempotency

Before creating anything, search for an existing epic:

```bash
gh issue list --repo <owner/repo> --search 'in:title "AI Readiness" label:ai-readiness:epic' --state all --json number,title,url,state
```

- If an open epic exists → update it in place (edit body, add any
  missing sub-tickets, do not recreate existing ones matched by
  title).
- If a closed epic exists → ask the user whether to reopen or create a
  new one. Do not silently reopen.
- If none exists → create a new epic.

For sub-tickets, match by exact title within the epic's task list
before creating. Never create a second ticket with the same title.

## Labels

Ensure these labels exist (create with `gh label create ... --force`
if missing):

- `ai-readiness:epic` — on the epic.
- `ai-readiness` — on every sub-ticket.
- `type:feature`, `type:task`, `type:bug` — per ticket.
- `priority:0`..`priority:4` — per ticket.

## Epic body

Use this template. Fill the task list after sub-tickets are created
(or during a dry-run, with placeholder numbers).

```markdown
# AI Readiness Epic

**Score:** X/100 · **Verdict:** <verdict>
**Report:** <path or link to report, if in repo>
**Generated:** <ISO date>

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

_Tracked by the `ai-ready-tickets` skill. Re-run the skill to refresh
this epic; it will not create duplicate sub-tickets._
```

## Sub-ticket body

```markdown
<description from report>

---

**Parent epic:** #<epic-num>
**Source:** AI Readiness Report (<date>)
**Category:** <if inferable from the report context, else omit>
```

## Execution

1. Resolve report path and target repo. Print:
   `Repo: <owner/repo> · Report: <path> · <N> follow-up items`.
2. Ensure labels exist.
3. Find or create the epic (empty task list for now). Capture its
   number.
4. For each follow-up item, in report order:
   - Compute canonical title: strip surrounding backticks/brackets;
     keep the human title text only.
   - If a sub-ticket with that title already exists in the repo and is
     linked to this epic, skip and record its number.
   - Otherwise create it with `gh issue create --title <title> --body
     <body> --label ai-readiness,type:<t>,priority:<p>`. Record the
     returned number.
5. Edit the epic body so the task list references every sub-ticket in
   report order with `- [ ] #<num> <title> — type:<t> priority:<p>`.
6. Print a summary table:

   ```
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
- Never close, delete, or reassign existing issues.
- If the `gh` call fails mid-loop, stop and print which tickets were
  created so the user can re-run (idempotency will skip them).

## Output

Keep the final response concise: one line per created or updated
issue, then the summary table. Do not paste the full epic body back
unless the user asks.
