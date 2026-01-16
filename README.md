# 🤖 Claude AI Agents

**Ready-to-use AI agent templates that make Claude smarter at specific tasks.**

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![45 Agents](https://img.shields.io/badge/Agents-45-blue.svg)]()
[![14 Skills](https://img.shields.io/badge/Skills-14-brightgreen.svg)](.claude/skills/README.md)
[![Works with Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-blue.svg)]()
[![Works with OpenCode](https://img.shields.io/badge/OpenCode-Compatible-orange.svg)]()
[![Hooks](https://img.shields.io/badge/Hooks-4_Templates-purple.svg)]()
[![MCP](https://img.shields.io/badge/MCP-15+_Servers-orange.svg)]()
[![LSP](https://img.shields.io/badge/LSP-11_Languages-green.svg)]()

---

## ⚡ Quick Start (60 seconds)

**What is this?** A collection of specialized "expert personas" that make Claude better at specific development tasks.

**Works with:** Claude Code CLI, OpenCode, Claude Web/Desktop

**How does it work?**
1. Clone this repo into your project
2. Reference an agent when talking to Claude (e.g., `@frontend-developer`)
3. Claude now has deep expertise in that domain

📋 **[View Complete Feature List →](FEATURES.md)** | 📚 **[Marketplace Docs](MARKETPLACE.md)** | 🪝 **[Hooks Guide](.claude/hooks/README.md)** | 🔌 **[MCP Guide](MCP_INTEGRATION.md)** | ⚡ **[LSP Guide](LSP_SETUP.md)**

**Try it now:**

### 🔌 Option A: Plugin Marketplace (Best - Official Integration)
```bash
# Add the marketplace to Claude Code
/plugin marketplace add https://github.com/dazeb/Long-Running-AI-Agents

# Install specific category
/plugin install web-development-agents@long-running-ai-agents
/plugin install engineering-agents@long-running-ai-agents

# Or install the essentials bundle (recommended for starters)
/plugin install essentials-bundle@long-running-ai-agents

# Browse all available plugins
/plugin > Discover
```

### 🏪 Option B: CLI Installer (Quick & Easy)
```bash
curl -fsSL https://raw.githubusercontent.com/dazeb/Long-Running-AI-Agents/main/install.sh | bash
```
Interactive installer lets you choose which agents to install.

📚 **[View Full Marketplace Documentation →](MARKETPLACE.md)**

### Option C: Manual Install
```bash
# Clone into your project
git clone https://github.com/dazeb/Long-Running-AI-Agents.git .claude

# Use an agent
# Just say: "@frontend-developer, build me a responsive navbar"
```

That's it! Claude will now respond with frontend-specific best practices, modern tools, and avoid common pitfalls.

<details>
<summary>⚠️ <strong>Important: Start Every Project Right</strong></summary>

> **🎯 ALWAYS begin with the [Project Initializer](.claude/agents/engineering/project-initializer.md) agent!**

The Project Initializer creates essential infrastructure that gives Claude long-term memory:
- 📋 **`tests.json`** - Tracks all features and their completion status
- 🔧 **`init.sh`** - One-command environment setup
- 📝 **`claude-progress.txt`** - Remembers decisions across sessions
- 🗂️ **Project structure** - Organized files and configs

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
<summary>🎯 <strong>What You Get</strong></summary>

**45 specialized agents** across different domains:

- **💻 Web Development** (8 agents) - React, APIs, CSS, PWAs, performance, full-stack, static sites, browser automation
- **🔧 Engineering** (8 agents) - Backend, frontend, mobile, AI, DevOps, prototyping, agent creation
- **🎨 Design** (5 agents) - UI, UX, branding, animations, visual storytelling
- **📈 Marketing** (7 agents) - Content, growth, social media, ASO
- **📦 Product** (3 agents) - Feedback analysis, prioritization, trend research
- **🎬 Project Management** (3 agents) - Shipping, experiments, coordination
- **🏢 Operations** (6 agents) - Analytics, finance, support, compliance, infrastructure
- **🧪 Testing** (5 agents) - API testing, performance, quality analysis

**PLUS: 14 composable skills** that make agents systematic and quality-focused:

- **🛠️ Development** - TDD, systematic debugging, verification protocols
- **📋 Planning** - Brainstorming, plan writing, execution workflows
- **🤝 Collaboration** - Parallel agents, code review, multi-stage review
- **🔄 Workflow** - Git worktrees, branch management
- **🎓 Meta** - Skills creation, usage guides

Each agent knows:
- The right tools for the job
- Best practices and patterns
- Common mistakes to avoid
- When to use them vs. other approaches
- How to apply systematic skills for quality code

</details>

<details>
<summary>💡 <strong>Why Use These Agents?</strong></summary>

**Without agents:**
```
You: "Build me a login form"
Claude: Creates basic form with inline styles and no validation
```

**With agents:**
```
You: "@react-nextjs-specialist, build me a login form"
Claude: Creates form with:
  ✅ React Hook Form for validation
  ✅ Zod schema for type safety
  ✅ Server Actions for authentication
  ✅ Loading states and error handling
  ✅ Accessibility (ARIA labels, keyboard nav)
  ✅ Responsive design
```

Agents turn general AI into domain experts.

</details>

<details>
<summary>🚀 <strong>Claude Code 2.1 Features (NEW!)</strong></summary>

Leverage the latest Claude Code capabilities:

### 🪝 Hooks - Automated Workflows
Auto-format code, block dangerous git operations, generate session summaries:
- **post-edit-format.sh** - Auto-formats 12+ languages after every edit
- **pre-git-safety.sh** - Blocks force pushes, protected file edits
- **stop-session-summary.sh** - Session reports with stats
- **post-tests-update.sh** - Auto-updates tests.json

📚 **[View Hooks Documentation →](.claude/hooks/README.md)**

### 🔌 MCP - External Tool Integration
Connect to 15+ services for live data:
- **GitHub** - PRs, issues, code review
- **Perplexity** - Real-time web research
- **PostgreSQL** - Database queries
- **Slack** - Team notifications
- **And 11 more...**

📚 **[View MCP Integration Guide →](MCP_INTEGRATION.md)**

### ⚡ LSP - 900x Faster Code Navigation
IDE-like intelligence for 11 languages. Go-to-definition in **50ms** (vs 45 seconds):
- TypeScript/JavaScript, Python, Go, Rust, Java, C/C++, C#, PHP, Ruby, Kotlin, HTML/CSS

📚 **[View LSP Setup Guide →](LSP_SETUP.md)**

</details>

<details>
<summary>📚 <strong>Browse Agents</strong></summary>

### 💻 Web Development (NEW!)
| Agent | Use When |
|-------|----------|
| [React/Next.js Specialist](.claude/agents/web-development/react-nextjs-specialist.md) | Building Next.js apps, Server Components, App Router |
| [API Integration Specialist](.claude/agents/web-development/api-integration-specialist.md) | Connecting to REST/GraphQL APIs, auth flows |
| [Full-Stack Developer](.claude/agents/web-development/fullstack-web-developer.md) | Building complete apps from database to UI |
| [Web Performance Optimizer](.claude/agents/web-development/web-performance-optimizer.md) | Fixing slow sites, improving Core Web Vitals |
| [PWA Builder](.claude/agents/web-development/pwa-builder.md) | Making apps installable and work offline |
| [CSS & Tailwind Expert](.claude/agents/web-development/css-tailwind-expert.md) | Advanced styling, animations, design systems |
| [Static Site Specialist](.claude/agents/web-development/static-site-specialist.md) | Building fast sites with Astro, 11ty, Hugo |
| [Browser Automation Specialist](.claude/agents/web-development/browser-automation-specialist.md) | E2E testing, web scraping, visual regression, Claude in Chrome |

### 🏗️ Engineering
| Agent | Use When |
|-------|----------|
| [🎯 **Project Initializer**](.claude/agents/engineering/project-initializer.md) | ⭐ **START HERE!** Every new project (enables long-term memory) |
| [AI Engineer](.claude/agents/engineering/ai-engineer.md) | Adding AI features, RAG systems, LLM integration |
| [Backend Architect](.claude/agents/engineering/backend-architect.md) | Building APIs, databases, server-side logic |
| [DevOps Automator](.claude/agents/engineering/devops-automator.md) | Setting up CI/CD, Docker, deployments |
| [Frontend Developer](.claude/agents/engineering/frontend-developer.md) | Building UIs with React/Vue/Svelte |
| [Mobile App Builder](.claude/agents/engineering/mobile-app-builder.md) | Creating React Native or Flutter apps |
| [Rapid Prototyper](.claude/agents/engineering/rapid-prototyper.md) | Quick MVPs and proof-of-concepts |
| [Agent Creator](.claude/agents/engineering/agent-creator.md) | Creating new specialized AI agents following best practices |

### 🎨 Design
| Agent | Use When |
|-------|----------|
| [Brand Guardian](.claude/agents/design/brand-guardian.md) | Ensuring brand consistency |
| [UI Designer](.claude/agents/design/ui-designer.md) | Designing interfaces and components |
| [UX Researcher](.claude/agents/design/ux-researcher.md) | User research and testing |
| [Visual Storyteller](.claude/agents/design/visual-storyteller.md) | Creating illustrations and infographics |
| [Whimsy Injector](.claude/agents/design/whimsy-injector.md) | Adding delightful animations and interactions |

### 📈 Marketing
| Agent | Use When |
|-------|----------|
| [Content Creator](.claude/agents/marketing/content-creator.md) | Writing blog posts, newsletters, case studies |
| [Growth Hacker](.claude/agents/marketing/growth-hacker.md) | Optimizing funnels and acquisition |
| [ASO Specialist](.claude/agents/marketing/app-store-optimizer.md) | Improving app store visibility |
| [Instagram Curator](.claude/agents/marketing/instagram-curator.md) | Planning Instagram content |
| [Reddit Builder](.claude/agents/marketing/reddit-community-builder.md) | Building Reddit communities |
| [TikTok Strategist](.claude/agents/marketing/tiktok-strategist.md) | Creating TikTok content strategy |
| [Twitter Engager](.claude/agents/marketing/twitter-engager.md) | Growing Twitter presence |

### 📦 Product & PM
| Agent | Use When |
|-------|----------|
| [Feedback Synthesizer](.claude/agents/product/feedback-synthesizer.md) | Analyzing user feedback |
| [Sprint Prioritizer](.claude/agents/product/sprint-prioritizer.md) | Prioritizing features |
| [Trend Researcher](.claude/agents/product/trend-researcher.md) | Market research and trends |
| [Experiment Tracker](.claude/agents/project-management/experiment-tracker.md) | Managing A/B tests |
| [Project Shipper](.claude/agents/project-management/project-shipper.md) | Coordinating launches |
| [Studio Producer](.claude/agents/project-management/studio-producer.md) | Managing multiple projects |

### 🏢 Operations & Testing
| Agent | Use When |
|-------|----------|
| [Analytics Reporter](.claude/agents/studio-operations/analytics-reporter.md) | Tracking metrics and KPIs |
| [Finance Tracker](.claude/agents/studio-operations/finance-tracker.md) | Managing budgets and runway |
| [Infrastructure Maintainer](.claude/agents/studio-operations/infrastructure-maintainer.md) | Maintaining internal tools |
| [Legal & Compliance](.claude/agents/studio-operations/legal-compliance-checker.md) | GDPR, licensing, compliance |
| [Support Responder](.claude/agents/studio-operations/support-responder.md) | Handling customer support |
| [API Tester](.claude/agents/testing/api-tester.md) | Testing API contracts |
| [Performance Benchmarker](.claude/agents/testing/performance-benchmarker.md) | Load testing and optimization |
| [Test Results Analyzer](.claude/agents/testing/test-results-analyzer.md) | Analyzing test quality |
| [Tool Evaluator](.claude/agents/testing/tool-evaluator.md) | Build vs. buy decisions |
| [Workflow Optimizer](.claude/agents/testing/workflow-optimizer.md) | Improving developer workflows |

</details>

<details>
<summary>🚀 <strong>How to Use</strong></summary>

### Option 1: Claude Code CLI (Recommended)
```bash
# Clone into your project
git clone https://github.com/dazeb/Long-Running-AI-Agents.git .claude

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
git clone https://github.com/dazeb/Long-Running-AI-Agents.git

# Rename folders for OpenCode
mv Long-Running-AI-Agents/.claude .opencode
mv .opencode/agents .opencode/agent

# Clean up
rm -rf Long-Running-AI-Agents

# Agents are now auto-discovered in OpenCode!
# Use them the same way: "@react-nextjs-specialist, ..."
```

**One-liner setup:**
```bash
git clone https://github.com/dazeb/Long-Running-AI-Agents.git && mv Long-Running-AI-Agents/.claude .opencode && mv .opencode/agents .opencode/agent && rm -rf Long-Running-AI-Agents
```

</details>

<details>
<summary>📱 <strong>Optional: Telegram Notifier</strong></summary>

Get notifications on your phone when Claude completes tasks or needs approval for important actions.

**What it does:**
- ✅ Sends task completion alerts to your phone
- 🔔 Requests approval for sensitive operations (deployments, DB changes)
- 🚨 Sends error notifications in real-time

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
node telegram-notifier.js send "✅ Build successful!"

# Request approval for sensitive operations
node telegram-notifier.js approve "Deploy to production?"
```

📚 **[Full Documentation](.claude/tools/telegram-notifier/TELEGRAM_QUICK_START.md)**

</details>

<details>
<summary>🤝 <strong>Contributing</strong></summary>

Want to add agents or improve existing ones? PRs welcome!

1. Follow the agent template structure
2. Include concrete examples
3. Document anti-patterns (common mistakes)
4. Submit PR with clear description

</details>

<details>
<summary>📄 <strong>License</strong></summary>

MIT License - use freely for personal or commercial projects.

</details>

<details>
<summary>💬 <strong>FAQ</strong></summary>

**Q: Do I need to use the Project Initializer?**
**YES, for best results!** Always start with [@project-initializer](.claude/agents/engineering/project-initializer.md). It creates tracking files that give Claude long-term memory across sessions. Without it, Claude forgets context after long conversations.

**Q: Do I need all 43 agents?**
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
<summary>🚀 <strong>Quick Reference</strong></summary>

```
┌─────────────────────────────────────────────┐
│  RECOMMENDED WORKFLOW                       │
├─────────────────────────────────────────────┤
│  1. Clone repo into .claude folder          │
│  2. 🎯 START: @project-initializer          │
│     Creates: tests.json, init.sh, etc.      │
│  3. USE: @specialized-agent for features    │
│  4. Get expert-level responses with memory  │
└─────────────────────────────────────────────┘
```

**Ready to build?** Start with [@project-initializer](.claude/agents/engineering/project-initializer.md), then use specialized agents! 🚀

</details>

<details>
<summary>📖 <strong>Advanced: Long-Running Agents Methodology</strong></summary>

## 🧠 Philosophy: Why Long-Running Agents?

Traditional AI agents fail on complex projects because they try to "one-shot" everything. As conversations grow, they hit critical limitations:

| ❌ Traditional Approach | ✅ Long-Running Agents |
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
├── tests.json              # ← The roadmap (50-200+ features)
├── init.sh                 # ← One-command environment setup
├── claude-progress.txt     # ← Session memory (decisions & rationale)
├── src/                    # ← Your actual code
└── .git/                   # ← Version control for verification
```

> 💡 **Key Insight**: A feature isn't "done" until the agent runs verification, commits to git, and updates `tests.json`. This forces test-driven, incremental progress.

---

## 🔄 How Long-Running Agents Work

### 1. 🎬 The Orientation Protocol

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

### 2. 🧩 Atomic Feature Implementation

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

### 3. 📊 State Persistence Strategy

| Artifact | Purpose | Format | Updated By |
|----------|---------|--------|------------|
| `tests.json` | Feature roadmap & status | JSON | Worker agents (passes: true/false) |
| `init.sh` | Environment automation | Shell script | Initializer (once), refined by workers |
| `claude-progress.txt` | Design intent & decisions | Markdown | Every agent session |
| `.git/` | Code verification | Git commits | After each atomic unit completion |

> 💡 **Pro Tip**: These files are your "source of truth". Any agent can recover full project state by reading them, even months later.

---

## 💡 Usage Patterns & Best Practices

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

## ⚡ Claude 4.5 Optimizations

These agents leverage Claude 4.5's unique capabilities:

### 🔀 Parallel Tool Use
Agents read multiple files and run searches simultaneously:
```markdown
✅ Do this:
- Read 5 files in parallel
- Run 3 grep searches simultaneously
- Analyze multiple code paths at once

❌ Not this:
- Read file 1 → wait → read file 2 → wait → read file 3
```

### 🎨 Anti-AI-Slop Guidelines
Frontend agents enforce distinctive design:
- ✅ Unique typography combinations (not default system fonts)
- ✅ Cohesive color palettes (not generic blue/gray)
- ✅ Staggered micro-interactions (not uniform animations)
- ❌ Generic "Bootstrap-looking" designs

### 🧠 Extended Thinking
Complex decisions use Claude's extended thinking mode:
- Architecture design (Backend Architect)
- Root cause analysis (Test Results Analyzer)
- Build vs. buy decisions (Tool Evaluator)
- Multi-source data synthesis (Analytics Reporter)

### 🔍 Anti-Hallucination Guardrails
Strict verification protocols:
- ✅ Must read file before discussing contents
- ✅ Must verify changes with git diff
- ✅ Must run tests before marking features complete
- ✅ Must update tests.json only after verification

---

## 📚 Learning Resources

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

## 📊 Repository Statistics

| Metric | Value |
|--------|-------|
| **Total Agents** | 36 |
| **Categories** | 7 (Engineering, Design, Marketing, Product, PM, Operations, Testing) |
| **Lines of Content** | ~3,600 lines of detailed role definitions |
| **Tools Referenced** | 200+ specialized tools across all domains |
| **Example Tasks** | 250+ concrete implementation examples |
| **Anti-patterns** | 360+ specific mistakes documented |
| **Average Agent Size** | ~100 lines (vs. ~15 before enhancement) |

---

## 🎓 What Each Agent Includes

Every agent definition follows this comprehensive structure:

```markdown
# Role: [Agent Name]

## Profile
High-level philosophy and approach

## Capabilities (10 bullets)
Specific skills and expertise areas

## Tools & Technologies
Recommended stack and platforms

## When to Use This Agent
Specific scenarios and use cases

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

---

## 🤝 Contributing

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

**[Read full advanced methodology documentation →](LONG_RUNNING_AGENTS.md)**

</details>

<details>
<summary>🙏 <strong>Acknowledgments</strong></summary>

This project builds upon exceptional work from the AI agent development community:

### 🎯 Core Methodology
Built on [Anthropic's research on effective agents](https://www.anthropic.com/research/building-effective-agents) and inspired by modern DevOps practices.

### 🛠️ Skills System
The comprehensive skills system (`.claude/skills/`) is adapted from **[obra/superpowers](https://github.com/obra/superpowers)** - a battle-tested collection of systematic development methodologies including:
- Test-Driven Development (RED-GREEN-REFACTOR cycle)
- Systematic Debugging (four-phase root cause analysis)
- Brainstorming & Planning workflows
- Code Review & Collaboration protocols
- Git Worktrees & Branch management

These skills transform our agents from knowledge repositories into systematic, quality-focused development partners. Huge thanks to [@obra](https://github.com/obra) for creating and sharing this invaluable resource with the community.

📚 **[Explore the skills system →](.claude/skills/README.md)**

</details>

---

**Built by developers, for developers** • **MIT Licensed** • **45 Specialized Agents** • **14 Composable Skills**
