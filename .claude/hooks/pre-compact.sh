#!/bin/bash
# pre-compact.sh — Runs before Claude context compaction
# Saves critical state before context is compressed

STUDIOS_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
STATE_FILE="$STUDIOS_DIR/production/session-state.md"

cat > "$STATE_FILE" << EOF
# Session State — Pre-Compact Snapshot
**Timestamp**: $(date -u '+%Y-%m-%dT%H:%M:%SZ')

## Active Engagement
$(cat "$STUDIOS_DIR/production/active-engagement.md" 2>/dev/null | head -20 || echo "No active engagement")

## Recent Operations
$(tail -20 "$STUDIOS_DIR/production/logs/operations.log" 2>/dev/null || echo "No recent operations")

## Instructions for Post-Compact
After compaction, Claude should:
1. Re-read CLAUDE.md for studio context
2. Check production/active-engagement.md for scope
3. Review this file for recent session state
4. Continue from where work left off
EOF

echo "Pre-compact state saved to production/session-state.md"
exit 0
