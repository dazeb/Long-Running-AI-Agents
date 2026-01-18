#!/bin/bash

# Telegram Notifier Shell Script
# Wrapper for easy integration with git hooks and automation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
NOTIFIER="$PROJECT_ROOT/telegram-notifier.js"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to send notification
send_notification() {
    local message="$1"
    node "$NOTIFIER" send "$message"
}

# Function to send task completion
notify_task_complete() {
    local task="$1"
    local session="${2:-}"
    local duration="${3:-}"
    node "$NOTIFIER" task "$task" "$session" "$duration"
}

# Function to send git commit notification
# Optimized to use single git command for commit info
notify_git_commit() {
    # Single git log command to get hash, message, and author
    local git_info=$(git log -1 --pretty=format:"%h%n%B%n%an")
    local commit_hash=$(echo "$git_info" | sed -n '1p')
    local commit_msg=$(echo "$git_info" | sed -n '2p')
    local author=$(echo "$git_info" | sed -n '3p')
    local branch=$(git rev-parse --abbrev-ref HEAD)

    local message="📝 *New Commit*

🔹 *Branch:* \`$branch\`
👤 *Author:* $author
🔖 *Hash:* \`$commit_hash\`

💬 *Message:*
$commit_msg"

    send_notification "$message"
}

# Function to send build status
# Optimized to use single git command
notify_build_status() {
    local status="$1"
    local duration="${2:-unknown}"

    if [ "$status" = "success" ]; then
        local emoji="✅"
        local status_text="Build Successful"
    else
        local emoji="❌"
        local status_text="Build Failed"
    fi

    # Single git command for both branch and commit hash
    local git_info=$(git log -1 --pretty=format:"%h%n%D")
    local commit_hash=$(echo "$git_info" | sed -n '1p')
    local branch=$(echo "$git_info" | sed -n '2p' | sed 's/.*HEAD -> \([^,]*\).*/\1/' | sed 's/HEAD//')

    # Fallback to rev-parse if branch extraction from log fails
    if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
        branch=$(git rev-parse --abbrev-ref HEAD)
    fi

    local message="$emoji *$status_text*

⏱️ *Duration:* $duration
🌿 *Branch:* $branch
📦 *Commit:* \`$commit_hash\`
⏰ *Time:* $(date '+%Y-%m-%d %H:%M:%S')"

    send_notification "$message"
}

# Function to send test results
notify_test_results() {
    local passed="$1"
    local failed="$2"
    local total=$((passed + failed))

    if [ "$failed" -eq 0 ]; then
        local emoji="✅"
        local status="All Tests Passed"
    else
        local emoji="⚠️"
        local status="Some Tests Failed"
    fi

    local message="$emoji *Test Results: $status*

📊 *Summary:*
• Total: $total tests
• Passed: $passed ✓
• Failed: $failed ✗
• Success Rate: $(awk "BEGIN {printf \"%.1f\", ($passed/$total)*100}")%

⏰ *Time:* $(date '+%Y-%m-%d %H:%M:%S')"

    send_notification "$message"
}

# Main CLI interface
case "$1" in
    test)
        echo -e "${YELLOW}Testing Telegram bot...${NC}"
        node "$NOTIFIER" test
        ;;
    send)
        shift
        send_notification "$*"
        ;;
    task)
        shift
        notify_task_complete "$@"
        ;;
    commit)
        notify_git_commit
        ;;
    build)
        notify_build_status "${2:-success}" "${3:-}"
        ;;
    tests)
        notify_test_results "${2:-0}" "${3:-0}"
        ;;
    *)
        echo "Telegram Notifier Shell Wrapper"
        echo ""
        echo "Usage:"
        echo "  $0 test                      Test bot connectivity"
        echo "  $0 send <message>            Send a custom message"
        echo "  $0 task <name> [session]     Send task completion"
        echo "  $0 commit                    Send git commit notification"
        echo "  $0 build <status> [duration] Send build status (success/failed)"
        echo "  $0 tests <passed> <failed>   Send test results"
        echo ""
        echo "Examples:"
        echo "  $0 test"
        echo "  $0 send \"Deployment starting...\""
        echo "  $0 task \"User Auth\" \"4\" \"45 minutes\""
        echo "  $0 commit"
        echo "  $0 build success \"2m 34s\""
        echo "  $0 tests 245 3"
        exit 1
        ;;
esac
