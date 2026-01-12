#!/bin/bash
# Post-Edit Format Hook
# Automatically formats code after Edit or Write tool usage
#
# Hook Type: PostToolUse
# Tool Matcher: Edit|Write
# Description: Runs appropriate formatter based on file type
#
# Installation:
#   1. Copy to ~/.claude/hooks/ or .claude/hooks/
#   2. chmod +x post-edit-format.sh
#   3. Run /hooks in Claude Code and configure:
#      - Event: PostToolUse
#      - Matcher: Edit|Write
#      - Script: post-edit-format.sh

set -e

# Get file path from Claude Code environment
FILE="${CC_TOOL_INPUT_file_path:-}"

# Exit if no file specified
if [ -z "$FILE" ]; then
  exit 0
fi

# Exit if file doesn't exist
if [ ! -f "$FILE" ]; then
  exit 0
fi

# Track if we formatted anything
FORMATTED=false

# Detect file type and run appropriate formatter
case "$FILE" in
  # JavaScript/TypeScript - Use Prettier
  *.js|*.jsx|*.ts|*.tsx|*.mjs|*.cjs)
    if command -v prettier &> /dev/null; then
      echo "✨ Formatting JavaScript/TypeScript with Prettier..."
      if prettier --write "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      else
        echo "⚠️  Prettier formatting failed (file may have syntax errors)"
      fi
    else
      echo "ℹ️  Prettier not found. Install: npm install -g prettier"
    fi
    ;;

  # Python - Use Black
  *.py)
    if command -v black &> /dev/null; then
      echo "✨ Formatting Python with Black..."
      if black "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      else
        echo "⚠️  Black formatting failed (file may have syntax errors)"
      fi
    elif command -v autopep8 &> /dev/null; then
      echo "✨ Formatting Python with autopep8..."
      if autopep8 --in-place "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    else
      echo "ℹ️  Black not found. Install: pip install black"
    fi
    ;;

  # Go - Use gofmt
  *.go)
    if command -v gofmt &> /dev/null; then
      echo "✨ Formatting Go with gofmt..."
      if gofmt -w "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    else
      echo "ℹ️  gofmt not found (should come with Go installation)"
    fi
    ;;

  # Rust - Use rustfmt
  *.rs)
    if command -v rustfmt &> /dev/null; then
      echo "✨ Formatting Rust with rustfmt..."
      if rustfmt "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    else
      echo "ℹ️  rustfmt not found. Install: rustup component add rustfmt"
    fi
    ;;

  # Ruby - Use rubocop
  *.rb)
    if command -v rubocop &> /dev/null; then
      echo "✨ Formatting Ruby with rubocop..."
      if rubocop --auto-correct "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    else
      echo "ℹ️  rubocop not found. Install: gem install rubocop"
    fi
    ;;

  # PHP - Use php-cs-fixer
  *.php)
    if command -v php-cs-fixer &> /dev/null; then
      echo "✨ Formatting PHP with php-cs-fixer..."
      if php-cs-fixer fix "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    else
      echo "ℹ️  php-cs-fixer not found"
    fi
    ;;

  # Java - Use google-java-format
  *.java)
    if command -v google-java-format &> /dev/null; then
      echo "✨ Formatting Java with google-java-format..."
      if google-java-format --replace "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    else
      echo "ℹ️  google-java-format not found"
    fi
    ;;

  # C/C++ - Use clang-format
  *.c|*.cpp|*.cc|*.cxx|*.h|*.hpp)
    if command -v clang-format &> /dev/null; then
      echo "✨ Formatting C/C++ with clang-format..."
      if clang-format -i "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    else
      echo "ℹ️  clang-format not found"
    fi
    ;;

  # CSS/SCSS/Less - Use Prettier
  *.css|*.scss|*.sass|*.less)
    if command -v prettier &> /dev/null; then
      echo "✨ Formatting CSS with Prettier..."
      if prettier --write "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    fi
    ;;

  # HTML - Use Prettier
  *.html|*.htm)
    if command -v prettier &> /dev/null; then
      echo "✨ Formatting HTML with Prettier..."
      if prettier --write "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    fi
    ;;

  # JSON - Use Prettier or jq
  *.json)
    if command -v prettier &> /dev/null; then
      echo "✨ Formatting JSON with Prettier..."
      if prettier --write "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    elif command -v jq &> /dev/null; then
      echo "✨ Formatting JSON with jq..."
      TMP=$(mktemp)
      if jq . "$FILE" > "$TMP" 2>/dev/null; then
        mv "$TMP" "$FILE"
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    fi
    ;;

  # Markdown - Use Prettier
  *.md|*.markdown)
    if command -v prettier &> /dev/null; then
      echo "✨ Formatting Markdown with Prettier..."
      if prettier --write "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    fi
    ;;

  # YAML - Use Prettier
  *.yml|*.yaml)
    if command -v prettier &> /dev/null; then
      echo "✨ Formatting YAML with Prettier..."
      if prettier --write "$FILE" 2>/dev/null; then
        echo "✅ Formatted: $FILE"
        FORMATTED=true
      fi
    fi
    ;;

  *)
    # Unknown file type, exit silently
    exit 0
    ;;
esac

# If nothing was formatted, don't output anything
if [ "$FORMATTED" = false ]; then
  exit 0
fi

# Show brief summary
echo ""
echo "📝 Auto-formatting complete. Changes applied to: $FILE"

exit 0
