#!/bin/bash
# Pre-Git Safety Hook
# Blocks dangerous git operations to prevent accidents
#
# Hook Type: PreToolUse
# Tool Matcher: Bash
# Description: Prevents force pushes, dangerous resets, and protected file edits
#
# Installation:
#   1. Copy to ~/.claude/hooks/ or .claude/hooks/
#   2. chmod +x pre-git-safety.sh
#   3. Run /hooks in Claude Code and configure:
#      - Event: PreToolUse
#      - Matcher: Bash|Edit|Write
#      - Script: pre-git-safety.sh

set -e

# Get the command being run from Claude Code environment
COMMAND="${CC_TOOL_INPUT_command:-}"
FILE="${CC_TOOL_INPUT_file_path:-}"

# Protected branches (cannot force push to these)
PROTECTED_BRANCHES=("main" "master" "production" "prod")

# Protected files (cannot edit directly)
PROTECTED_FILES=(
  ".env"
  ".env.local"
  ".env.production"
  "package-lock.json"
  "yarn.lock"
  "pnpm-lock.yaml"
  "Gemfile.lock"
  "poetry.lock"
  "Cargo.lock"
  "composer.lock"
  ".git/config"
  ".git/HEAD"
)

# Protected directories (cannot edit files in these)
PROTECTED_DIRS=(
  ".git/"
  "node_modules/"
  "vendor/"
  "dist/"
  "build/"
)

# ============================================================================
# CHECK 1: Block edits to protected files
# ============================================================================

