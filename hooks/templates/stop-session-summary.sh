#!/bin/bash
# Stop Session Summary Hook
# Generates a comprehensive session summary when Claude Code stops
#
# Hook Type: Stop
# Description: Documents what was accomplished in the session
#
# Installation:
#   1. Copy to ~/.claude/hooks/ or .claude/hooks/
#   2. chmod +x stop-session-summary.sh
#   3. Run /hooks in Claude Code and configure:
#      - Event: Stop
#      - Script: stop-session-summary.sh

set -e

# Configuration
PROGRESS_FILE="claude-progress.txt"
SESSION_LOG=".claude/session-logs"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
DATE_SLUG=$(date +"%Y%m%d-%H%M%S")

echo "📊 Generating session summary..."
echo ""

# Create session logs directory if it doesn't exist
mkdir -p "$SESSION_LOG"

# ============================================================================
# SECTION 1: Session Header
# ============================================================================

SUMMARY="## Session Summary - $TIMESTAMP

---

"

# ============================================================================
# SECTION 2: Files Changed
# ============================================================================

SUMMARY+="### 📝 Files Modified

"

# Cache git operations to avoid redundant calls
IS_GIT_REPO=false
GIT_STATUS_OUTPUT=""

if git rev-parse --git-dir > /dev/null 2>&1; then
  IS_GIT_REPO=true
  # Cache git status output for reuse
  GIT_STATUS_OUTPUT=$(git status --porcelain)
fi

if [ "$IS_GIT_REPO" = true ]; then
  # Use cached git status output
  CHANGED_FILES=$(echo "$GIT_STATUS_OUTPUT" | awk '{print $2}' | head -20)

  if [ -n "$CHANGED_FILES" ]; then
    while IFS= read -r file; do
      # Get file stats
      if [ -f "$file" ]; then
        LINES=$(wc -l < "$file" 2>/dev/null || echo "0")
        SUMMARY+="- \`$file\` ($LINES lines)
"
      else
        SUMMARY+="- \`$file\` (deleted)
"
      fi
    done <<< "$CHANGED_FILES"
  else
    SUMMARY+="No files modified in this session.
"
  fi
else
  SUMMARY+="Not a git repository.
"
fi

SUMMARY+="
"

# ============================================================================
# SECTION 3: Commits Made
# ============================================================================

SUMMARY+="### 📦 Commits Made

"

if [ "$IS_GIT_REPO" = true ]; then
  # Get commits from last hour (approximate session duration)
  RECENT_COMMITS=$(git log --since="1 hour ago" --oneline 2>/dev/null)

  if [ -n "$RECENT_COMMITS" ]; then
    echo "$RECENT_COMMITS" | while IFS= read -r commit; do
      SUMMARY+="- $commit
"
    done
  else
    SUMMARY+="No commits made in this session.
"
  fi
fi

SUMMARY+="
"

# ============================================================================
# SECTION 4: Statistics
# ============================================================================

SUMMARY+="### 📊 Statistics

"

if [ "$IS_GIT_REPO" = true ]; then
  # Lines added/removed
  STATS=$(git diff --shortstat 2>/dev/null)
  if [ -n "$STATS" ]; then
    SUMMARY+="$STATS
"
  else
    SUMMARY+="No line changes detected.
"
  fi

  # File type breakdown - optimized with single pass
  SUMMARY+="
**File Types Modified:**
"

  # Use cached git status output and optimize with single awk command
  if [ -n "$GIT_STATUS_OUTPUT" ]; then
    FILE_TYPE_STATS=$(echo "$GIT_STATUS_OUTPUT" | awk '{print $2}' | \
      awk -F. '{if (NF>1) print $NF; else print "no-extension"}' | \
      sort | uniq -c | sort -rn | head -5)

    if [ -n "$FILE_TYPE_STATS" ]; then
      while read -r count ext; do
        if [ "$ext" = "no-extension" ]; then
          SUMMARY+="- files without extension: $count
"
        else
          SUMMARY+="- .$ext files: $count
"
        fi
      done <<< "$FILE_TYPE_STATS"
    fi
  fi
fi

