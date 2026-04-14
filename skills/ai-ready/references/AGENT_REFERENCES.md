# References

This file collects the concrete filenames, directories, tool names, and
ecosystem-specific examples used by the AI-readiness assessment.

The main guide keeps its wording generic, with `SKILL.md` as the only file it
names directly. Claude and Codex remain the two primary IDE examples
throughout these references.

The list below is illustrative rather than exhaustive.

## Additional reference docs

- [Developer onboarding checklist](AI_DEVELOPER_ONBOARDING.md)
- [Hands-on exercises](EXERCISES.md)
- [Self-assessment quiz](QUIZ.md)

## Agent-specific quick map

### OpenCode

- Instruction files: `AGENTS.md`, `~/.config/opencode/AGENTS.md`,
  `CLAUDE.md` fallback
- Project config: `opencode.json`, `opencode.jsonc`
- Agents and plugins: `.opencode/agents/`, `.opencode/agent/`,
  `~/.config/opencode/agents/`, `.opencode/plugins/`
- MCP and permissions: `mcp` and `permission` keys in OpenCode config

### Claude Code

- Instruction files: `CLAUDE.md`, `.claude/CLAUDE.md`,
  `~/.claude/CLAUDE.md`
- Project config: `.claude/settings.json`, `.claude/settings.local.json`
- Agents and skills: `.claude/agents/`, `~/.claude/agents/`,
  `.claude/skills/`, `.claude/commands/`
- MCP and shared config: `.mcp.json`, `~/.claude.json`

### Codex

- Instruction files: `AGENTS.md` at repo, nested-directory, or home scope
- Shared config: `~/.codex/config.toml`, `.codex/config.toml`
- MCP examples: `codex mcp add`, `codex mcp list`
- Agent surfaces: `AGENTS.md`, `.codex/agents/*.toml`,
  `.agents/skills/<name>/SKILL.md`, plugins, hooks, and subagents

### Pi

- Instruction files: `AGENTS.md` loaded from `~/.pi/agent/`, parent
  directories, and the current directory
- System prompt files: `SYSTEM.md`
- Extensibility: extensions, skills, prompt templates, packages
- Safety model: container-first or OS-sandbox-first; permission gates and MCP
  support are typically added through extensions rather than built in

## 1. Project context for AI agents

### 1.1 Agent instruction files

Multiple instruction files (`AGENTS.md`, `CLAUDE.md`, `SYSTEM.md`) serve the same
purpose across different agent ecosystems. To avoid duplication, the primary
instruction file should be maintained in one location and **symlinked** from other
entry points within the repo and user config directories. This reduces merge
conflicts and ensures all agents receive consistent guidance.

**Shared repo instructions:**

- `AGENTS.md` — platform-agnostic; read by OpenCode, Codex, Pi, and others
- `CLAUDE.md` — Claude Code primary entry point
- `SYSTEM.md` — Pi primary entry point

**IDE/platform-specific search paths:**

- OpenCode: checks `AGENTS.md`, `~/.config/opencode/AGENTS.md`, falls back to
  `CLAUDE.md`
- Claude Code: checks `CLAUDE.md`, `.claude/CLAUDE.md`, `~/.claude/CLAUDE.md`
- Codex: checks `AGENTS.md`, `.codex/agents/*.toml`, and others
- Pi: checks `AGENTS.md` (from `~/.pi/agent/`, parents, current), then `SYSTEM.md`

**Nested instruction files:**

- Subsystems can have their own `AGENTS.md` or `CLAUDE.md` in subdirectories
  (e.g., `subdir/AGENTS.md`, `subdir/CLAUDE.md`)

**Recommendation:** Maintain one authoritative instruction file (e.g., `AGENTS.md`)
and symlink IDE-specific aliases (`CLAUDE.md` → `AGENTS.md`, `SYSTEM.md` →
`AGENTS.md`) so updates propagate across all entry points.

### 1.2 Entry-point instruction file links to the spec

The main instruction file should link to architecture docs, design decisions, and
any specification that an agent needs to understand the project's goals and
constraints. Without these links an agent has no way to discover deeper context.

**Files that typically serve as the entry point:**