if [ -n "$FILE" ]; then
  # Check against protected files list
  for protected in "${PROTECTED_FILES[@]}"; do
    if [[ "$FILE" == *"$protected"* ]]; then
      echo "🚫 BLOCKED: Cannot edit $protected"
      echo ""
      echo "This file is auto-generated or contains sensitive data."
      echo ""

      case "$protected" in
        .env*|*/.env*)
          echo "💡 Suggestion: Edit .env.example instead, then copy values locally."
          ;;
        *lock*)
          echo "💡 Suggestion: Edit the dependency manifest file instead:"
          echo "   - package-lock.json → edit package.json"
          echo "   - yarn.lock → edit package.json"
          echo "   - Gemfile.lock → edit Gemfile"
          echo "   - poetry.lock → edit pyproject.toml"
          echo "   - Cargo.lock → edit Cargo.toml"
          echo "   - composer.lock → edit composer.json"
          ;;
        .git/*)
          echo "💡 Suggestion: Use git commands instead of editing .git/ directly."
          ;;
      esac

      exit 2  # Block the operation
    fi
  done

  # Check against protected directories
  for protected_dir in "${PROTECTED_DIRS[@]}"; do
    if [[ "$FILE" == *"$protected_dir"* ]]; then
      echo "🚫 BLOCKED: Cannot edit files in $protected_dir"
      echo ""
      echo "This directory contains auto-generated or system files."

      case "$protected_dir" in
        node_modules/|vendor/)
          echo "💡 Suggestion: Modify dependencies in package.json/composer.json instead."
          ;;
        dist/|build/)
          echo "💡 Suggestion: Edit source files, then rebuild."
          ;;
        .git/)
          echo "💡 Suggestion: Use git commands instead."
          ;;
      esac

      exit 2  # Block the operation
    fi
  done
fi

# ============================================================================
# CHECK 2: Block dangerous git commands
# ============================================================================

if [ -n "$COMMAND" ]; then

  # Check for force push to protected branches
  if echo "$COMMAND" | grep -qE "git push.*(-f|--force)"; then
    # Extract branch name if present
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

    for protected in "${PROTECTED_BRANCHES[@]}"; do
      if [[ "$BRANCH" == "$protected" ]] || echo "$COMMAND" | grep -q "$protected"; then
        echo "🚫 BLOCKED: Force push to $protected branch"
        echo ""
        echo "Force pushing to $protected can overwrite team members' work."
        echo ""
        echo "💡 Safer alternatives:"
        echo "   1. Create a new branch and PR:"
        echo "      git checkout -b fix/my-changes"
        echo "      git push origin fix/my-changes"
        echo ""
        echo "   2. Revert and push a new commit:"
        echo "      git revert <commit>"
        echo "      git push"
        echo ""
        echo "   3. If you're absolutely sure (NOT recommended):"
        echo "      git push --force-with-lease"
        echo ""
        exit 2  # Block the operation
      fi
    done
  fi

  # Check for hard reset to commits before current branch
  if echo "$COMMAND" | grep -qE "git reset --hard"; then
    echo "⚠️  WARNING: Hard reset detected"
    echo ""
    echo "Hard reset will permanently delete commits and changes."
    echo ""
    echo "💡 Safer alternatives:"
    echo "   1. Use soft reset to keep changes:"
    echo "      git reset --soft <commit>"
    echo ""
    echo "   2. Create a backup branch first:"
    echo "      git branch backup-$(date +%Y%m%d-%H%M%S)"
    echo "      git reset --hard <commit>"
    echo ""
    echo "   3. Use revert instead (preserves history):"
    echo "      git revert <commit>"
    echo ""
    echo "Type 'continue' if you want to proceed anyway:"

    # Note: In PreToolUse hooks, we can't easily get user input
    # So we block by default and let user manually run if needed
    echo ""
    echo "🚫 Blocking for safety. If you're sure, run the command manually."
    exit 2  # Block the operation
  fi

  # Check for destructive operations
  if echo "$COMMAND" | grep -qE "git (clean|filter-branch|reflog delete)"; then
    echo "🚫 BLOCKED: Destructive git operation detected"
    echo ""
    echo "This command can permanently delete data:"
    echo "  - git clean: Deletes untracked files"
    echo "  - git filter-branch: Rewrites history"
    echo "  - git reflog delete: Removes recovery points"
    echo ""
    echo "💡 Suggestion: Run these commands manually with caution."
    echo ""
    exit 2  # Block the operation
  fi

  # Check for amend on pushed commits
  if echo "$COMMAND" | grep -qE "git commit --amend"; then
    # Check if current branch has been pushed
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
    if [ -n "$CURRENT_BRANCH" ]; then
      # Check if branch exists on remote
      if git ls-remote --heads origin "$CURRENT_BRANCH" 2>/dev/null | grep -q "$CURRENT_BRANCH"; then
        # Check if there are unpushed commits
        UNPUSHED=$(git log origin/"$CURRENT_BRANCH"..HEAD --oneline 2>/dev/null | wc -l)
        if [ "$UNPUSHED" -eq 0 ]; then
          echo "⚠️  WARNING: Amending a pushed commit"
          echo ""
          echo "The current commit has already been pushed to remote."
          echo "Amending will require force push and can cause issues for others."
          echo ""
          echo "💡 Safer alternative:"
          echo "   Make a new commit instead:"
          echo "   git add ."
          echo "   git commit -m 'Fix: <description>'"
          echo ""
          echo "🚫 Blocking for safety. Create a new commit instead."
          exit 2  # Block the operation
        fi
      fi
    fi
  fi

  # Check for rebase on pushed branches
  if echo "$COMMAND" | grep -qE "git rebase"; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

    # Check if rebasing a protected branch
    for protected in "${PROTECTED_BRANCHES[@]}"; do
      if [[ "$CURRENT_BRANCH" == "$protected" ]]; then
        echo "🚫 BLOCKED: Cannot rebase $protected branch"
        echo ""
        echo "Rebasing $protected branch can cause issues for all team members."
        echo ""
        echo "💡 Suggestion:"
        echo "   Create a feature branch instead:"
        echo "   git checkout -b feature/my-changes"
        echo "   git rebase $protected"
        echo ""
        exit 2  # Block the operation
      fi
    done
  fi

fi

# All checks passed, allow operation
exit 0
