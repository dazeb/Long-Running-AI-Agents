# Claude AI Agents Collection

A comprehensive library of **36 specialized AI agent role definitions** for modern software development studios. This collection is optimized for **Claude 4.x (Sonnet/Opus 4.5)** and implements the latest industry best practices for **"Long-Running Agents"**.

## 🧠 Philosophy: Why Build Agents Like This?

Standard AI agents often fail on complex tasks because they try to "one-shot" the entire problem. As tasks grow in complexity, they exceed the model's context window, leading to:
1. **Context Loss**: The model forgets initial requirements or architectural decisions as the conversation grows.
2. **Implementation Fatigue**: Code quality degrades as the session context becomes cluttered.
3. **Broken Handoffs**: New sessions start with no memory, forcing the agent to waste tokens and time "rediscovering" the project.

**Our Approach** solves this by treating development as a series of **atomic, stateful sessions**. We use a two-agent harness based on Anthropic's research:
- **The Initializer**: Spends its entire context window planning, scaffolding, and creating a machine-readable roadmap (`tests.json`).
- **The Worker**: Focused, incremental sessions that implement exactly one feature, verify it end-to-end, and persist the state for the next session.

## 🚀 Deep Dive: Long-Running Agent Mechanics

Long-running agents are designed to survive the "forgetfulness" of large language models by externalizing their memory and state to the filesystem.

### 1. State-First Development
Instead of storing the project roadmap in the chat history, we store it in a structured `tests.json` file. This file contains every micro-feature, edge case, and requirement derived from the initial prompt. 
- **Persistence**: Because it's on disk, any agent can read it at the start of a session and know exactly where the project stands.
- **Verification**: It forces a "Test-Driven" approach. A feature isn't "done" until the agent runs a verification script and updates the JSON.

### 2. The "Aha!" Moment (Session Orientation)
Every time a new agent session starts (or context is refreshed), the agent follows a strict **Orientation Protocol**:
- `pwd`: Confirms the workspace.
- `git log`: Understands the recent code changes.
- `read claude-progress.txt`: Recovers the "design intent" and "next steps" from the previous session.
This process takes seconds but prevents the agent from making redundant queries or architectural mistakes.

### 3. Incremental Atomic Progress
Complex features are broken down into **Atomic Units**. A worker agent is instructed to complete exactly ONE item from the roadmap per session.
- **Precision**: Focusing on a single function or component reduces the surface area for bugs.
- **Token Efficiency**: The agent uses its high-quality "early context" tokens for implementation rather than struggling with a cluttered memory.

## 📖 How-to Guide: Using the Collection

### Phase 1: Installation & Setup
1. **Clone the Repo**: Copy the `.claude/agents/` directory into your project root.
2. **Environment**: Ensure you have a standard development environment (Node, Python, etc.) and `git` initialized.
3. **Claude Setup**: If using Claude Code, these agents will be automatically discoverable. For Web/Desktop, copy the content of the relevant `.md` file into your system prompt or custom instructions.

### Phase 2: Starting a New Project
Always start with the **Project Initializer**. It sets the foundation for every other agent.
**Example Prompt:**
> "Use the @Project Initializer agent to scaffold a new Next.js dashboard app. Create a comprehensive tests.json with 50+ granular features, an init.sh script to start the dev server, and an initial progress.txt."

### Phase 3: The Development Loop
Once initialized, use specialized agents to build feature-by-feature.
1. **Trigger Agent**: "@Frontend Developer, check tests.json and implement the 'Login Form' feature."
2. **The Agent will**:
    - Read `claude-progress.txt` to see what was done last.
    - Run `init.sh` to ensure the environment is ready.
    - Implement the code.
    - Run a test to verify the feature.
    - **Commit changes** to git and update `tests.json`.
3. **Repeat**: Move to the next feature using the same or a different specialized agent.

---

## 📂 Agent Directory

