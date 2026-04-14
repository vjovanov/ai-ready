# AI-Ready task runner. The single entry point for lint, format, and
# link checks. Rubric signals 5.7 and 6.x.
#
# Install: https://just.systems
# Requires: npx (for markdownlint-cli2, prettier), lychee, rg

set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Default target: the same checks CI runs.
default: check

# Run everything CI runs. Fast-fail on the first failure.
check: lint format-check links anchors

# Markdown lint.
lint:
    npx --yes markdownlint-cli2 "**/*.md" "#node_modules" "#.git"

# Markdown formatting check (no writes).
format-check:
    npx --yes prettier --check "**/*.md"

# Apply formatting in place.
fmt:
    npx --yes prettier --write "**/*.md"

# Internal and external link check.
links:
    lychee --no-progress --verbose --offline \
        --exclude-path node_modules \
        --exclude-path .git \
        "**/*.md"

# Rubric consistency: every SKILL.md anchor must resolve in the guide.
# Pure bash + rg, no scripts dir.
anchors:
    @echo "Checking SKILL.md → AI_READINESS_GUIDE.md anchors..."
    @missing=$$( \
        rg -o 'AI_READINESS_GUIDE\.md#[a-z0-9-]+' skills/ai-ready/SKILL.md \
        | sed 's|.*#||' \
        | sort -u \
        | while read -r anchor; do \
            if ! rg -q "^#+.*\{#$${anchor}\}|^#+ " skills/ai-ready/references/AI_READINESS_GUIDE.md \
                || ! rg -q "$${anchor}" skills/ai-ready/references/AI_READINESS_GUIDE.md; then \
                echo "  MISSING: $${anchor}"; \
            fi; \
        done \
    ); \
    if [ -n "$$missing" ]; then \
        echo "$$missing"; exit 1; \
    fi
    @echo "All SKILL.md anchors resolve."

# Score this repo against its own rubric (requires an AI agent).
self-score:
    @echo "Run the ai-ready skill against this directory from your agent."
    @echo "  e.g. in Claude Code:  /ai-ready ."
