# 🏪 Claude AI Agents Marketplace

**Easy installation of specialized AI agents for Claude Code and OpenCode**

---

## ⚡ Quick Install

### Method 1: Official Plugin Marketplace (Best)

**Using Claude Code's built-in plugin system:**

```bash
# Add marketplace to Claude Code
/plugin marketplace add https://github.com/dazeb/Long-Running-AI-Agents

# Install by category
/plugin install web-development-agents@long-running-ai-agents
/plugin install engineering-agents@long-running-ai-agents
/plugin install design-agents@long-running-ai-agents

# Or install essentials bundle (recommended for starters)
/plugin install essentials-bundle@long-running-ai-agents

# Browse all available plugins
/plugin > Discover
```

**Benefits:**
- ✅ Native Claude Code integration
- ✅ Automatic updates
- ✅ Version management
- ✅ Browse and discover in UI
- ✅ No manual file management

### Method 2: CLI Installer

```bash
curl -fsSL https://raw.githubusercontent.com/dazeb/Long-Running-AI-Agents/main/install.sh | bash
```

This interactive installer will:
- ✅ Auto-detect your environment (Claude Code or OpenCode)
- ✅ Let you choose which agent categories to install
- ✅ Set up the correct folder structure automatically
- ✅ Show you how to use the agents

---

## 📦 Installation Methods

### Method 1: Interactive Installer (Linux/Mac)

**For Claude Code:**
```bash
# Download and run installer
curl -fsSL https://raw.githubusercontent.com/dazeb/Long-Running-AI-Agents/main/install.sh | bash

# Or download first, then run
curl -fsSL https://raw.githubusercontent.com/dazeb/Long-Running-AI-Agents/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

**For OpenCode:**
```bash
# Same installer, it will auto-detect or ask which tool you're using
curl -fsSL https://raw.githubusercontent.com/dazeb/Long-Running-AI-Agents/main/install.sh | bash
```

### Method 2: Manual Installation

**Claude Code:**
```bash
git clone https://github.com/dazeb/Long-Running-AI-Agents.git .claude
```

**OpenCode:**
```bash
git clone https://github.com/dazeb/Long-Running-AI-Agents.git
mv Long-Running-AI-Agents/.claude .opencode
mv .opencode/agents .opencode/agent
rm -rf Long-Running-AI-Agents
```

### Method 3: Git Submodule (For version control)

```bash
# Add as submodule
git submodule add https://github.com/dazeb/Long-Running-AI-Agents.git .claude

# Update to latest
git submodule update --remote .claude
```

---

## 🎯 Agent Categories

### 🌐 Web Development (7 agents)
Perfect for modern web development with React, Next.js, and more.

**Agents:**
- React/Next.js Specialist
- API Integration Specialist
- Full-Stack Developer
- Web Performance Optimizer
- PWA Builder
- CSS & Tailwind Expert
- Static Site Specialist

**Install only Web Development:**
```bash
# Using installer
./install.sh
# Select option: 1

# Or manually
git clone --depth 1 --filter=blob:none --sparse \
  https://github.com/dazeb/Long-Running-AI-Agents.git .claude
cd .claude
git sparse-checkout set agents/web-development
```

### 🏗️ Engineering (7 agents)
Core development agents for backend, frontend, mobile, and more.

**Agents:**
- **Project Initializer** ⭐ START HERE
- AI Engineer
- Backend Architect
- DevOps Automator
- Frontend Developer
- Mobile App Builder
- Rapid Prototyper

**Install only Engineering:**
```bash
./install.sh
# Select option: 2
```

### 🎨 Design (5 agents)
For UI/UX design, branding, and visual work.

**Agents:**
- Brand Guardian
- UI Designer
- UX Researcher
- Visual Storyteller
- Whimsy Injector

### 📈 Marketing (7 agents)
Content creation, growth, and social media.

**Agents:**
- Content Creator
- Growth Hacker
- ASO Specialist
- Instagram Curator
- Reddit Builder
- TikTok Strategist
- Twitter Engager

### 📦 Product & PM (6 agents)
Product management and prioritization.

**Agents:**
- Feedback Synthesizer
- Sprint Prioritizer
- Trend Researcher
- Experiment Tracker
- Project Shipper
- Studio Producer

### 🏢 Operations & Testing (11 agents)
Testing, analytics, finance, and operations.

**Agents:**
- Analytics Reporter
- Finance Tracker
- Infrastructure Maintainer
- Legal & Compliance
- Support Responder
- API Tester
- Performance Benchmarker
- Test Results Analyzer
- Tool Evaluator
- Workflow Optimizer

---

## 🎯 Pre-configured Bundles

### Essentials Bundle (Recommended for starters)
**What's included:** Project Initializer + Web Development agents (8 total)

**Why this bundle:**
- Project Initializer gives Claude long-term memory
- Web Development covers most common tasks
- Only 8 agents instead of all 43

**Install:**
```bash
./install.sh
# Select option: 8 (Essentials Only)
```

### Full Suite (All 43 agents)
**Install everything:**
```bash
./install.sh
# Select option: 7 (All Agents)
```

---

## 🔄 Updating Agents

### Update with Installer
```bash
# Re-run installer and select categories
curl -fsSL https://raw.githubusercontent.com/dazeb/Long-Running-AI-Agents/main/install.sh | bash
```

### Update Manually
```bash
# For Claude Code
cd .claude
git pull origin main

