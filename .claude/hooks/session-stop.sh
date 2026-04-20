#!/bin/bash
# session-stop.sh — Runs at the end of each Claude Code session
# Archives logs and generates session summary

STUDIOS_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LOG_DIR="$STUDIOS_DIR/production/logs"
mkdir -p "$LOG_DIR"

echo "$(date -u '+%Y-%m-%d %H:%M:%S UTC') | SESSION END" >> "$LOG_DIR/session.log"

echo ""
echo "========================================"
echo "  🛡️  CYBERSECURITY STUDIOS — SESSION END"
echo "  Time: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo "  Session log: production/logs/session.log"
echo "  Operations log: production/logs/operations.log"
echo "========================================"