- `AGENTS.md`
- `CLAUDE.md`
- `SYSTEM.md`

**What to link to:**

- Architecture overview (`ARCHITECTURE.md`, `docs/architecture/`)
- Design decisions (`docs/adr/`, `docs/rfcs/`)
- API specification (`docs/api/`, OpenAPI/Swagger files)
- Contribution guide (`CONTRIBUTING.md`)
- Build and run instructions (`README.md` or a dedicated `docs/dev-setup.md`)

### 1.3 AI ignore files

AI ignore files prevent agents from reading or indexing secrets, large binary
assets, generated output, and build artifacts that would waste context or leak
sensitive data.

**Agent-specific ignore files:**

- `.aicommitignore` — excludes paths from AI-generated commit messages
- `.aiexclude` — generic AI exclusion file
- `.claudeignore` — Claude Code exclusion file
- `.gitignore` — agents typically respect `.gitignore` as a baseline

**Common patterns to exclude:**

- Secrets directories (`secrets/`, `*.pem`, `*.key`, `.env*`)
- Build output (`dist/`, `build/`, `target/`, `out/`)
- Binary assets (`*.png`, `*.jpg`, `*.woff2`, `*.zip`)
- Vendored dependencies (`vendor/`, `node_modules/`)
- Generated code (`*_generated.*`, `*.pb.go`, `*_pb2.py`)

### 1.4 Contribution conventions

Contribution conventions tell the agent how to format commits, structure PRs, and
follow the team's workflow. Machine-parseable formats are preferred so agents can
enforce them automatically.

**Files and formats:**

- `CONTRIBUTING.md` — human-readable contribution guide
- `.commitlintrc`, `.commitlintrc.yml`, `commitlint.config.js` — commit message
  lint rules (Conventional Commits)
- `.github/PULL_REQUEST_TEMPLATE.md` — GitHub PR description template
- `.gitlab/merge_request_templates/` — GitLab MR description templates
- `.github/ISSUE_TEMPLATE/`, `.gitlab/issue_templates/` — issue templates
- `CODEOWNERS`, `.github/CODEOWNERS`, `.gitlab/CODEOWNERS` — ownership and review routing

### 1.5 Build and run docs

Clear build and run docs let an agent set up, build, test, and run the project
without guessing. The instructions should be copy-pasteable commands, not prose
descriptions.

**Where to document:**

- `README.md` — quick-start section with setup commands
- `AGENTS.md` / `CLAUDE.md` — agent-specific build commands (preferred, since
  agents read these first)
- `docs/dev-setup.md` — detailed development environment setup
- `justfile`, `Makefile`, `Taskfile.yml` — self-documenting task runners

**What to include:**

- Prerequisites (language runtime, system packages, services)
- Install/setup commands (`npm install`, `pip install -r requirements.txt`, etc.)
- Build command (`just build`, `make`, `cargo build`)
- Run command (`just run`, `npm start`, `./manage.py runserver`)
- Test command (`just test`, `pytest`, `npm test`)

## 2. Specification and architecture

### 2.1 Architecture docs exist

- `docs/architecture/`
- `ARCHITECTURE.md`
- `ADR/`

### 2.3 Diagrams present

- Mermaid — renders natively in GitHub/GitLab markdown; version-controllable and easy for agents to read and edit
- ASCII — zero tooling required; works everywhere including terminal and plain-text files; agents can generate and parse directly
- PlantUML — rich diagram types (sequence, class, activity, state); needs a renderer but widely supported in CI and IDEs
- D2 — declarative with auto-layout; clean syntax that is simpler than PlantUML for architecture and flow diagrams
- Image-based diagrams — highest visual fidelity (Figma exports, draw.io, Excalidraw); not version-controllable or agent-editable, so pair with a text source when possible

### 2.5 Design decisions recorded

- ADRs (Architecture Decision Records) — lightweight, numbered docs capturing one decision each with context, options, and outcome; easy to discover and link from code
- RFCs (Request for Comments) — richer proposal format for larger changes; invites team discussion before committing to a direction
- Decision logs — chronological journal of choices; lower ceremony than ADRs but harder to search; best when paired with an index

## 3. AI tool configuration