| Engineering | Design | Product |
| :--- | :--- | :--- |
| [🏗️ Project Initializer](.claude/agents/engineering/project-initializer.md) | [🎨 Brand Guardian](.claude/agents/design/brand-guardian.md) | [📊 Sprint Prioritizer](.claude/agents/product/sprint-prioritizer.md) |
| [🤖 AI & LLM Engineer](.claude/agents/engineering/ai-engineer.md) | [🍱 UI Designer](.claude/agents/design/ui-designer.md) | [💡 Feedback Synthesizer](.claude/agents/product/feedback-synthesizer.md) |
| [🏛️ Backend Architect](.claude/agents/engineering/backend-architect.md) | [🔍 UX Researcher](.claude/agents/design/ux-researcher.md) | [📈 Trend Researcher](.claude/agents/product/trend-researcher.md) |
| [🚀 DevOps Automator](.claude/agents/engineering/devops-automator.md) | [🖼️ Visual Storyteller](.claude/agents/design/visual-storyteller.md) | |
| [💻 Frontend Developer](.claude/agents/engineering/frontend-developer.md) | [✨ Whimsy Injector](.claude/agents/design/whimsy-injector.md) | |
| [📱 Mobile App Builder](.claude/agents/engineering/mobile-app-builder.md) | | |
| [⚡ Rapid Prototyper](.claude/agents/engineering/rapid-prototyper.md) | | |

| Marketing | Operations | Testing |
| :--- | :--- | :--- |
| [✍️ Content Creator](.claude/agents/marketing/content-creator.md) | [📈 Analytics Reporter](.claude/agents/studio-operations/analytics-reporter.md) | [🧪 API Tester](.claude/agents/testing/api-tester.md) |
| [📈 Growth Hacker](.claude/agents/marketing/growth-hacker.md) | [💰 Finance Tracker](.claude/agents/studio-operations/finance-tracker.md) | [🏎️ Perf Benchmarker](.claude/agents/testing/performance-benchmarker.md) |
| [📱 ASO Specialist](.claude/agents/marketing/app-store-optimizer.md) | [🛠️ Infra Maintainer](.claude/agents/studio-operations/infrastructure-maintainer.md) | [📉 Results Analyzer](.claude/agents/testing/test-results-analyzer.md) |
| [📸 Instagram Curator](.claude/agents/marketing/instagram-curator.md) | [⚖️ Legal & Compliance](.claude/agents/studio-operations/legal-compliance-checker.md) | [🔧 Tool Evaluator](.claude/agents/testing/tool-evaluator.md) |
| [🤖 Reddit Builder](.claude/agents/marketing/reddit-community-builder.md) | [🎧 Support Responder](.claude/agents/studio-operations/support-responder.md) | [⚙️ Workflow Optimizer](.claude/agents/testing/workflow-optimizer.md) |
| [🎥 TikTok Strategist](.claude/agents/marketing/tiktok-strategist.md) | [📱 Telegram Notifier](.claude/agents/studio-operations/telegram-notifier.md) | |
| [🐦 Twitter Engager](.claude/agents/marketing/twitter-engager.md) | | |

| Project Management |
| :--- |
| [🔬 Experiment Tracker](.claude/agents/project-management/experiment-tracker.md) |
| [📦 Project Shipper](.claude/agents/project-management/project-shipper.md) |
| [🎬 Studio Producer](.claude/agents/project-management/studio-producer.md) |

---

## 🛠️ The Working Environment

To ensure agents work effectively across many context windows, we maintain three "Source of Truth" artifacts:

1. **`tests.json` (The Roadmap)**: A structured JSON file containing 50-200+ micro-features. It is **immutable** (descriptions never change). Agents only update the `passes: true/false` field.
2. **`init.sh` (The Engine)**: A shell script that automatically installs dependencies, starts dev servers, and runs baseline tests. This eliminates "setup toil" at the start of every session.
3. **`claude-progress.txt` (The Memory)**: A freeform log where agents record *why* decisions were made, helping the next agent understand the "spirit" of the code.

## ✨ Claude 4.5 Optimizations

These agents are specifically tuned for the unique capabilities of the Claude 4.5 model family:
- **Parallel Tool Use**: Prompts encourage agents to read multiple files and run speculative searches simultaneously, significantly reducing latency.
- **Anti-Hallucination Guardrails**: System instructions mandate that agents must `read` a file before discussing its contents.
- **Frontend Aesthetic Guidance**: Protocol to avoid "AI Slop" by enforcing unique typography, cohesive color palettes, and staggered micro-interactions.
- **Context Awareness**: Agents monitor token budget and save state proactively.

---

**Built for modern software development studios** • **MIT Licensed** • **Claude 4.5 Optimized**
