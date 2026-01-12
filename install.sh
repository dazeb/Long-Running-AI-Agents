#!/bin/bash
set -e

# Claude AI Agents - Interactive Installer
# https://github.com/dazeb/Long-Running-AI-Agents

VERSION="2.2.0"
REPO_URL="https://github.com/dazeb/Long-Running-AI-Agents.git"
TEMP_DIR="/tmp/claude-agents-$$"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

# Print header
print_header() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║         Claude AI Agents - Marketplace Installer       ║"
    echo "║                   Version $VERSION                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
}

# Detect environment
detect_environment() {
    print_info "Detecting environment..."

    # Check for .claude directory
    if [ -d ".claude" ]; then
        ENV_TYPE="claude-code"
        TARGET_DIR=".claude"
        AGENTS_DIR="agents"
        print_success "Detected: Claude Code CLI"
    # Check for .opencode directory
    elif [ -d ".opencode" ]; then
        ENV_TYPE="opencode"
        TARGET_DIR=".opencode"
        AGENTS_DIR="agent"
        print_success "Detected: OpenCode"
    else
        print_info "No existing installation detected"
        echo ""
        echo "Which tool are you using?"
        echo "  1) Claude Code CLI (default)"
        echo "  2) OpenCode"
        echo ""
        read -p "Enter choice [1-2]: " choice

        case $choice in
            2)
                ENV_TYPE="opencode"
                TARGET_DIR=".opencode"
                AGENTS_DIR="agent"
                print_success "Selected: OpenCode"
                ;;
            *)
                ENV_TYPE="claude-code"
                TARGET_DIR=".claude"
                AGENTS_DIR="agents"
                print_success "Selected: Claude Code CLI"
                ;;
        esac
    fi
    echo ""
}

# Clone repository
clone_repo() {
    print_info "Downloading agents from GitHub..."

    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi

    git clone --depth 1 "$REPO_URL" "$TEMP_DIR" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        print_success "Downloaded successfully"
    else
        print_error "Failed to download repository"
        exit 1
    fi
    echo ""
}

# Show agent categories
show_categories() {
    echo "═══════════════════════════════════════════════════════"
    echo "  Available Agent Categories"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "  1) 🌐 Web Development (7 agents)"
    echo "     React, APIs, Performance, PWAs, CSS, Static Sites"
    echo ""
    echo "  2) 🏗️  Engineering (7 agents)"
    echo "     Backend, Frontend, Mobile, AI, DevOps, Prototyping"
    echo ""
    echo "  3) 🎨 Design (5 agents)"
    echo "     UI, UX, Branding, Visual, Animations"
    echo ""
    echo "  4) 📈 Marketing (7 agents)"
    echo "     Content, Growth, Social Media, ASO"
    echo ""
    echo "  5) 📦 Product & PM (6 agents)"
    echo "     Feedback, Prioritization, Experiments, Shipping"
    echo ""
    echo "  6) 🏢 Operations & Testing (11 agents)"
    echo "     Analytics, Testing, Finance, Support, Infrastructure"
    echo ""
    echo "  7) ⭐ All Agents (43 agents)"
    echo "     Install everything"
    echo ""
    echo "  8) 🎯 Essentials Only (Project Initializer + Web Dev)"
    echo "     Best for getting started"
    echo ""
    echo "  0) Exit"
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo ""
}

# Install agents
install_category() {
    local category=$1
    local source_dir="$TEMP_DIR/.claude/agents"
    local dest_dir="$TARGET_DIR/$AGENTS_DIR"

    # Create target directory if it doesn't exist
    mkdir -p "$dest_dir"

    case $category in
        1)
            print_info "Installing Web Development agents..."
            cp -r "$source_dir/web-development" "$dest_dir/"
            print_success "Installed 7 web development agents"
            ;;
        2)
            print_info "Installing Engineering agents..."
            cp -r "$source_dir/engineering" "$dest_dir/"
            print_success "Installed 7 engineering agents"
            ;;
        3)
            print_info "Installing Design agents..."
            cp -r "$source_dir/design" "$dest_dir/"
            print_success "Installed 5 design agents"
            ;;
        4)
            print_info "Installing Marketing agents..."
            cp -r "$source_dir/marketing" "$dest_dir/"
            print_success "Installed 7 marketing agents"
            ;;
        5)
            print_info "Installing Product & PM agents..."
            cp -r "$source_dir/product" "$dest_dir/"
            cp -r "$source_dir/project-management" "$dest_dir/"
            print_success "Installed 6 product & PM agents"
            ;;
        6)
            print_info "Installing Operations & Testing agents..."
            cp -r "$source_dir/studio-operations" "$dest_dir/"
            cp -r "$source_dir/testing" "$dest_dir/"
            print_success "Installed 11 operations & testing agents"
            ;;
        7)
            print_info "Installing all agents..."
            cp -r "$source_dir/"* "$dest_dir/"
            print_success "Installed all 43 agents"
            ;;
        8)
            print_info "Installing essentials (Project Initializer + Web Dev)..."
            mkdir -p "$dest_dir/engineering"
            cp "$source_dir/engineering/project-initializer.md" "$dest_dir/engineering/"
            cp -r "$source_dir/web-development" "$dest_dir/"
            print_success "Installed Project Initializer + 7 web development agents"
            ;;
    esac

    echo ""
}

# Show next steps
show_next_steps() {
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  ✓ Installation Complete!"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    print_success "Agents installed to: $TARGET_DIR/$AGENTS_DIR/"
    echo ""
    echo "🚀 Next Steps:"
    echo ""
    echo "  1. Start with the Project Initializer (IMPORTANT!):"
    echo "     @project-initializer, create a [your project description]"
    echo ""
    echo "  2. Use specialized agents for specific tasks:"
    echo "     @react-nextjs-specialist, build a login form"
    echo "     @api-integration-specialist, connect to Stripe API"
    echo ""
    echo "  3. View documentation:"
    echo "     cat $TARGET_DIR/$AGENTS_DIR/web-development/react-nextjs-specialist.md"
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "📚 Full docs: https://github.com/dazeb/Long-Running-AI-Agents"
    echo ""
}

# Cleanup
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

# Main installation flow
main() {
    print_header
    detect_environment
    clone_repo

    while true; do
        show_categories
        read -p "Select category to install [0-8]: " choice
        echo ""

        case $choice in
            0)
                print_info "Installation cancelled"
                cleanup
                exit 0
                ;;
            [1-8])
                install_category "$choice"
                read -p "Install another category? (y/n): " continue
                if [[ ! $continue =~ ^[Yy]$ ]]; then
                    break
                fi
                echo ""
                ;;
            *)
                print_error "Invalid choice. Please select 0-8."
                echo ""
                ;;
        esac
    done

    cleanup
    show_next_steps
}

# Run installer
trap cleanup EXIT
main
