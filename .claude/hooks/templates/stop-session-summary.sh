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

if git rev-parse --git-dir > /dev/null 2>&1; then
  # Get all modified files (staged and unstaged)
  CHANGED_FILES=$(git status --porcelain | awk '{print $2}' | head -20)

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

if git rev-parse --git-dir > /dev/null 2>&1; then
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

if git rev-parse --git-dir > /dev/null 2>&1; then
  # Lines added/removed
  STATS=$(git diff --shortstat 2>/dev/null)
  if [ -n "$STATS" ]; then
    SUMMARY+="$STATS
"
  else
    SUMMARY+="No line changes detected.
"
  fi

  # File type breakdown
  SUMMARY+="
**File Types Modified:**
"

  git status --porcelain | awk '{print $2}' | while read -r file; do
    echo "${file##*.}"
  done | sort | uniq -c | sort -rn | head -5 | while read -r count ext; do
    SUMMARY+="- .$ext files: $count
"
  done
fi

SUMMARY+="
"

# ============================================================================
# SECTION 5: tests.json Status (if using Long-Running Agents)
# ============================================================================

if [ -f "tests.json" ]; then
  SUMMARY+="### ✅ tests.json Status

"

  # Count passing vs failing tests
  PASSING=$(grep -o '"passes": true' tests.json 2>/dev/null | wc -l || echo "0")
  FAILING=$(grep -o '"passes": false' tests.json 2>/dev/null | wc -l || echo "0")
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
  # Extract key stats for notification
  if git rev-parse --git-dir > /dev/null 2>&1; then
    FILES_CHANGED=$(git status --porcelain | wc -l)
    COMMITS_MADE=$(git log --since="1 hour ago" --oneline 2>/dev/null | wc -l)

    MESSAGE="🎉 Claude Code session completed!

📝 Files changed: $FILES_CHANGED
📦 Commits made: $COMMITS_MADE

Session log saved to $SESSION_FILE"

    node "$NOTIFIER" send "$MESSAGE" 2>/dev/null &
    echo "📱 Notification sent to Telegram"
  fi
fi

exit 0