### 3.1 MCP servers

- `.mcp.json`
- OpenCode: `mcp` key in `opencode.json` or `opencode.jsonc`
- Claude Code: `.mcp.json`, `~/.claude.json`
- Codex: `~/.codex/config.toml`
- Pi: extension- or package-provided MCP integration
- Other repo-checked MCP config files when the team standardizes on them

### 3.2 Custom commands and skills

- OpenCode: `.opencode/agents/`, `.opencode/agent/`,
  `~/.config/opencode/agents/`, `.opencode/plugins/`
- Claude: `.claude/skills/<name>/SKILL.md`, `.claude/commands/*.md`,
  `.claude/agents/`
- Codex: `.agents/skills/<name>/SKILL.md`, `~/.agents/skills/`,
  `.codex/agents/*.toml`
- Pi: skills, prompt templates, extensions, packages

### 3.3 Hooks and guardrails

- OpenCode: `permission` config in `opencode.json`
- Claude: `.claude/settings.json`
- Codex: approval policies and sandbox settings in `.codex/config.toml`,
  hooks behind `[features] codex_hooks = true`
- Pi: container or OS sandbox plus extension-defined confirmation flows

### 3.4 IDE AI config

- OpenCode: `opencode.json`, `opencode.jsonc`, `tui.json`
- `.vscode/settings.json`
- `.idea/`
- Codex: `~/.codex/config.toml`, `.codex/config.toml`
- Pi project-local system and extension config

## 4. DevOps and workflow integration

### 4.1 Pull / merge request automation

- `gh` CLI (GitHub)
- `glab` CLI (GitLab)
- GitHub MCP servers
- GitLab API or MCP integrations

### 4.5 Tooling availability and auth

- `gh` (GitHub), `glab` (GitLab)
- GitHub or GitLab MCP servers in `.mcp.json`
- API tokens
- Bot or service accounts with write access

## 5. Dev environment reproducibility

### 5.1 Dev container definition — isolated, pre-configured dev environment an agent can spin up identically every time

- `.devcontainer/devcontainer.json`

### 5.2 Containerized runtime — packages the app and its dependencies so it runs the same everywhere

- `Dockerfile`
- `docker-compose.yml`

### 5.3 Nix environment — declarative, reproducible system-level dependencies that eliminate "works on my machine"

- `flake.nix`
- `shell.nix`

### 5.4 direnv environment loading — auto-loads project-specific env vars and PATH when you enter the directory

- `.envrc`

### 5.5 Lock files — pin exact dependency versions so every install produces the same tree

- `package-lock.json`
- `poetry.lock`
- `Cargo.lock`
- `go.sum`

### 5.6 Runtime version pins — ensure every developer and agent uses the same language/tool versions

- `.tool-versions`
- `.python-version`
- `.node-version`
- `.java-version`

### 5.7 Task runner — single entry point for build, test, lint, and format so agents don't have to guess the commands

- `justfile`
- `Makefile`
- `Taskfile.yml`

## 6. Type safety and static analysis

### 6.1 Type checking

- `tsconfig`
- mypy
- pyright
- `go vet`
- rustc

### 6.2 Linting

- eslint
- ruff
- clippy
- golangci-lint

### 6.3 Formatting

- prettier
- `ruff format`
- gofmt
- rustfmt

### 6.4 Cross-editor consistency

- `.editorconfig`

### 6.5 Pre-commit hooks

- `.pre-commit-config.yaml`
- husky
- lefthook

## 7. Test infrastructure

### 7.4 CI pipeline

- `.github/workflows/`
- `.gitlab-ci.yml`
- `Jenkinsfile`

### 7.7 Visual testing

- Browser automation: Playwright, Puppeteer, Cypress, Selenium
- Screenshot MCP servers: `browser-tools-mcp`, `playwright-mcp`
- Dev server start command documented in `CLAUDE.md` / `AGENTS.md`
- Visual regression tools: Percy, Chromatic, BackstopJS
- Storybook or similar component preview environments

## 9. Documentation quality

### 9.2 API docs

- JSDoc
- rustdoc
- Sphinx

### 9.3 Changelog or conventional commits

- `CHANGELOG.md`
