# 🤖 Claude AI Agents Collection

> **A comprehensive library of 36 specialized AI agent role definitions** for modern software development studios, optimized for **Claude 4.x (Sonnet/Opus 4.5)** and implementing cutting-edge **"Long-Running Agents"** methodology.

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude 4.5 Optimized](https://img.shields.io/badge/Claude-4.5%20Optimized-orange.svg)]()
[![36 Agents](https://img.shields.io/badge/Agents-36-blue.svg)]()

---

## 🎯 Start Here: The Project Initializer

> ⚠️ **CRITICAL FIRST STEP**: Always begin with the [**Project Initializer**](.claude/agents/engineering/project-initializer.md) agent. It's the foundation that makes all other agents effective.

### Why Start with the Initializer?

The **Project Initializer** creates the essential infrastructure that allows agents to work across multiple sessions without losing context:

- 📋 **`tests.json`** - A machine-readable roadmap of 50-200+ micro-features
- 🔧 **`init.sh`** - Automated environment setup (no more "setup toil")
- 📝 **`claude-progress.txt`** - Session memory tracking decisions and rationale
- 🗂️ **Project structure** - Organized folders, configs, and documentation

### 🚀 Example Starter Prompts

Copy these prompts to get started with different project types:

#### 1. **Full-Stack Web Application**
```
Use the @Project Initializer agent to scaffold a new Next.js 14 e-commerce platform
with the following requirements:
- User authentication (email/password + OAuth)
- Product catalog with search and filtering
- Shopping cart and checkout with Stripe
- Admin dashboard for inventory management
- PostgreSQL database with Prisma ORM

Create a comprehensive tests.json with 80+ granular features broken down into
atomic units (auth, products, cart, checkout, admin). Include init.sh for
dependency installation and dev server startup. Generate initial claude-progress.txt
documenting the architecture decisions.
```

#### 2. **API Service / Backend**
```
Use the @Project Initializer agent to create a new REST API service in Python (FastAPI)
for a social media analytics platform:
- JWT authentication with refresh tokens
- User management and permissions (RBAC)
- Social media account integration (Twitter, Instagram APIs)
- Analytics data collection and aggregation
- WebSocket real-time updates
- PostgreSQL + Redis for caching

Generate tests.json with 60+ features covering all endpoints, authentication flows,
data processing pipelines, and edge cases. Create init.sh with venv setup,
dependency installation, and database migrations. Document API design decisions
in claude-progress.txt.
```

#### 3. **Mobile App (React Native)**
```
Use the @Project Initializer agent to scaffold a new React Native fitness tracking app:
- User onboarding and profile setup
- Activity tracking (steps, workouts, nutrition)
- Social features (friends, challenges, leaderboard)
- Push notifications and reminders
- Offline-first architecture with local storage sync
- Integration with Apple Health / Google Fit

Create tests.json with 70+ micro-features including onboarding flows, data sync logic,
UI components, and edge cases. Include init.sh for Expo setup and initial
dependencies. Generate claude-progress.txt with mobile-specific architecture decisions
(state management, navigation, offline strategy).
```

---

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

## 📂 The 36 Specialized Agents

### 🏗️ Engineering (7 agents)
*Building the technical foundation*

| Agent | Role | When to Use |
|-------|------|-------------|
| [🔧 **Project Initializer**](.claude/agents/engineering/project-initializer.md) | **Start here!** Scaffolds projects with tests.json, init.sh | Every new project |
| [🤖 AI Engineer](.claude/agents/engineering/ai-engineer.md) | RAG systems, LLM integration, prompt engineering | AI features |
| [🏛️ Backend Architect](.claude/agents/engineering/backend-architect.md) | API design, database modeling, microservices | Server-side logic |
| [🚀 DevOps Automator](.claude/agents/engineering/devops-automator.md) | CI/CD, Docker, Kubernetes, infrastructure | Deployment automation |
| [💻 Frontend Developer](.claude/agents/engineering/frontend-developer.md) | React/Vue/Svelte, state management, accessibility | User interfaces |
| [📱 Mobile App Builder](.claude/agents/engineering/mobile-app-builder.md) | React Native, Flutter, offline-first apps | Mobile development |
| [⚡ Rapid Prototyper](.claude/agents/engineering/rapid-prototyper.md) | MVPs, proof-of-concepts, quick validation | Fast iteration |

---

### 🎨 Design (5 agents)
*Crafting delightful user experiences*

| Agent | Role | When to Use |
|-------|------|-------------|
| [🎨 Brand Guardian](.claude/agents/design/brand-guardian.md) | Brand consistency, design systems, voice/tone | Brand standards |
| [🍱 UI Designer](.claude/agents/design/ui-designer.md) | Component design, mockups, Figma workflows | Interface design |
| [🔍 UX Researcher](.claude/agents/design/ux-researcher.md) | User interviews, usability testing, heuristics | Research & validation |
| [🖼️ Visual Storyteller](.claude/agents/design/visual-storyteller.md) | Illustrations, infographics, data visualization | Visual content |
| [✨ Whimsy Injector](.claude/agents/design/whimsy-injector.md) | Micro-interactions, animations, delight mechanics | Polish & personality |

---

### 📈 Marketing (7 agents)
*Growing and engaging your audience*

| Agent | Role | When to Use |
|-------|------|-------------|
| [✍️ Content Creator](.claude/agents/marketing/content-creator.md) | SEO articles, newsletters, case studies | Long-form content |
| [📈 Growth Hacker](.claude/agents/marketing/growth-hacker.md) | Funnel optimization, A/B testing, viral loops | User acquisition |
| [📱 ASO Specialist](.claude/agents/marketing/app-store-optimizer.md) | App store optimization, screenshots, keywords | Mobile app visibility |
| [📸 Instagram Curator](.claude/agents/marketing/instagram-curator.md) | Grid planning, Stories, Reels, Shopping | Instagram presence |
| [🤖 Reddit Builder](.claude/agents/marketing/reddit-community-builder.md) | Community building, AMAs, authentic engagement | Reddit strategy |
| [🎥 TikTok Strategist](.claude/agents/marketing/tiktok-strategist.md) | Short-form video, trending audio, edutainment | TikTok content |
| [🐦 Twitter Engager](.claude/agents/marketing/twitter-engager.md) | Thought leadership, viral threads, building in public | Twitter growth |

---

### 📦 Product (3 agents)
*Defining what to build*

| Agent | Role | When to Use |
|-------|------|-------------|
| [💡 Feedback Synthesizer](.claude/agents/product/feedback-synthesizer.md) | User feedback analysis, theme categorization | Understanding users |
| [📊 Sprint Prioritizer](.claude/agents/product/sprint-prioritizer.md) | Backlog grooming, RICE scoring, user stories | Feature prioritization |
| [📈 Trend Researcher](.claude/agents/product/trend-researcher.md) | Market analysis, competitive intelligence | Strategic direction |

---

### 🎬 Project Management (3 agents)
*Coordinating delivery and resources*

| Agent | Role | When to Use |
|-------|------|-------------|
| [🔬 Experiment Tracker](.claude/agents/project-management/experiment-tracker.md) | A/B test management, learning repositories | Running experiments |
| [📦 Project Shipper](.claude/agents/project-management/project-shipper.md) | Release coordination, blocker removal | Launch management |
| [🎬 Studio Producer](.claude/agents/project-management/studio-producer.md) | Portfolio management, resource allocation | Multi-project orchestration |

---

### 🏢 Studio Operations (6 agents)
*Running the business infrastructure*

| Agent | Role | When to Use |
|-------|------|-------------|
| [📊 Analytics Reporter](.claude/agents/studio-operations/analytics-reporter.md) | KPI tracking, dashboards, business intelligence | Data-driven decisions |
| [💰 Finance Tracker](.claude/agents/studio-operations/finance-tracker.md) | Burn rate, P&L, runway forecasting | Financial health |
| [🛠️ Infrastructure Maintainer](.claude/agents/studio-operations/infrastructure-maintainer.md) | Internal tools, access management, IT | Operational systems |
| [⚖️ Legal & Compliance](.claude/agents/studio-operations/legal-compliance-checker.md) | GDPR, SOC 2, license auditing | Compliance & risk |
| [🎧 Support Responder](.claude/agents/studio-operations/support-responder.md) | Customer support, documentation, SLAs | User assistance |
| [📱 Telegram Notifier](.claude/agents/studio-operations/telegram-notifier.md) | Real-time alerts, team notifications | Communication automation |

---

### 🧪 Testing (5 agents)
*Ensuring quality and optimizing workflows*

| Agent | Role | When to Use |
|-------|------|-------------|
| [🧪 API Tester](.claude/agents/testing/api-tester.md) | Contract testing, auth boundaries, schemas | API quality assurance |
| [🏎️ Performance Benchmarker](.claude/agents/testing/performance-benchmarker.md) | Load testing, bottleneck identification, SLOs | Performance validation |
| [📉 Test Results Analyzer](.claude/agents/testing/test-results-analyzer.md) | Flaky test detection, quality trends, RCA | Quality analytics |
| [🔧 Tool Evaluator](.claude/agents/testing/tool-evaluator.md) | Build vs. buy analysis, vendor selection, TCO | Technology decisions |
| [⚙️ Workflow Optimizer](.claude/agents/testing/workflow-optimizer.md) | CI/CD optimization, automation, DORA metrics | Developer productivity |

---

## 🛠️ Installation & Setup

### Quick Start

```bash
# 1. Clone into your project
cd your-project-root
git clone https://github.com/yourusername/claude-ai-agents.git .claude

# 2. Start with the Initializer (see example prompts above)
# Copy one of the 3 starter prompts and run it with Claude

# 3. Use specialized agents for features
# Example: "@Frontend Developer, implement the login form from tests.json"
```

### For Claude Code CLI

Agents in `.claude/agents/` are automatically discoverable. Reference them with:
```
@Project Initializer scaffold a new Next.js dashboard
@Frontend Developer implement the user profile page
@API Tester write tests for the authentication endpoints
```

### For Claude Web/Desktop

Copy the content of any agent `.md` file into your system prompt or custom instructions section.

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

1. @Backend Architect
   → Design payment API contract and database schema
   → Document in claude-progress.txt

2. @Frontend Developer
   → Build payment form UI with validation
   → Integrate with API contract

3. @API Tester
   → Write contract tests for payment endpoints
   → Test auth boundaries and edge cases

4. @DevOps Automator
   → Set up Stripe webhook handling in production
   → Configure environment variables and secrets
```

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

## 📄 License

**MIT License** - Use, modify, and distribute freely for personal or commercial projects.

---

## 🙏 Acknowledgments

- Built on [Anthropic's research on effective agents](https://www.anthropic.com/research/building-effective-agents)
- Inspired by modern DevOps practices (DORA metrics, value stream mapping)
- Community contributions from developers worldwide

---

## 🚀 Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│  THE GOLDEN WORKFLOW                                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. START: @Project Initializer                            │
│     ↓ Creates: tests.json, init.sh, progress.txt          │
│                                                             │
│  2. IMPLEMENT: @Specialized Agent                          │
│     ↓ Reads: progress.txt, tests.json                      │
│     ↓ Implements: ONE atomic unit                          │
│     ↓ Verifies: runs tests, manual checks                  │
│     ↓ Commits: git commit with message                     │
│     ↓ Updates: tests.json, progress.txt                    │
│                                                             │
│  3. REPEAT: Next feature with same/different agent         │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  🎯 REMEMBER:                                               │
│  • Initializer FIRST (always)                              │
│  • ONE atomic unit per session                             │
│  • Verify before marking complete                          │
│  • Commit after each success                               │
│  • Update progress.txt with "why" decisions                │
└─────────────────────────────────────────────────────────────┘
```

---

**Ready to build?** Start with the [Project Initializer](.claude/agents/engineering/project-initializer.md) and one of the 3 example prompts above! 🚀

**Questions?** Open an issue or check our [FAQ](./docs/FAQ.md)

**Built for modern software development studios** • **MIT Licensed** • **Claude 4.5 Optimized** • **36 Specialized Agents**
