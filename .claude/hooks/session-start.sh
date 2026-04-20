#!/bin/bash
# session-start.sh — Runs at the beginning of each Claude Code session
# Validates ethical boundaries and loads engagement context

STUDIOS_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
ENGAGEMENT_FILE="$STUDIOS_DIR/production/active-engagement.md"
LOG_DIR="$STUDIOS_DIR/production/logs"
mkdir -p "$LOG_DIR"

echo "========================================"
echo "  🛡️  CYBERSECURITY STUDIOS — SESSION START"
echo "========================================"
echo "  Time: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo "========================================"

# Check for active engagement
if [ -f "$ENGAGEMENT_FILE" ]; then
    ENGAGEMENT_NAME=$(grep "^## Engagement:" "$ENGAGEMENT_FILE" | head -1 | sed 's/## Engagement: //')
    ENGAGEMENT_TYPE=$(grep "^- \*\*Type\*\*:" "$ENGAGEMENT_FILE" | head -1 | sed 's/.*: //')
    echo ""
    echo "  ✅ ACTIVE ENGAGEMENT LOADED"
    echo "  📋 Name: ${ENGAGEMENT_NAME:-Unknown}"
    echo "  🔍 Type: ${ENGAGEMENT_TYPE:-Unknown}"
    echo ""
    echo "  ⚠️  ALL OPERATIONS MUST STAY WITHIN DEFINED SCOPE"
else
    echo ""
    echo "  ⚠️  NO ACTIVE ENGAGEMENT DEFINED"
    echo "  Run /scope-define to define engagement scope"
    echo "  No active security testing until scope is defined!"
    echo ""
fi

# Log session start
echo "$(date -u '+%Y-%m-%d %H:%M:%S UTC') | SESSION START | User: ${USER:-unknown}" >> "$LOG_DIR/session.log"

echo "========================================"
echo "  Type /start to initialize | /help for commands"
echo "========================================"