SUMMARY+="
"

# ============================================================================
# SECTION 5: tests.json Status (if using Long-Running Agents)
# ============================================================================

if [ -f "tests.json" ]; then
  SUMMARY+="### ✅ tests.json Status

"

  # Count passing vs failing tests - optimized with single grep call
  PASSES_DATA=$(grep -o '"passes": \(true\|false\)' tests.json 2>/dev/null || echo "")
  if [ -n "$PASSES_DATA" ]; then
    PASSING=$(echo "$PASSES_DATA" | grep -c "true" || echo "0")
    FAILING=$(echo "$PASSES_DATA" | grep -c "false" || echo "0")
  else
    PASSING=0
    FAILING=0
  fi
  TOTAL=$((PASSING + FAILING))

  if [ "$TOTAL" -gt 0 ]; then
    PERCENTAGE=$((PASSING * 100 / TOTAL))
    SUMMARY+="Progress: $PASSING/$TOTAL tasks complete ($PERCENTAGE%)
"

    # Show recently completed tasks (changed from false to true)
    SUMMARY+="
**Recently Completed:**
"
    # This is a simplified version - in practice, you'd need to diff against previous state
    grep -B 2 '"passes": true' tests.json | grep '"task":' | head -5 | sed 's/.*"task": "//;s/".*//' | while read -r task; do
      SUMMARY+="- $task
"
    done
  else
    SUMMARY+="No tasks found in tests.json
"
  fi

  SUMMARY+="
"
fi

# ============================================================================
# SECTION 6: Next Steps
# ============================================================================

SUMMARY+="### 🎯 Next Steps

"

if [ -f "tests.json" ]; then
  # Find first incomplete task
  NEXT_TASK=$(grep -B 2 '"passes": false' tests.json | grep '"task":' | head -1 | sed 's/.*"task": "//;s/".*//')

  if [ -n "$NEXT_TASK" ]; then
    SUMMARY+="Continue with: **$NEXT_TASK**
"
  else
    SUMMARY+="All tasks completed! 🎉
"
  fi
else
  SUMMARY+="Review changed files and determine next priorities.
"
fi

SUMMARY+="
---

"

# ============================================================================
# Save summary to both claude-progress.txt and session log
# ============================================================================

# Append to claude-progress.txt if it exists
if [ -f "$PROGRESS_FILE" ]; then
  echo "$SUMMARY" >> "$PROGRESS_FILE"
  echo "✅ Updated $PROGRESS_FILE"
fi

# Save to session log
SESSION_FILE="$SESSION_LOG/session-$DATE_SLUG.md"
echo "$SUMMARY" > "$SESSION_FILE"
echo "✅ Saved session log to $SESSION_FILE"

# ============================================================================
# Display summary to user
# ============================================================================

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "$SUMMARY"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "📁 Session documented in:"
echo "   - $PROGRESS_FILE"
echo "   - $SESSION_FILE"
echo ""

# ============================================================================
# Optional: Send notification (if Telegram notifier is configured)
# ============================================================================

NOTIFIER=".claude/tools/telegram-notifier/telegram-notifier.js"
if [ -f "$NOTIFIER" ] && [ -x "$NOTIFIER" ]; then
  # Extract key stats for notification (reuse cached data)
  if [ "$IS_GIT_REPO" = true ]; then
    # Use cached git status output
    FILES_CHANGED=$(echo "$GIT_STATUS_OUTPUT" | wc -l)
    # Reuse commits data if available, otherwise fetch
    if [ -n "$RECENT_COMMITS" ]; then
      COMMITS_MADE=$(echo "$RECENT_COMMITS" | wc -l)
    else
      COMMITS_MADE=$(git log --since="1 hour ago" --oneline 2>/dev/null | wc -l)
    fi

    MESSAGE="🎉 Claude Code session completed!

📝 Files changed: $FILES_CHANGED
📦 Commits made: $COMMITS_MADE

Session log saved to $SESSION_FILE"

    node "$NOTIFIER" send "$MESSAGE" 2>/dev/null &
    echo "📱 Notification sent to Telegram"
  fi
fi

exit 0
