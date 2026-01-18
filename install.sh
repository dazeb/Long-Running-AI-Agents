#!/bin/bash

# ClaudePlaybook - Interactive Installer
# https://github.com/dazeb/ClaudePlaybook

VERSION="2.2.0"
REPO_URL="https://github.com/dazeb/ClaudePlaybook.git"
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
    echo "║           ClaudePlaybook - Marketplace Installer       ║"
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
        read -p "Enter choice [1-2]: " choice < /dev/tty

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

    if git clone --depth 1 "$REPO_URL" "$TEMP_DIR" > /dev/null 2>&1; then
        print_success "Downloaded successfully"
    else
        print_error "Failed to download repository"
        print_error "Please check your internet connection and try again"
        cleanup
        exit 1
    fi
    echo ""
}

# Show agent categories
show_categories() {
    echo "═══════════════════════════════════════════════════════"
    echo "  ClaudePlaybook - 20 Specialized Development Agents"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "  1) 🌐 Web Development (8 agents)"
    echo "     Next.js, APIs, Full-stack, Performance, PWAs,"
    echo "     CSS/Tailwind, Static Sites, Browser Automation"
    echo ""
    echo "  2) 🏗️  Engineering (6 agents)"
    echo "     Backend, Frontend, Mobile, AI/LLM, DevOps,"
    echo "     Project Initializer"
    echo ""
    echo "  3) 🧪 Testing & Quality (5 agents)"
    echo "     API Testing, Performance Benchmarking, Test Analysis,"
    echo "     Tool Evaluation, Workflow Optimization"
    echo ""
    echo "  4) 🏢 Studio Operations (1 agent)"
    echo "     Infrastructure Maintenance & Internal Tooling"
    echo ""
    echo "  5) ⭐ All Agents (20 agents)"
    echo "     Complete playbook - all categories"
    echo ""
    echo "  6) 🎯 Essentials (Recommended for starters)"
    echo "     Project Initializer + Web Development (9 agents)"
    echo ""
    echo "  0) Exit"
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo ""
}

# Install agents
install_category() {
    local category=$1
    local source_dir="$TEMP_DIR/agent"
    local dest_dir="$TARGET_DIR/$AGENTS_DIR"

    # Create target directory if it doesn't exist
    if ! mkdir -p "$dest_dir"; then
        print_error "Failed to create directory: $dest_dir"
        print_error "Please check permissions and try again"
        return 1
    fi

    case $category in
        1)
            print_info "Installing Web Development agents..."
            cp -r "$source_dir/web-development" "$dest_dir/"
            print_success "Installed 8 web development agents"
            ;;
        2)
            print_info "Installing Engineering agents..."
            cp -r "$source_dir/engineering" "$dest_dir/"
            print_success "Installed 6 engineering agents"
            ;;
        3)
            print_info "Installing Testing & Quality agents..."
            cp -r "$source_dir/testing" "$dest_dir/"
            print_success "Installed 5 testing & quality agents"
            ;;
        4)
            print_info "Installing Studio Operations agent..."
            cp -r "$source_dir/studio-operations" "$dest_dir/"
            print_success "Installed 1 studio operations agent"
            ;;
        5)
            print_info "Installing all agents..."
            cp -r "$source_dir/"* "$dest_dir/"
            print_success "Installed all 20 agents - complete playbook!"
            ;;
        6)
            print_info "Installing essentials (Project Initializer + Web Dev)..."
            mkdir -p "$dest_dir/engineering"
            cp "$source_dir/engineering/project-initializer.md" "$dest_dir/engineering/"
            cp -r "$source_dir/web-development" "$dest_dir/"
            print_success "Installed essentials: 9 agents (1 project init + 8 web dev)"
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
    echo "  1. Start with the Project Initializer to set up with long term memory:"
    echo "     @project-initializer, create a [your project description]"
    echo ""
    echo "  2. Use specialized agents for specific tasks and multi tasks:"
    echo "     @react-nextjs-specialist, build a login form"
    echo "     @api-integration-specialist, connect to Stripe API"
    echo ""
    echo "  3. View documentation:"
    echo "     cat $TARGET_DIR/$AGENTS_DIR/web-development/react-nextjs-specialist.md"
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "📚 Full docs: https://github.com/dazeb/ClaudePlaybook"
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
        read -p "Select category to install [0-6]: " choice < /dev/tty
        echo ""

        case $choice in
            0)
                print_info "Installation cancelled"
                cleanup
                exit 0
                ;;
            [1-6])
                install_category "$choice"
                read -p "Install another category? (y/n): " continue < /dev/tty
                if [[ ! $continue =~ ^[Yy]$ ]]; then
                    break
                fi
                echo ""
                ;;
            *)
                print_error "Invalid choice. Please select 0-6."
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