# For OpenCode
cd .opencode
git pull origin main
mv agents agent  # If needed
```

### Update Git Submodule
```bash
git submodule update --remote .claude
git commit -am "Update Claude agents to latest version"
```

---

## 📊 What Gets Installed?

### Directory Structure

**Claude Code:**
```
your-project/
├── .claude/
│   └── agents/
│       ├── web-development/
│       ├── engineering/
│       ├── design/
│       ├── marketing/
│       ├── product/
│       ├── project-management/
│       ├── studio-operations/
│       └── testing/
```

**OpenCode:**
```
your-project/
├── .opencode/
│   └── agent/
│       ├── web-development/
│       ├── engineering/
│       └── ... (same structure)
```

---

## 🚀 Quick Start After Installation

### Step 1: Start with Project Initializer (CRITICAL!)

```bash
# In Claude Code or OpenCode, say:
@project-initializer, create a Next.js e-commerce app with authentication,
product catalog, shopping cart, and Stripe integration. Use PostgreSQL.
```

The Project Initializer creates:
- `tests.json` - Feature roadmap and tracking
- `init.sh` - One-command environment setup
- `claude-progress.txt` - Long-term memory across sessions

### Step 2: Use Specialized Agents

```bash
# Frontend work
@react-nextjs-specialist, build a responsive navbar with mobile menu

# API integration
@api-integration-specialist, connect to Stripe API with error handling

# Performance issues
@web-performance-optimizer, improve my Lighthouse score to 95+

# Styling
@css-tailwind-expert, create a design system with dark mode
```

### Step 3: Verify Installation

**Check installed agents:**
```bash
# Claude Code
ls .claude/agents/

# OpenCode
ls .opencode/agent/
```

**Read an agent:**
```bash
# Claude Code
cat .claude/agents/web-development/react-nextjs-specialist.md

# OpenCode
cat .opencode/agent/web-development/react-nextjs-specialist.md
```

---

## 💡 Installation Tips

### Tip 1: Start Small
Don't install all 43 agents at once. Start with:
- **Project Initializer** (essential)
- **Web Development** (if doing web work)
- Add more categories as needed

### Tip 2: Use Git Submodules for Teams
If working in a team, use git submodules so everyone has the same agent versions:
```bash
git submodule add https://github.com/dazeb/Long-Running-AI-Agents.git .claude
git commit -m "Add Claude AI Agents"
```

### Tip 3: Keep Agents Updated
Check for updates monthly:
```bash
cd .claude && git pull origin main
```

### Tip 4: Customize for Your Team
Fork the repository and customize agents for your stack:
```bash
git clone https://github.com/dazeb/Long-Running-AI-Agents.git my-custom-agents
# Edit agents to match your needs
# Install from your fork
```

---

## 🔧 Troubleshooting

### Issue: "command not found: curl"
**Solution:** Install curl or use git clone:
```bash
git clone https://github.com/dazeb/Long-Running-AI-Agents.git .claude
```

### Issue: Agents not showing up in Claude Code
**Solution:** Make sure the directory structure is correct:
```bash
ls .claude/agents/  # Should show folders
```

### Issue: OpenCode can't find agents
**Solution:** Verify folder names are correct:
- Should be `.opencode/agent/` (singular "agent", not "agents")
- Run the installer again and select "OpenCode"

### Issue: Permission denied running installer
**Solution:** Make it executable:
```bash
chmod +x install.sh
./install.sh
```

---

## 🌐 Web-Based Marketplace (Coming Soon)

We're building a web interface where you can:
- Browse all agents with previews
- Search by keywords
- Filter by category
- Copy installation commands
- See agent ratings and downloads

**Preview URL:** https://dazeb.github.io/Long-Running-AI-Agents/marketplace

---

## 📱 Marketplace Features

### Current Features
✅ Interactive CLI installer
✅ Category-based installation
✅ Auto-detection of environment
✅ Multiple installation methods
✅ Pre-configured bundles
✅ Version control support

### Coming Soon
🔄 Web-based marketplace UI
🔄 Individual agent installation
🔄 Agent search and filtering
🔄 Version management
🔄 Community-contributed agents
🔄 Agent analytics (downloads, ratings)

---

## 🤝 Contributing Agents to Marketplace

Want to add your own agents to the marketplace?

1. Fork the repository
2. Create your agent in the appropriate category
3. Follow the agent template structure
4. Submit a pull request
5. Once approved, your agent will be in the marketplace!

**Agent template:** See any existing agent for the structure (Profile, Capabilities, Tools, Examples, Anti-patterns, etc.)

---

## 📊 Marketplace Statistics

**Current Agents:** 43
**Categories:** 7
**Lines of Expert Guidance:** ~5,200
**Downloads:** [Coming Soon]
**Stars:** Check GitHub repo

---

## 💬 Support

**Documentation:** https://github.com/dazeb/Long-Running-AI-Agents
**Issues:** https://github.com/dazeb/Long-Running-AI-Agents/issues
**Discussions:** https://github.com/dazeb/Long-Running-AI-Agents/discussions

---

**Built by developers, for developers** • **MIT Licensed** • **43 Specialized Agents**
