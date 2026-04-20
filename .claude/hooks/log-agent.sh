#!/bin/bash
# log-agent.sh — Logs agent tool use actions for audit trail

STUDIOS_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
LOG_DIR="$STUDIOS_DIR/production/logs"
mkdir -p "$LOG_DIR"

echo "$(date -u '+%Y-%m-%dT%H:%M:%SZ') | TOOL_USE | done" >> "$LOG_DIR/operations.log"

exit 0
