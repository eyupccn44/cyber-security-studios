#!/bin/bash
# validate-scope.sh — Validates that bash commands are within engagement scope
# Called before every Bash tool use
# Usage: bash validate-scope.sh "$CLAUDE_TOOL_INPUT"

STUDIOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ENGAGEMENT_FILE="$STUDIOS_DIR/production/active-engagement.md"

TOOL_INPUT="$1"

# If no engagement file exists, warn but don't block (allows non-active work)
if [ ! -f "$ENGAGEMENT_FILE" ]; then
    exit 0  # Allow — CISO / grc / defensive work doesn't need scope
fi

# Extract scope targets from engagement file
SCOPE_TARGETS=$(grep -A 50 "### In-Scope" "$ENGAGEMENT_FILE" | grep -B 50 "### Out-of-Scope" | grep "^-" | sed 's/^- //')
OUT_OF_SCOPE=$(grep -A 50 "### Out-of-Scope" "$ENGAGEMENT_FILE" | grep "^-" | sed 's/^- //')

# Check for clearly dangerous/prohibited patterns
PROHIBITED_PATTERNS=(
    "rm -rf /"
    "dd if=/dev/zero of=/dev/sd"
    ":(){ :|:& };:"
    "mkfs\."
    "chmod -R 777 /"
    "shutdown"
    "reboot"
)

for pattern in "${PROHIBITED_PATTERNS[@]}"; do
    if echo "$TOOL_INPUT" | grep -q "$pattern"; then
        echo "🚫 BLOCKED: Potentially destructive command detected: $pattern"
        echo "   Command: $TOOL_INPUT"
        echo "   Escalate to CISO if this is intentional."
        exit 1
    fi
done

# Log all bash tool uses for audit trail
LOG_DIR="$STUDIOS_DIR/production/logs"
mkdir -p "$LOG_DIR"
echo "$(date -u '+%Y-%m-%dT%H:%M:%SZ') | BASH | $(echo "$TOOL_INPUT" | head -c 200)" >> "$LOG_DIR/operations.log"

exit 0
