<div align="center">

# ClaudePlaybook

**Your comprehensive playbook of systematic AI agents. Using Anthropic's Official methodology, we provide ready-to-use agent templates with complete workflows that make Claude smarter at specific development tasks.**

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![21 Agents](https://img.shields.io/badge/Agents-21-blue.svg)]()
[![100% Workflows](https://img.shields.io/badge/Workflows-21/21_Complete-brightgreen.svg)]()
[![17 Skills](https://img.shields.io/badge/Skills-17-brightgreen.svg)](.claude/skills/README.md)
[![Works with Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-blue.svg)]()
[![Works with OpenCode](https://img.shields.io/badge/OpenCode-Compatible-orange.svg)]()
[![Hooks](https://img.shields.io/badge/Hooks-4_Templates-purple.svg)]()
[![MCP](https://img.shields.io/badge/MCP-15+_Servers-orange.svg)]()
[![LSP](https://img.shields.io/badge/LSP-11_Languages-green.svg)]()

</div>

---

## Quick Start (60 seconds)

**What is this?** A collection of specialized "expert personas" that make Claude better at specific development tasks.

**Works with:** Claude Code CLI, OpenCode, Claude Web/Desktop

**How does it work?**
1. Clone this repo into your project
2. Reference an agent when talking to Claude (e.g., `@frontend-developer`)
3. Claude now has deep expertise in that domain

📋 **[View Complete Feature List →](docs/FEATURES.md)** | 📚 **[Marketplace Docs](docs/guides/MARKETPLACE.md)** | 🪝 **[Hooks Guide](.claude/hooks/README.md)** | 🔌 **[MCP Guide](docs/guides/MCP_INTEGRATION.md)** | ⚡ **[LSP Guide](docs/guides/LSP_SETUP.md)**

**Try it now:**

### Option A: Plugin Marketplace (Best - Official Integration)
```bash
# Add the marketplace to Claude Code
/plugin marketplace add https://github.com/dazeb/ClaudePlaybook

# Install specific category
/plugin install web-development-agents@claude-playbook
/plugin install engineering-agents@claude-playbook

# Or install the essentials bundle (recommended for starters)
/plugin install essentials-bundle@claude-playbook

# Browse all available plugins
/plugin > Discover
```

### Option B: CLI Installer (Quick & Easy)
```bash
curl -fsSL https://raw.githubusercontent.com/dazeb/ClaudePlaybook/main/install.sh | bash
```
Interactive installer lets you choose which agents to install.

📚 **[View Full Marketplace Documentation →](docs/guides/MARKETPLACE.md)**

### Option C: Manual Install
```bash
# Clone into your project
git clone https://github.com/dazeb/ClaudePlaybook.git .claude
```
```
# Use an agent
# Just say: "@frontend-developer, build me a responsive navbar"
```
That's it! Claude will now respond with frontend-specific best practices, modern tools, and avoid common pitfalls.

### Latest Updates
- **NEW**: Vercel Skills Integration - Added 3 frontend/performance skills from vercel-labs/agent-skills (react-best-practices, web-design-guidelines, vercel-deploy)
- **NEW**: 100% Complete Agentic System - All 20 agents now have comprehensive Anthropic-style workflows (6-9 numbered steps with decision points, loops, verification gates)
- **NEW**: Complete workflow coverage across all categories:
  - Engineering (6/6) - Backend, frontend, mobile, AI/LLM, DevOps, project init
  - Web Development (9/9) - React/Next.js, APIs, full-stack, performance, PWA, CSS, Tailwind v4, static sites, browser automation
  - Testing & Quality (5/5) - API testing, performance benchmarking, test analysis, tool evaluation, workflow optimization
  - Operations (1/1) - Infrastructure maintenance
- **NEW**: Latest technology versions across all agents (React 19, Next.js 15, Tailwind 4, React Native 0.76+, Flutter 3.27+, Llama 3.3)
- **NEW**: Skills integration throughout workflows (TDD, systematic debugging, brainstorming, verification)
- **NEW**: Delegation triggers for parallel agent execution across all agents
- [Major overhaul to specialized set of agents](https://github.com/dazeb/ClaudePlaybook/pull/20/changes/531fdbf8d54e62d8585211f394c95c2ef8e71228)

---

## Skills & Hooks

### 17 Composable Skills

Specialized workflows that make agents systematic and quality-focused. Skills are automatically available to all agents.

#### Development Skills
- **test-driven-development** - RED-GREEN-REFACTOR cycle for bulletproof code
- **systematic-debugging** - Four-phase root cause analysis (gather, analyze, fix, verify)
- **verification-before-completion** - Never claim done without running verification
- **brainstorming** - Requirements exploration before implementation
- **writing-plans** - Break complex tasks into actionable steps
- **executing-plans** - Execute multi-step plans with review checkpoints

#### Frontend & Performance (NEW!)
- **react-best-practices** - 45 performance rules from Vercel Engineering
- **web-design-guidelines** - 100+ accessibility and UX compliance rules
- **vercel-deploy** - Instant deployment with auto-framework detection

#### Collaboration Skills
- **requesting-code-review** - Systematic review requests with context
- **receiving-code-review** - Handle feedback with technical rigor
- **dispatching-parallel-agents** - Coordinate multiple agents on independent tasks
- **subagent-driven-development** - Execute implementation plans in current session

#### Workflow Skills
- **using-git-worktrees** - Isolated git worktrees for feature work
- **finishing-a-development-branch** - Structured options for merge/PR/cleanup

#### Meta Skills
- **using-superpowers** - Introduction to the skills system
- **writing-skills** - Create new skills with proper structure

**[View Complete Skills Documentation](.claude/skills/README.md)**

### 4 Hook Templates

Automate workflows that run in response to events (editing files, git operations, session end):

- **post-edit-format.sh** - Auto-format 12+ languages after every file edit
- **pre-git-safety.sh** - Block dangerous git operations (force push, protected files)
- **stop-session-summary.sh** - Generate session reports with statistics
- **post-tests-update.sh** - Auto-update tests.json after test runs

**[View Hooks Documentation](.claude/hooks/README.md)**

---

<details>
<summary><strong>AI Setup</strong></summary>

> **Copy this WHOLE section and paste it into your AI agent's context and your AI will do the rest.**

````

### AI Agent Setup Instructions

You are being equipped with specialized agent capabilities from the ClaudePlaybook repository.

#### Installation Steps

1. **Clone the repository into the project's `.claude` directory:**
   ```bash
   git clone https://github.com/dazeb/ClaudePlaybook.git .claude
   ```

2. **Verify installation:**
   ```bash
   ls .claude/agents/
   ```
   You should see directories for: engineering, web-development, testing, and studio-operations.

3. **You now have access to 21 specialized development agents.** Reference them using the `@agent-name` syntax.

#### How to Use Agents

When the user requests a task that matches an agent's expertise:

1. **Identify the appropriate agent** from these categories:

   **Engineering (6 agents):**
   - `@project-initializer` - Start here for new projects (sets up long-term memory)
   - `@backend-architect` - APIs, databases, server-side architecture
   - `@frontend-developer` - UI development with React/Vue/Svelte
   - `@ai-engineer` - LLM integration, RAG systems, AI features
   - `@devops-automator` - CI/CD, Docker, deployments
   - `@mobile-app-builder` - React Native, Flutter apps

   **Web Development (9 agents):**
   - `@react-nextjs-specialist` - Next.js apps, Server Components, App Router
   - `@api-integration-specialist` - REST/GraphQL APIs, auth flows
   - `@fullstack-web-developer` - Complete apps from database to UI
   - `@web-performance-optimizer` - Site optimization, Core Web Vitals
   - `@pwa-builder` - Progressive Web Apps, offline functionality
   - `@css-tailwind-expert` - Advanced styling, design systems
   - `@tailwind-v4-specialist` - Tailwind CSS v4 CSS-first config, @theme, migration
   - `@static-site-specialist` - Astro, 11ty, Hugo sites
   - `@browser-automation-specialist` - E2E testing, web scraping

   **Testing & Quality (5 agents):**
   - `@api-tester` - API testing and contract validation
   - `@performance-benchmarker` - Load testing, optimization
   - `@test-results-analyzer` - Test quality analysis
   - `@tool-evaluator` - Build vs. buy decisions
   - `@workflow-optimizer` - Developer workflow improvements

   **Operations (1 agent):**
   - `@infrastructure-maintainer` - System maintenance, internal tools

2. **Activate the agent** by reading its file:
   ```bash
   cat .claude/agents/[category]/[agent-name].md
   ```

3. **Apply the agent's expertise** to the task:
   - Follow the agent's best practices
   - Use recommended tools and technologies
   - Avoid documented anti-patterns
   - Apply systematic skills (TDD, debugging protocols, verification)

#### Project Initialization

**For new projects, start with the Project Initializer:**
```bash
cat .claude/agents/engineering/project-initializer.md
```

It will guide you to create:
- `tests.json` - Feature tracking and completion status
- `init.sh` - Environment setup automation
- `claude-progress.txt` - Session memory and decisions
- Project structure and configurations

These files enable long-term memory across sessions.

#### Agent Discovery

To see all available agents:
```bash
find .claude/agents -name "*.md" -type f
```

To search for agents by capability:
```bash
grep -r "Use When" .claude/agents/
```

#### Example Workflow

User request: "Build a Next.js e-commerce site with Stripe integration"

Your response:
1. Activate `@project-initializer` - Set up project structure
2. Activate `@react-nextjs-specialist` - Build Next.js app
3. Activate `@api-integration-specialist` - Integrate Stripe API
4. Activate `@api-tester` - Test payment endpoints
5. Apply systematic skills throughout (TDD, verification, code review)

#### Skills System

You also have access to 17 composable skills in `.claude/skills/`:
- `test-driven-development.md` - RED-GREEN-REFACTOR workflow
- `systematic-debugging.md` - Four-phase root cause analysis
- `verification-before-completion.md` - Always verify before claiming done
- `brainstorming.md` - Requirements exploration
- `writing-plans.md` - Implementation planning
- `react-best-practices/` - 45 performance rules from Vercel Engineering
- `web-design-guidelines/` - 100+ accessibility and UX compliance rules
- `vercel-deploy/` - Instant deployment to Vercel
- And 9 more systematic development workflows

Read and apply these skills to ensure high-quality, systematic development.

#### Repository Information

- **Source:** https://github.com/dazeb/ClaudePlaybook
- **21 Focused Development Agents** across 4 categories
- **17 Composable Skills** for systematic development
- **MIT Licensed**

````


</details>

<details>
<summary><strong>Start Every Project Right</strong></summary>

**We recommend starting with the [Project Initializer](.claude/agents/engineering/project-initializer.md) agent for new projects.**

The Project Initializer sets up essential infrastructure that gives Claude long-term memory:
- **`tests.json`** - Tracks all features and their completion status
- **`init.sh`** - One-command environment setup
- **`claude-progress.txt`** - Remembers decisions across sessions
- **Project structure** - Organized files and configs

**Without these files:** Claude forgets context after long conversations and has to restart from scratch.

**With these files:** Claude remembers everything, even across multiple days or weeks. Each new session picks up exactly where you left off.

**Start your project:**
```bash
# In your project directory, say:
"@project-initializer, create a Next.js e-commerce app with authentication,
product catalog, shopping cart, and admin dashboard. Use PostgreSQL and Stripe."
```

The Project Initializer will create your entire project structure, roadmap, and tracking files in minutes.

</details>

<details>
<summary><strong>What You Get</strong></summary>

**21 focused development agents - ALL with comprehensive Anthropic-style workflows**

- **Web Development** (9 agents) - React 19, Next.js 15, APIs, CSS/Tailwind 4, Tailwind v4 specialist, PWAs, performance, full-stack, static sites, browser automation
- **Engineering** (6 agents) - Backend, frontend, mobile (React Native 0.76+, Flutter 3.27+), AI/LLM (Llama 3.3, Claude 3.5), DevOps, project initialization
- **Testing & Quality** (5 agents) - API testing, performance benchmarking, test analysis, tool evaluation, workflow optimization
- **Operations** (1 agent) - Infrastructure maintenance and internal tooling

**Every single agent includes complete workflows with:**
- Numbered workflow steps (6-9 steps) - Clear, actionable phases from start to finish
- Decision points (→) - Branching logic adapting to your requirements
- Loop conditions (↻) - Iterative improvement cycles for quality
- Verification gates (✓) - Quality checkpoints before proceeding
- Human-in-the-loop approval - Critical decision points requiring review
- Skills integration - TDD, systematic debugging, verification protocols
- Collaboration triggers - Smart delegation to spawn parallel agents
- Latest technology versions - Updated to 2025/2026 standards

**This is a truly agentic system** - Every agent knows exactly how to work systematically, when to delegate, and how to ensure quality at every step.

**PLUS: 17 composable skills** for systematic, quality-focused development:

- **Development** - TDD, systematic debugging, verification protocols
- **Frontend & Performance** - React/Next.js optimization, web design guidelines, Vercel deployment
- **Planning** - Brainstorming, plan writing, execution workflows
- **Collaboration** - Parallel agents, code review, multi-stage review
- **Workflow** - Git worktrees, branch management
- **Meta** - Skills creation, usage guides

Each agent knows:
- The right tools for the job
- Best practices and patterns
- Common mistakes to avoid
- When to use them vs. other approaches
- How to apply systematic skills for quality code

</details>

<details>
<summary><strong>Why Use These Agents?</strong></summary>

**Without agents:**
```
You: "Build me a login form"
Claude: Creates basic form with inline styles and no validation
```

**With agents:**
```
You: "@react-nextjs-specialist, build me a login form"
Claude: Creates form with:
  - React Hook Form for validation
  - Zod schema for type safety
  - Server Actions for authentication
  - Loading states and error handling
  - Accessibility (ARIA labels, keyboard nav)
  - Responsive design
```

Agents turn general AI into domain experts.

</details>

<details>
<summary><strong>Claude Code 2.1 Features (NEW!)</strong></summary>

Leverage the latest Claude Code capabilities:

### Hooks - Automated Workflows
Auto-format code, block dangerous git operations, generate session summaries:
- **post-edit-format.sh** - Auto-formats 12+ languages after every edit
- **pre-git-safety.sh** - Blocks force pushes, protected file edits
- **stop-session-summary.sh** - Session reports with stats
- **post-tests-update.sh** - Auto-updates tests.json

**[View Hooks Documentation](.claude/hooks/README.md)**

### MCP - External Tool Integration
Connect to 15+ services for live data:
- **GitHub** - PRs, issues, code review
- **Perplexity** - Real-time web research
- **PostgreSQL** - Database queries
- **Slack** - Team notifications
- **And 11 more...**

**[View MCP Integration Guide](docs/guides/MCP_INTEGRATION.md)**

### LSP - 900x Faster Code Navigation
IDE-like intelligence for 11 languages. Go-to-definition in **50ms** (vs 45 seconds):
- TypeScript/JavaScript, Python, Go, Rust, Java, C/C++, C#, PHP, Ruby, Kotlin, HTML/CSS

**[View LSP Setup Guide](docs/guides/LSP_SETUP.md)**

</details>

<details>
<summary><strong>Browse Agents</strong></summary>

### Web Development (9 agents)
| Agent | Use When |
|-------|----------|
| [React/Next.js Specialist](.claude/agents/web-development/react-nextjs-specialist.md) | Building Next.js apps, Server Components, App Router |
| [API Integration Specialist](.claude/agents/web-development/api-integration-specialist.md) | Connecting to REST/GraphQL APIs, auth flows |
| [Full-Stack Developer](.claude/agents/web-development/fullstack-web-developer.md) | Building complete apps from database to UI |
| [Web Performance Optimizer](.claude/agents/web-development/web-performance-optimizer.md) | Fixing slow sites, improving Core Web Vitals |
| [PWA Builder](.claude/agents/web-development/pwa-builder.md) | Making apps installable and work offline |
| [CSS & Tailwind Expert](.claude/agents/web-development/css-tailwind-expert.md) | Advanced styling, animations, design systems |
| [Tailwind v4 Specialist](agent/web-development/tailwind-v4-specialist.md) | Tailwind CSS v4 setup, @theme tokens, v3 migration, CSS-first config |
| [Static Site Specialist](.claude/agents/web-development/static-site-specialist.md) | Building fast sites with Astro, 11ty, Hugo |
| [Browser Automation Specialist](.claude/agents/web-development/browser-automation-specialist.md) | E2E testing, web scraping, visual regression |

### Engineering (6 agents)
| Agent | Use When |
|-------|----------|
| [**Project Initializer**](.claude/agents/engineering/project-initializer.md) | **Recommended for new projects** - Sets up long-term memory |
| [Backend Architect](.claude/agents/engineering/backend-architect.md) | Building APIs, databases, server-side logic |
| [Frontend Developer](.claude/agents/engineering/frontend-developer.md) | Building UIs with React/Vue/Svelte |
| [AI Engineer](.claude/agents/engineering/ai-engineer.md) | Adding AI features, RAG systems, LLM integration |
| [DevOps Automator](.claude/agents/engineering/devops-automator.md) | Setting up CI/CD, Docker, deployments |
| [Mobile App Builder](.claude/agents/engineering/mobile-app-builder.md) | Creating React Native or Flutter apps |

### Testing & Quality (5 agents)
| Agent | Use When |
|-------|----------|
| [API Tester](.claude/agents/testing/api-tester.md) | Testing API contracts and endpoints |
| [Performance Benchmarker](.claude/agents/testing/performance-benchmarker.md) | Load testing and optimization |
| [Test Results Analyzer](.claude/agents/testing/test-results-analyzer.md) | Analyzing test quality and coverage |
| [Tool Evaluator](.claude/agents/testing/tool-evaluator.md) | Build vs. buy decisions for tools |
| [Workflow Optimizer](.claude/agents/testing/workflow-optimizer.md) | Improving developer workflows |

### Operations (1 agent)
| Agent | Use When |
|-------|----------|
| [Infrastructure Maintainer](.claude/agents/studio-operations/infrastructure-maintainer.md) | Maintaining internal tools and infrastructure |

</details>

<details>
<summary><strong>How to Use</strong></summary>

### Option 1: Claude Code CLI (Recommended)
```bash
# Clone into your project
git clone https://github.com/dazeb/ClaudePlaybook.git .claude

# Agents are auto-discovered. Just reference them:
# "@react-nextjs-specialist, build a user profile page"
```

### Option 2: Claude Web/Desktop
```bash
# Copy any agent's content into Claude's system prompt
# Example: Open .claude/agents/web-development/react-nextjs-specialist.md
# Copy content → Paste into Claude → Start chatting
```

### Option 3: OpenCode
OpenCode uses a different folder structure (`.opencode/agent/` instead of `.claude/agents/`).

**Quick setup:**
```bash
# Clone the repo
git clone https://github.com/dazeb/ClaudePlaybook.git

# Rename folders for OpenCode
mv ClaudePlaybook/.claude .opencode
mv .opencode/agents .opencode/agent

# Clean up
rm -rf ClaudePlaybook

# Agents are now auto-discovered in OpenCode!
# Use them the same way: "@react-nextjs-specialist, ..."
```

**One-liner setup:**
```bash
git clone https://github.com/dazeb/ClaudePlaybook.git && mv ClaudePlaybook/.claude .opencode && mv .opencode/agents .opencode/agent && rm -rf ClaudePlaybook
```

</details>

<details>
<summary><strong>Optional: Telegram Notifier</strong></summary>

Get notifications on your phone when Claude completes tasks or needs approval for important actions.

**What it does:**
- Sends task completion alerts to your phone
- Requests approval for sensitive operations (deployments, DB changes)
- Sends error notifications in real-time

**Setup (2 minutes):**
```bash
cd .claude/tools/telegram-notifier
npm install
node telegram-notifier.js setup
```

The wizard will walk you through creating a Telegram bot and connecting it.

**Example use:**
```bash
# Get notified when builds complete
node telegram-notifier.js send "Build successful!"

# Request approval for sensitive operations
node telegram-notifier.js approve "Deploy to production?"
```

**[Full Documentation](.claude/tools/telegram-notifier/TELEGRAM_QUICK_START.md)**

</details>

<details>
<summary><strong>Contributing</strong></summary>

Want to add agents or improve existing ones? PRs welcome!

1. Follow the agent template structure
2. Include concrete examples
3. Document anti-patterns (common mistakes)
4. Submit PR with clear description

</details>

<details>
<summary><strong>License</strong></summary>

MIT License - use freely for personal or commercial projects.

</details>

<details>
<summary><strong>FAQ</strong></summary>

**Q: Do I need to use the Project Initializer?**
We recommend starting with [@project-initializer](.claude/agents/engineering/project-initializer.md) for new projects. It creates tracking files that give Claude long-term memory across sessions. Without these files, Claude may lose context after long conversations.

**Q: Do I need all 21 agents?**
No! Use only what you need. Most projects use 2-5 agents after the initial setup.

**Q: Can I modify agents for my needs?**
Absolutely! Fork and customize to match your stack and preferences.

**Q: Do agents work with Claude Web (not CLI)?**
Yes! Copy any agent's content into your conversation or system prompt.

**Q: Can I use these with OpenCode?**
Yes! See Option 3 in the "How to Use" section for setup instructions. You'll need to rename folders: `.claude` → `.opencode` and `agents` → `agent`.

**Q: Are these better than generic Claude?**
For specialized tasks, yes! Agents provide domain expertise, know the right tools, and avoid common mistakes.

</details>

<details>
<summary><strong>Quick Reference</strong></summary>

```
┌─────────────────────────────────────────────┐
│  RECOMMENDED WORKFLOW                       │
├─────────────────────────────────────────────┤
│  1. Clone repo into .claude folder          │
│  2. Start with @project-initializer         │
│     Creates: tests.json, init.sh, etc.      │
│  3. Use specialized agents for features     │
│  4. Get expert-level responses with memory  │
└─────────────────────────────────────────────┘
```

**Ready to build?** Start with [@project-initializer](.claude/agents/engineering/project-initializer.md), then use specialized agents.

</details>

<details>
<summary><strong>Advanced: Long-Running Agents Methodology</strong></summary>

## Philosophy: Why Long-Running Agents?

Traditional AI agents fail on complex projects because they try to "one-shot" everything. As conversations grow, they hit critical limitations:

| Traditional Approach | Long-Running Agents |
|---|---|
| Context loss after 50+ messages | Persistent state in `tests.json` |
| Forgets initial architecture decisions | Design intent in `claude-progress.txt` |
| Degraded code quality over time | Fresh context per atomic feature |
| New sessions start from scratch | Orientation protocol recovers state |
| Overwhelmed by project complexity | Incremental, focused implementation |

### The Solution: State-First Development

Instead of keeping everything in chat history (which gets forgotten), we externalize state to the filesystem:

```
your-project/
├── tests.json              # The roadmap (50-200+ features)
├── init.sh                 # One-command environment setup
├── claude-progress.txt     # Session memory (decisions & rationale)
├── src/                    # Your actual code
└── .git/                   # Version control for verification
```

> **Key Insight**: A feature isn't "done" until the agent runs verification, commits to git, and updates `tests.json`. This forces test-driven, incremental progress.

---

## How Long-Running Agents Work

### 1. The Orientation Protocol

Every time a new agent session starts (or context refreshes), the agent follows a strict startup routine:

```bash
# Agent starts session with:
pwd                              # Confirm workspace
git log -3 --oneline            # Recent changes
cat claude-progress.txt          # Recover design intent
cat tests.json | head -50       # See roadmap status
./init.sh                        # Ensure environment ready
```

**Why this matters**: Takes 10 seconds but prevents the agent from:
- ❌ Re-asking questions already answered
- ❌ Making redundant file searches
- ❌ Violating architectural decisions from previous sessions

---

### 2. Atomic Feature Implementation

Complex features are broken into **Atomic Units** in `tests.json`:

```json
{
  "feature": "User Authentication",
  "atomic_units": [
    {"id": 1, "task": "Create User model with email/password fields", "passes": true},
    {"id": 2, "task": "Implement password hashing with bcrypt", "passes": true},
    {"id": 3, "task": "Create POST /auth/register endpoint", "passes": false},
    {"id": 4, "task": "Add email validation middleware", "passes": false},
    {"id": 5, "task": "Write integration tests for registration flow", "passes": false}
  ]
}
```

**The Worker Agent Process**:
1. ✅ Read `claude-progress.txt` (what was done last session)
2. ✅ Run `init.sh` (ensure environment ready)
3. ✅ Implement **exactly ONE** atomic unit (e.g., task #3)
4. ✅ Run verification (tests, manual checks)
5. ✅ Commit to git with descriptive message
6. ✅ Update `tests.json` → `"passes": true`
7. ✅ Update `claude-progress.txt` (document decisions)

> 🎯 **Result**: High-quality code with focused context. Each session uses "early tokens" for implementation, not fighting cluttered memory.

---

### 3. State Persistence Strategy

| Artifact | Purpose | Format | Updated By |
|----------|---------|--------|------------|
| `tests.json` | Feature roadmap & status | JSON | Worker agents (passes: true/false) |
| `init.sh` | Environment automation | Shell script | Initializer (once), refined by workers |
| `claude-progress.txt` | Design intent & decisions | Markdown | Every agent session |
| `.git/` | Code verification | Git commits | After each atomic unit completion |

> 💡 **Pro Tip**: These files are your "source of truth". Any agent can recover full project state by reading them, even months later.

---

## Usage Patterns & Best Practices

### Pattern 1: The Perfect Session Start

Every agent session should begin with orientation:

```markdown
# Before implementing anything:
1. Read claude-progress.txt (what was done last)
2. Check tests.json (which features are pending)
3. Run init.sh (ensure environment ready)
4. Implement ONE atomic unit
5. Verify, commit, update tests.json
6. Document decisions in claude-progress.txt
```

> 🎯 **Why**: This prevents wasted tokens on "What's the current state?" questions.

---

### Pattern 2: Feature Decomposition

Break big features into 5-10 atomic units:

```json
❌ Bad (too large):
{
  "id": 1,
  "task": "Implement complete user authentication system",
  "passes": false
}

✅ Good (atomic):
{
  "id": 1, "task": "Create User model schema", "passes": true
},
{
  "id": 2, "task": "Implement password hashing", "passes": true
},
{
  "id": 3, "task": "Create /register endpoint", "passes": false
},
{
  "id": 4, "task": "Add JWT token generation", "passes": false
},
{
  "id": 5, "task": "Create /login endpoint", "passes": false
}
```

> 💡 **Rule of Thumb**: If a task takes >30 minutes, break it down further.

---

### Pattern 3: Agent Collaboration

Multiple agents can work together on complex features:

```markdown
# Example: Building a payment system

1. @backend-architect
   → Design payment API contract and database schema
   → Document in claude-progress.txt

2. @frontend-developer
   → Build payment form UI with validation
   → Integrate with API contract

3. @api-tester
   → Write contract tests for payment endpoints
   → Test auth boundaries and edge cases

4. @devops-automator
   → Set up Stripe webhook handling in production
   → Configure environment variables and secrets
```

---

### Pattern 4: Managing Long Sessions

When working across many features, refresh context to maintain code quality:

```markdown
## Session Management Strategy

**When to use `/clear`**:
- After completing 3-4 atomic units
- When context feels cluttered
- Before switching to a different feature area
- After any extended debugging session

**Recovery after `/clear`**:
1. Agent reads claude-progress.txt (recovers session memory)
2. Agent checks tests.json (sees completed vs. pending work)
3. Agent runs init.sh (verifies environment)
4. Ready to continue with fresh, focused context

**Result**: Better code quality with focused attention on current task
```

> 🎯 **Why**: Fresh context = sharper reasoning. State files ensure no information loss.

---

### Pattern 5: Triggering Extended Thinking

For complex decisions, explicitly request extended thinking:

```markdown
## Extended Thinking Triggers

Use these phrases to activate deeper reasoning:

**"think"** - Basic extended thinking
Example: "Think about the best database schema for this feature"

**"think hard"** - Deeper analysis
Example: "Think hard about the trade-offs between microservices vs. monolith"

**"think harder"** - Complex problem solving
Example: "Think harder about why these tests are flaky using 5 Whys"

**"ultrathink"** - Maximum depth reasoning
Example: "Ultrathink about the full TCO analysis for build vs. buy"

## Best Use Cases by Agent

- **Backend Architect**: Architecture decisions, scaling strategies
- **AI Engineer**: RAG pipeline design, prompt optimization
- **Test Results Analyzer**: Root cause analysis of complex failures
- **Tool Evaluator**: Build vs. buy decisions, vendor selection
- **Performance Benchmarker**: Bottleneck identification, optimization paths
- **Growth Hacker**: Multi-variate experiment design
```

> 💡 **Pro Tip**: Extended thinking is most valuable for decisions with multiple trade-offs or non-obvious solutions.

---

### Pattern 6: Testing Agent Effectiveness

Before deploying agents to your team, measure their impact:

```markdown
## Agent Evaluation Framework

**1. Create 3 Test Scenarios**

Example for @frontend-developer:
- Scenario 1: "Build a login form with email/password validation"
- Scenario 2: "Create a responsive dashboard with 4 metric cards"
- Scenario 3: "Fix accessibility issues in the checkout flow"

**2. Measure Baseline (Without Agent)**

Run each scenario with Claude (no agent loaded):
- Time to completion
- Code quality (subjective 1-5 rating)
- Required iterations
- Adherence to project patterns

**3. Measure With Agent (Agent Loaded)**

Run same scenarios with agent:
- Did agent activate correctly?
- Time to completion vs. baseline
- Code quality vs. baseline
- Did agent follow project conventions?
- Were there any hallucinations or mistakes?

**4. Calculate Impact**

Improvements to look for:
- ✅ Faster time to completion (20-50% faster)
- ✅ Better code quality (fewer revisions needed)
- ✅ Consistent adherence to project patterns
- ✅ Correct tool/library selection
- ✅ Proper error handling and edge cases

**5. Iterate Based on Results**

If agent underperforms:
- Add missing context to agent definition
- Include more specific examples
- Clarify success criteria in "When to Use" section
- Update tools/technologies section
```

> 🎯 **Goal**: Agents should provide 20-50% improvement in quality and speed for their specialized tasks.

---

## Claude 4.5 Optimizations

These agents leverage Claude 4.5's unique capabilities:

### Parallel Tool Use
Agents read multiple files and run searches simultaneously:
```markdown
✅ Do this:
- Read 5 files in parallel
- Run 3 grep searches simultaneously
- Analyze multiple code paths at once

❌ Not this:
- Read file 1 → wait → read file 2 → wait → read file 3
```

### Anti-AI-Slop Guidelines
Frontend agents enforce distinctive design:
- ✅ Unique typography combinations (not default system fonts)
- ✅ Cohesive color palettes (not generic blue/gray)
- ✅ Staggered micro-interactions (not uniform animations)
- ❌ Generic "Bootstrap-looking" designs

### Extended Thinking
Complex decisions use Claude's extended thinking mode:
- Architecture design (Backend Architect)
- Root cause analysis (Test Results Analyzer)
- Build vs. buy decisions (Tool Evaluator)
- Multi-source data synthesis (Analytics Reporter)

### Anti-Hallucination Guardrails
Strict verification protocols:
- ✅ Must read file before discussing contents
- ✅ Must verify changes with git diff
- ✅ Must run tests before marking features complete
- ✅ Must update tests.json only after verification

---

## Learning Resources

### Understanding Long-Running Agents

1. **[Anthropic Research: Building Effective Agents](https://www.anthropic.com/research/building-effective-agents)**
   The foundational research behind this methodology

2. **[State-First Development](./docs/state-first-development.md)**
   Deep dive into why filesystem state beats chat memory

3. **[Agent Collaboration Patterns](./docs/collaboration-patterns.md)**
   How agents hand off work effectively

### Video Walkthroughs

- 🎥 **[Getting Started: First Project with Initializer]** (10 min)
- 🎥 **[Building a Feature Across Multiple Sessions]** (15 min)
- 🎥 **[Agent Collaboration: Payment System Example]** (20 min)

---

## Repository Statistics

| Metric | Value |
|--------|-------|
| **Total Agents** | 21 |
| **Categories** | 4 (Engineering, Web Development, Testing & Quality, Operations) |
| **Agents with Workflows** | **21/21 (100% Complete!)** ✅ |
| **Workflow Coverage** | Engineering: 6/6, Web Dev: 9/9, Testing: 5/5, Ops: 1/1 |
| **Lines of Content** | ~10,000+ lines of comprehensive workflow guidance |
| **Workflow Steps** | 140+ numbered steps across all agents |
| **Decision Points** | 180+ branching logic points (→) |
| **Verification Gates** | 95+ quality checkpoints (✓) |
| **Collaboration Triggers** | 20+ parallel agent delegation patterns |
| **Tools Referenced** | 150+ specialized development tools |
| **Example Tasks** | 200+ concrete implementation examples |
| **Anti-patterns** | 250+ development mistakes documented |
| **Average Agent Size** | ~400 lines of comprehensive expertise |

---

## What Each Agent Includes

Every agent definition follows this comprehensive structure with **Anthropic-style workflows**:

```markdown
# Role: [Agent Name]

## Profile
High-level philosophy and approach

## Capabilities (10 bullets)
Specific skills and expertise areas

## Tools & Technologies
Recommended stack and platforms (updated to latest versions)

## When to Use This Agent
Specific scenarios and use cases

## Workflow (NEW!)
Comprehensive 6-9 step workflows with:

### Step 1: [Phase Name]
**Action**: What to do
- Detailed implementation steps
- Clear deliverables

**Decision Point**:
- → If X condition: Go to Step Y
- → If Z condition: Proceed to next step

**Skills Integration**: Which systematic skills to apply

**Loop Condition**:
- ↻ Repeat if conditions not met
- → Continue when verified

**Verification Gate**: ✓ Quality checkpoint before proceeding

**Human Approval Required**: ✓ Critical decisions requiring review

**Delegation Point**: When to spawn parallel agents

## Example Tasks (7 examples)
Concrete, detailed implementations

## Deliverables
Expected outputs and artifacts

## Collaboration
• Works closely with: [other agents]
• Receives from: [inputs]
• Provides to: [outputs]

## Success Metrics
Measurable KPIs for effectiveness

## Anti-patterns (10 items)
Common mistakes to avoid
```

**Workflow symbols:**
- **→** = Decision point (branching logic)
- **↻** = Loop condition (iterative cycles)
- **✓** = Verification gate (quality checkpoint)

---

## Contributing

We welcome contributions! Here's how to help:

### Adding New Agents
1. Follow the standard agent template structure
2. Include 7+ concrete example tasks
3. Document 10+ anti-patterns
4. Define clear collaboration interfaces
5. Submit PR with agent in appropriate category folder

### Improving Existing Agents
- Update tools/technologies (new frameworks, platforms)
- Add more example tasks and edge cases
- Refine success metrics
- Improve anti-pattern documentation

### Sharing Use Cases
- Document your success stories
- Share `tests.json` examples for common project types
- Contribute starter templates for popular stacks

---

**[Read full advanced methodology documentation →](docs/LONG_RUNNING_AGENTS.md)**

</details>

<details>
<summary><strong>Acknowledgments</strong></summary>

This project builds upon exceptional work from the AI agent development community:

### Core Methodology
Built on [Anthropic's research on effective agents](https://www.anthropic.com/research/building-effective-agents) and inspired by modern DevOps practices.

### Skills System
The comprehensive skills system (`.claude/skills/`) combines two exceptional sources:

**[obra/superpowers](https://github.com/obra/superpowers)** - Battle-tested systematic development methodologies:
- Test-Driven Development (RED-GREEN-REFACTOR cycle)
- Systematic Debugging (four-phase root cause analysis)
- Brainstorming & Planning workflows
- Code Review & Collaboration protocols
- Git Worktrees & Branch management

**[vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)** - Frontend performance and deployment skills:
- React/Next.js performance optimization (45 rules across 8 categories)
- Web design guidelines (100+ accessibility and UX rules)
- Vercel deployment automation (40+ framework support)

These skills transform our agents from knowledge repositories into systematic, quality-focused development partners. Huge thanks to [@obra](https://github.com/obra) and the [Vercel Labs team](https://github.com/vercel-labs) for creating and sharing these invaluable resources with the community.

📚 **[Explore the skills system →](.claude/skills/README.md)**

</details>

---

**Built by developers, for developers** • **MIT Licensed** • **21 Focused Development Agents** • **17 Composable Skills**
