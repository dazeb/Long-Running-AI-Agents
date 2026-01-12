#!/bin/bash
# Post Tests Update Hook
# Auto-updates tests.json when tasks are completed (Long-Running Agents methodology)
#
# Hook Type: PostToolUse
# Tool Matcher: Edit|Write|Bash
# Description: Monitors for task completion and prompts Claude to update tests.json
#
# Installation:
#   1. Copy to ~/.claude/hooks/ or .claude/hooks/
#   2. chmod +x post-tests-update.sh
#   3. Run /hooks in Claude Code and configure:
#      - Event: PostToolUse
#      - Matcher: Edit|Write|Bash
#      - Script: post-tests-update.sh

set -e

# Configuration
TESTS_JSON="tests.json"
PROGRESS_FILE="claude-progress.txt"

# Exit if tests.json doesn't exist (not using Long-Running Agents methodology)
if [ ! -f "$TESTS_JSON" ]; then
  exit 0
fi

# Get tool name and output
TOOL_NAME="${CC_TOOL_NAME:-}"
TOOL_OUTPUT="${CC_TOOL_OUTPUT:-}"

# ============================================================================
# DETECTION: Check if a task appears to be completed
# ============================================================================

TASK_COMPLETE=false
KEYWORDS_FOUND=""

# Keywords that indicate task completion
COMPLETION_KEYWORDS=(
  "completed"
  "finished"
  "done"
  "passing"
  "fixed"
  "implemented"
  "working"
  "successful"
  "resolved"
  "✅"
  "✓"
)

# Check tool output for completion keywords
for keyword in "${COMPLETION_KEYWORDS[@]}"; do
  if echo "$TOOL_OUTPUT" | grep -qi "$keyword"; then
    TASK_COMPLETE=true
    KEYWORDS_FOUND="$KEYWORDS_FOUND $keyword"
  fi
done

# If no completion detected, exit silently
if [ "$TASK_COMPLETE" = false ]; then
  exit 0
fi

# ============================================================================
# ANALYSIS: Determine which task(s) were completed
# ============================================================================

echo ""
echo "🔍 Task completion detected! Keywords found:$KEYWORDS_FOUND"
echo ""

# Count current task status
TOTAL_TASKS=$(grep -c '"task":' "$TESTS_JSON" 2>/dev/null || echo "0")
PASSING_TASKS=$(grep -c '"passes": true' "$TESTS_JSON" 2>/dev/null || echo "0")
FAILING_TASKS=$(grep -c '"passes": false' "$TESTS_JSON" 2>/dev/null || echo "0")

echo "📊 Current Status:"
echo "   Total tasks: $TOTAL_TASKS"
echo "   Passing: $PASSING_TASKS"
echo "   Failing: $FAILING_TASKS"
echo ""

# Find the first incomplete task as a hint
NEXT_INCOMPLETE=$(grep -B 2 '"passes": false' "$TESTS_JSON" | grep '"task":' | head -1 | sed 's/.*"task": "//;s/".*//')

# ============================================================================
# PROMPT: Ask Claude to update tests.json
# ============================================================================

if [ -n "$NEXT_INCOMPLETE" ]; then
  echo "📝 REMINDER: Please update tests.json"
  echo ""
  echo "The task '$NEXT_INCOMPLETE' may be complete."
  echo ""
  echo "Please:"
  echo "1. Verify the task is fully complete (tests pass, code works)"
  echo "2. Update tests.json to mark it as passing:"
  echo "   - Find the task in tests.json"
  echo "   - Change '\"passes\": false' to '\"passes\": true'"
  echo "3. Document what was done in $PROGRESS_FILE"
  echo ""
fi

# ============================================================================
# OPTIONAL: Auto-update tests.json (if you want full automation)
# ============================================================================

# Uncomment this section if you want automatic updates
# WARNING: This will auto-mark tasks as complete based on keywords
# Only enable if you're confident in the detection logic

# AUTO_UPDATE=false  # Set to true to enable auto-updates
#
# if [ "$AUTO_UPDATE" = true ] && [ -n "$NEXT_INCOMPLETE" ]; then
#   echo "🤖 Auto-updating tests.json..."
#
#   # Use jq to update the first failing task
#   if command -v jq &> /dev/null; then
#     TMP_FILE=$(mktemp)
#
#     # Find and update the first incomplete task
#     jq '
#       (.features[] |
#         select(.atomic_units != null) |
#         .atomic_units[] |
#         select(.passes == false)) |= .passes = true
#     ' "$TESTS_JSON" > "$TMP_FILE"
#
#     mv "$TMP_FILE" "$TESTS_JSON"
#
#     echo "✅ Updated tests.json: marked task as passing"
#     echo "   Task: $NEXT_INCOMPLETE"
#     echo ""
#
#     # Update progress file
#     if [ -f "$PROGRESS_FILE" ]; then
#       echo "## Task Completed - $(date)" >> "$PROGRESS_FILE"
#       echo "" >> "$PROGRESS_FILE"
#       echo "- ✅ $NEXT_INCOMPLETE" >> "$PROGRESS_FILE"
#       echo "" >> "$PROGRESS_FILE"
#       echo "Updated $PROGRESS_FILE"
#     fi
#
#     # Optional: Auto-commit
#     # git add tests.json "$PROGRESS_FILE"
#     # git commit -m "tests: mark task as complete - $NEXT_INCOMPLETE"
#     # echo "📦 Changes committed to git"
#   else
#     echo "⚠️  jq not installed, cannot auto-update tests.json"
#     echo "   Install: brew install jq (macOS) or apt-get install jq (Linux)"
#   fi
# fi

# ============================================================================
# LOGGING: Record completion event
# ============================================================================

LOG_DIR=".claude/task-logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/$(date +%Y-%m).log"

echo "[$(date +"%Y-%m-%d %H:%M:%S")] Task completion detected" >> "$LOG_FILE"
echo "  Tool: $TOOL_NAME" >> "$LOG_FILE"
echo "  Keywords: $KEYWORDS_FOUND" >> "$LOG_FILE"
if [ -n "$NEXT_INCOMPLETE" ]; then
  echo "  Suggested task: $NEXT_INCOMPLETE" >> "$LOG_FILE"
fi
echo "" >> "$LOG_FILE"

# ============================================================================
# NOTIFICATION: Optional Telegram notification
# ============================================================================

NOTIFIER=".claude/tools/telegram-notifier/telegram-notifier.js"
if [ -f "$NOTIFIER" ] && [ -x "$NOTIFIER" ]; then
  if [ -n "$NEXT_INCOMPLETE" ]; then
    MESSAGE="✅ Task may be complete: $NEXT_INCOMPLETE

Please review and update tests.json

Progress: $PASSING_TASKS/$TOTAL_TASKS complete"

    node "$NOTIFIER" send "$MESSAGE" 2>/dev/null &
  fi
fi

exit 0
