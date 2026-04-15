# AI-Ready task runner. The single entry point for lint, format, and
# link checks. Rubric signals 5.7 and 6.x.
#
# Install: https://just.systems
# Requires: npx (for markdownlint-cli2, prettier), lychee, rg
# See docs/LOCAL_TOOLING.md for a reproducible local setup path.

set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Default target: the same checks CI runs.
default: check

# Verify the local toolchain needed for repo checks.
doctor:
    #!/usr/bin/env bash
    set -euo pipefail
    missing=0
    for cmd in just rg node npm lychee pre-commit; do
        if command -v "$cmd" >/dev/null 2>&1; then
            version=$("$cmd" --version 2>/dev/null | head -n 1)
            printf "ok  %-10s %s\n" "$cmd" "$version"
        else
            printf "missing %-10s\n" "$cmd"
            missing=1
        fi
    done

    if [ "$missing" -ne 0 ]; then
        echo "See docs/LOCAL_TOOLING.md for install commands."
        exit 1
    fi

# Run everything CI runs. Fast-fail on the first failure.
check: lint format-check links anchors

# Markdown lint.
lint:
    npx --yes markdownlint-cli2 \
        "**/*.md" \
        "#node_modules" \
        "#.git" \
        "#.agents" \
        "#.claude" \
        "#.codex" \
        "#.pi"

# Markdown formatting check (no writes).
format-check:
    npx --yes prettier --check --ignore-path .prettierignore "**/*.md"

# Apply formatting in place.
fmt:
    npx --yes prettier --write --ignore-path .prettierignore "**/*.md"

# Internal and external link check.
links:
    @if ! command -v lychee >/dev/null 2>&1; then \
        echo "lychee is required for link checks. See docs/LOCAL_TOOLING.md."; \
        exit 127; \
    fi
    lychee --no-progress --verbose --offline \
        --exclude-path node_modules \
        --exclude-path .git \
        --exclude-path .agents \
        --exclude-path .claude \
        --exclude-path .codex \
        --exclude-path .pi \
        "**/*.md"

# Rubric consistency: every SKILL.md anchor must resolve in the guide.
# Pure bash + rg, no scripts dir.
anchors:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Checking SKILL.md → AI_READINESS_GUIDE.md anchors..."

    skill_anchors=$(
        rg -o 'AI_READINESS_GUIDE\.md#[a-z0-9-]+' skills/ai-ready/SKILL.md \
            | sed 's|.*#||' \
            | sort -u
    )

    guide_anchors=$(
        rg '^### [0-9]' skills/ai-ready/references/AI_READINESS_GUIDE.md \
            | sed -E 's/^[0-9]+:### //' \
            | tr '[:upper:]' '[:lower:]' \
            | sed -E 's/ /-/g; s/[^a-z0-9-]//g; s/^-+//; s/-+$//' \
            | sort -u
    )

    missing=$(
        comm -23 \
            <(printf '%s\n' "$skill_anchors") \
            <(printf '%s\n' "$guide_anchors")
    )

    if [ -n "$missing" ]; then
        echo "$missing"
        exit 1
    fi

    echo "All SKILL.md anchors resolve."

# Install local git hooks after `pre-commit` is available.
install-hooks:
    @if ! command -v pre-commit >/dev/null 2>&1; then \
        echo "pre-commit is required to install hooks. See docs/LOCAL_TOOLING.md."; \
        exit 127; \
    fi
    pre-commit install

# Score this repo against its own rubric (requires an AI agent).
self-score:
    @echo "Run the ai-ready skill against this directory from your agent."
    @echo "  e.g. in Claude Code:  /ai-ready ."
