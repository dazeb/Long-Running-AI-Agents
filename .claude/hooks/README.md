# 🪝 Claude Code Hooks Guide

**Automate your workflow with powerful event-driven hooks.**

Hooks are user-defined shell commands that execute automatically at various points in Claude Code's lifecycle. They provide deterministic control over Claude's behavior, ensuring certain actions always happen rather than relying on the LLM to choose to run them.

---

## 📋 Table of Contents

- [What Are Hooks?](#what-are-hooks)
- [Hook Types](#hook-types)
- [When to Use Hooks](#when-to-use-hooks)
- [Available Templates](#available-templates)
- [Installation](#installation)
- [Best Practices](#best-practices)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

---

## What Are Hooks?

Hooks are shell scripts that run automatically when specific events occur in Claude Code:

- **PreToolUse** - Runs BEFORE a tool is executed (can block or modify)
- **PostToolUse** - Runs AFTER a tool completes successfully
- **Stop** - Runs when the Claude Code session ends
- **PermissionRequest** - Runs when a permission dialog is shown

### Why Use Hooks?

**Without Hooks:**
```
❌ Manually remind Claude to format code
❌ Hope Claude runs tests before committing
❌ Risk editing sensitive files
❌ Forget to update tracking files
```

**With Hooks:**
```
✅ Auto-format every edit with Prettier/ESLint
✅ Auto-run tests after code changes
✅ Block edits to .env, package-lock.json, .git/
✅ Auto-update tests.json after task completion
✅ Generate session summaries automatically
```

---

## Hook Types

### 1. PreToolUse Hooks

**When:** Before tool execution
**Can:** Block execution, modify inputs, provide feedback to Claude
**Use For:** Validation, safety checks, input transformation

**Exit Codes:**
- `0` - Allow execution to proceed
- `2` - Block execution, send output to Claude
- `1` or other - Treat as error

**Example Use Cases:**
- Block edits to sensitive files (.env, package-lock.json)
- Validate file paths before operations
- Check for required environment variables
- Enforce code style rules
- Prevent dangerous git operations

### 2. PostToolUse Hooks

**When:** After tool completes successfully
**Can:** Run cleanup, formatting, tests, notifications
**Use For:** Automation, quality checks, side effects

**Exit Codes:**
- `0` - Success, output shown to user and Claude
- `1` or other - Failure, output shown as error

**Example Use Cases:**
- Auto-format code with Prettier/ESLint
- Run tests after code changes
- Update tests.json after feature completion
- Send Telegram notifications
- Generate git commits
- Update documentation

### 3. Stop Hooks

**When:** Session ends (user stops Claude)
**Can:** Final cleanup, summaries, commits
**Use For:** Session-end tasks

**Example Use Cases:**
- Generate session summary
- Final git commit
- Update claude-progress.txt
- Cleanup temporary files
- Send completion notifications

### 4. PermissionRequest Hooks

**When:** Permission dialog shown
**Can:** Auto-approve/deny based on rules
**Use For:** Permission automation

**Example Use Cases:**
- Auto-approve safe operations
- Auto-deny dangerous operations
- Log permission requests
- Custom approval logic

---

## When to Use Hooks

### ✅ Perfect for Hooks

1. **Deterministic Quality Checks**
   - Code formatting (Prettier, ESLint, Black)
   - Linting and type checking
   - Test execution

2. **Safety Guardrails**
   - Block sensitive file edits
   - Prevent force pushes to main
   - Validate environment variables

3. **Automation**
   - Auto-update tracking files
   - Generate git commits
   - Send notifications

4. **Consistency Enforcement**
   - Code style adherence
   - Documentation updates
   - Commit message format

### ❌ Not Recommended for Hooks

1. **Complex Decision Making**
   - Let Claude decide when to run tests
   - Let Claude choose formatting style
   - Let Claude determine file structure

2. **Long-Running Operations**
   - Building entire projects (use PostToolUse with timeout)
   - Running full test suites (run subset in hook)
   - Network operations with high latency

3. **Operations Requiring Context**
   - Deciding which tests to run
   - Choosing what to document
   - Determining commit messages

---

## Available Templates

We provide battle-tested hook templates in the `templates/` directory:

### 1. post-edit-format.sh
**Auto-format code after edits**

- Detects file type (JS, TS, Python, etc.)
- Runs appropriate formatter (Prettier, Black, etc.)
- Only formats if formatter is installed
- Shows formatted diff to Claude

**Use When:** You want consistent code formatting without asking Claude

### 2. pre-git-safety.sh
**Block dangerous git operations**

- Prevents force push to main/master
- Blocks commits to main without explicit approval
- Prevents editing .git/ directory
- Validates branch names

**Use When:** You want to prevent accidental destructive git operations

### 3. stop-session-summary.sh
**Generate session summary when Claude stops**

- Lists files changed in session
- Shows commits made
- Updates claude-progress.txt with summary
- Generates session report

**Use When:** You want automatic session documentation

### 4. post-tests-update.sh
**Auto-update tests.json after task completion**

- Detects when task is completed
- Updates tests.json with pass/fail status
- Commits changes automatically
- Notifies Claude of progress

**Use When:** Using Long-Running Agents methodology with tests.json

### 5. pre-env-protection.sh (Coming Soon)
**Block edits to environment files**

- Prevents editing .env, .env.local, etc.
- Blocks commits containing secrets
- Validates environment variable format

**Use When:** You want to prevent secret leakage

---

## Installation

### Quick Start (Individual Hook)

1. **Copy template:**
   ```bash
   cp .claude/hooks/templates/post-edit-format.sh ~/.claude/hooks/
   ```

2. **Make executable:**
   ```bash
   chmod +x ~/.claude/hooks/post-edit-format.sh
   ```

3. **Enable in Claude Code:**
   ```bash
   /hooks
   ```
   - Select hook event (PreToolUse, PostToolUse, Stop)
   - Choose your hook script
   - Select tool matchers (e.g., "Edit", "Write")
   - Choose scope (this project, all projects, session only)

### Install All Templates

```bash
# Copy all templates to your hooks directory
cp .claude/hooks/templates/* ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# Or for project-specific hooks:
cp .claude/hooks/templates/* .claude/hooks/
chmod +x .claude/hooks/*.sh
```

### Project-Specific Setup

For the Long-Running Agents methodology, we recommend:

```bash
# In your project root
mkdir -p .claude/hooks

# Copy relevant templates
cp .claude/hooks/templates/post-tests-update.sh .claude/hooks/
cp .claude/hooks/templates/stop-session-summary.sh .claude/hooks/

# Make executable
chmod +x .claude/hooks/*.sh
```

Then configure hooks using `/hooks` command.

---

## Best Practices

### 1. Scope Precisely
```bash
# ✅ Good - Target specific tools
Tool matcher: Edit|Write

# ❌ Too broad - Runs on everything
Tool matcher: .*
```

### 2. Fail Fast
```bash
# ✅ Good - Quick validation
if [ ! -f ".env.example" ]; then
  echo "Error: .env.example not found"
  exit 2
fi

# ❌ Bad - Slow operation
npm test --coverage  # Takes 5 minutes
```

### 3. Provide Clear Feedback
```bash
# ✅ Good - Explains what happened
echo "✅ Formatted 3 files with Prettier"
echo "📝 Updated: src/App.tsx, src/utils.ts, src/config.ts"

# ❌ Bad - Silent or cryptic
echo "Done"
```

### 4. Handle Missing Dependencies
```bash
# ✅ Good - Graceful degradation
if ! command -v prettier &> /dev/null; then
  echo "ℹ️  Prettier not installed, skipping formatting"
  exit 0
fi

# ❌ Bad - Hard failure
prettier --write $file  # Crashes if not installed
```

### 5. Use Exit Codes Correctly
```bash
# PreToolUse hooks:
exit 0   # Allow operation
exit 2   # Block operation, send message to Claude
exit 1   # Error

# PostToolUse hooks:
exit 0   # Success
exit 1   # Failure
```

---

## Examples

### Example 1: Auto-Format TypeScript After Edits

**Hook:** PostToolUse
**Matcher:** `Edit|Write`
**File:** `post-format-typescript.sh`

```bash
#!/bin/bash
# Auto-format TypeScript/JavaScript files with Prettier

# Get the file being edited from Claude Code environment
FILE="$CC_TOOL_INPUT_file_path"

# Only format TS/JS files
if [[ "$FILE" =~ \.(ts|tsx|js|jsx)$ ]]; then
  if command -v prettier &> /dev/null; then
    echo "✨ Formatting $FILE with Prettier..."
    prettier --write "$FILE"
    echo "✅ Formatted successfully"
  fi
fi

exit 0
```

### Example 2: Block Edits to package-lock.json

**Hook:** PreToolUse
**Matcher:** `Edit|Write`
**File:** `pre-block-lock-files.sh`

```bash
#!/bin/bash
# Block edits to lock files

FILE="$CC_TOOL_INPUT_file_path"

BLOCKED_FILES=(
  "package-lock.json"
  "yarn.lock"
  "pnpm-lock.yaml"
  "Gemfile.lock"
  "poetry.lock"
)

for blocked in "${BLOCKED_FILES[@]}"; do
  if [[ "$FILE" == *"$blocked"* ]]; then
    echo "🚫 Cannot edit $blocked"
    echo "These files are auto-generated. Edit package.json instead."
    exit 2  # Block operation
  fi
done

exit 0  # Allow operation
```

### Example 3: Auto-Update tests.json After Completion

**Hook:** PostToolUse
**Matcher:** `Edit|Write|Bash`
**File:** `post-update-tests.sh`

```bash
#!/bin/bash
# Auto-update tests.json when tasks complete

TESTS_JSON="tests.json"

if [ ! -f "$TESTS_JSON" ]; then
  exit 0  # Not using Long-Running Agents methodology
fi

# Check if Claude mentioned "completed" or "passing" in recent output
if echo "$CC_TOOL_OUTPUT" | grep -qiE "(completed|passing|fixed|implemented)"; then
  echo "📋 Task appears complete, updating tests.json..."

  # Ask Claude to update tests.json
  echo "Please update tests.json to mark completed tasks as passing."

  # Could also auto-update with jq if you want full automation:
  # jq '(.features[] | select(.passes == false) | .passes) = true' tests.json > tests.tmp.json
  # mv tests.tmp.json tests.json
fi

exit 0
```

### Example 4: Session Summary on Stop

**Hook:** Stop
**File:** `stop-generate-summary.sh`

```bash
#!/bin/bash
# Generate session summary when stopping Claude Code

PROGRESS_FILE="claude-progress.txt"

echo "📊 Generating session summary..."
echo "" >> "$PROGRESS_FILE"
echo "## Session Summary - $(date)" >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

# Files changed
echo "### Files Changed:" >> "$PROGRESS_FILE"
git diff --name-only >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

# Commits made
echo "### Commits Made:" >> "$PROGRESS_FILE"
git log --oneline -5 >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

echo "✅ Session summary added to $PROGRESS_FILE"
exit 0
```

---

## Troubleshooting

### Hook Not Running

**Check:**
1. Is the hook executable? `chmod +x your-hook.sh`
2. Is it configured in Claude Code? Run `/hooks` to verify
3. Does the tool matcher match? Test with `echo "$CC_TOOL_NAME"`
4. Check logs: `~/.claude/logs/hooks.log`

### Hook Failing

**Debug:**
```bash
# Add debug output at start of hook
echo "DEBUG: Hook started"
echo "DEBUG: Tool: $CC_TOOL_NAME"
echo "DEBUG: Input: $CC_TOOL_INPUT"
set -x  # Print all commands
```

### Hook Too Slow

**Solutions:**
- Run expensive operations in background: `npm test &`
- Use faster tools: `prettier` instead of full `npm run format`
- Cache results: Store file hashes, skip if unchanged
- Timeout protection: Use `timeout 5s command`

### Environment Variables Not Available

**Fix:**
```bash
# Source your environment at start of hook
source ~/.bashrc
# or
source .env
```

### Hook Works Locally But Not in Claude Code

**Common Issues:**
- Different PATH in hook environment
- Missing dependencies (npm packages, tools)
- Different working directory

**Fix:**
```bash
# Use absolute paths
/usr/local/bin/prettier --write "$FILE"

# Or add to PATH
export PATH="$HOME/.local/bin:$PATH"
```

---

## Advanced Patterns

### Pattern 1: Conditional Formatting

Only format files that changed:

```bash
#!/bin/bash
FILE="$CC_TOOL_INPUT_file_path"

# Check if file was actually modified
HASH_BEFORE=$(md5sum "$FILE" 2>/dev/null | cut -d' ' -f1)

# Only format if file exists and changed
if [ -f "$FILE" ]; then
  prettier --write "$FILE" 2>/dev/null

  HASH_AFTER=$(md5sum "$FILE" 2>/dev/null | cut -d' ' -f1)

  if [ "$HASH_BEFORE" != "$HASH_AFTER" ]; then
    echo "✨ Formatted $FILE"
  fi
fi

exit 0
```

### Pattern 2: Multi-Tool Formatting

Run different formatters based on file type:

```bash
#!/bin/bash
FILE="$CC_TOOL_INPUT_file_path"

case "$FILE" in
  *.ts|*.tsx|*.js|*.jsx)
    prettier --write "$FILE" && echo "✅ Prettier: $FILE"
    ;;
  *.py)
    black "$FILE" && echo "✅ Black: $FILE"
    ;;
  *.go)
    gofmt -w "$FILE" && echo "✅ gofmt: $FILE"
    ;;
  *.rs)
    rustfmt "$FILE" && echo "✅ rustfmt: $FILE"
    ;;
esac

exit 0
```

### Pattern 3: Notification Integration

Send notifications on completion:

```bash
#!/bin/bash
# Requires: .claude/tools/telegram-notifier

NOTIFIER=".claude/tools/telegram-notifier/telegram-notifier.js"

if [ -f "$NOTIFIER" ]; then
  MESSAGE="✅ Task completed: $CC_TOOL_NAME finished"
  node "$NOTIFIER" send "$MESSAGE" 2>/dev/null &
fi

exit 0
```

---

## Resources

- [Official Claude Code Hooks Documentation](https://code.claude.com/docs/en/hooks-guide)
- [Hook Examples Repository](https://github.com/disler/claude-code-hooks-mastery)
- [Long-Running Agents Methodology](../../../README.md)

---

## Contributing

Have a useful hook template? Submit a PR!

**Requirements:**
- Well-commented code
- Clear description of use case
- Error handling
- Works on macOS, Linux, and WSL
- Includes example configuration

---

**Built for Long-Running AI Agents** • **MIT Licensed** • **Community Driven**
