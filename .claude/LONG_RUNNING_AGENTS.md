# Long-Running AI Agents: Best Practices

This document outlines best practices for AI agents working on complex, multi-session tasks that span multiple context windows. Based on Anthropic's research and Claude 4.x capabilities.

## Table of Contents
1. [Overview](#overview)
2. [Core Principles](#core-principles)
3. [Agent Architecture](#agent-architecture)
4. [Session Management](#session-management)
5. [State Persistence](#state-persistence)
6. [Testing and Validation](#testing-and-validation)
7. [Claude 4.x Specific Features](#claude-4x-specific-features)
8. [Common Failure Modes and Solutions](#common-failure-modes-and-solutions)

## Overview

Long-running AI agents face unique challenges when working across multiple context windows. Each new session begins with no memory of what came before, requiring careful design to ensure continuity and progress.

**Key Challenge**: How do you enable an agent to make consistent progress when each session starts fresh?

**Solution**: A two-part approach:
1. **Initializer Agent**: Sets up the environment on the first run
2. **Coding Agent**: Makes incremental progress in every subsequent session

## Core Principles

### 1. Incremental Progress
- Work on ONE feature at a time
- Complete each feature fully before moving to the next
- Leave the environment in a "clean state" after each session
- Avoid trying to "one-shot" complex applications

### 2. Structured State Management
- Use JSON for schema-based data (tests.json, features.json)
- Use plain text for freeform notes (claude-progress.txt)
- Use git history as source of truth for what was done
- Use init scripts to eliminate setup friction

### 3. Clear Documentation
- Document what was completed
- Document what should be done next
- Document gotchas and platform-specific quirks
- Document technical debt and future refactoring needs

### 4. Test-Driven Continuity
- Write tests before implementation
- Mark tests as passing only after end-to-end verification
- Never remove or edit test definitions
- Use testing to verify the environment isn't broken

## Agent Architecture

### Initializer Agent (First Session Only)

**Purpose**: Set up the foundation for all future sessions

**Key Responsibilities**:
- Create comprehensive feature list (50-200+ features)
- Set up git repository with initial commit
- Write initialization script (init.sh)
- Create progress tracking file (claude-progress.txt)
- Establish baseline integration test
- Document conventions and patterns

**Example Feature List (tests.json)**:
```json
{
  "features": [
    {
      "id": 1,
      "category": "functional",
      "description": "User can create a new account with email and password",
      "steps": [
        "Navigate to signup page",
        "Fill in email and password fields",
        "Submit form",
        "Verify account creation success message",
        "Verify user is logged in"
      ],
      "passes": false,
      "priority": "high"
    }
  ],
  "total": 150,
  "passing": 0,
  "failing": 0,
  "not_started": 150
}
```

**Example Init Script (init.sh)**:
```bash
#!/bin/bash
echo "Starting development servers..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
  npm install
fi

# Start backend (if applicable)
cd backend && npm run dev &

# Start frontend
cd frontend && npm run dev &

echo "Servers started. Frontend: http://localhost:5173"
echo "Run 'npm test' to run the test suite"
```

### Coding Agent (All Subsequent Sessions)

**Purpose**: Make incremental progress towards completion

**Session Startup Routine**:
1. Run `pwd` to see current directory
2. Read `claude-progress.txt` for recent changes
3. Read `git log --oneline -20` to see commit history
4. Review feature list (tests.json) to understand status
5. Run `init.sh` to start development environment
6. Run baseline integration test to verify app isn't broken

**Session Work Pattern**:
1. Choose ONE feature from the feature list
2. Implement the feature completely
3. Test the feature end-to-end (browser automation, API testing, etc.)
4. Mark feature as passing in tests.json
5. Commit with descriptive message
6. Update claude-progress.txt
7. Repeat until context window nears limit

**Session End Routine**:
1. Ensure all work is committed
2. Update claude-progress.txt with summary
3. Document what should be done next
4. Mark completed features in tests.json

## Session Management

### Context Window Awareness

Claude 4.5 models have [context awareness](https://platform.claude.com/docs/en/build-with-claude/context-windows#context-awareness-in-claude-sonnet-4-5), meaning they can track remaining token budget. 

**Best Practices**:
- If using context compaction or external state saving, work persistently until complete
- Don't artificially stop work due to token concerns if context will be compacted
- Save state before context limits are reached
- Use parallel tool calls to maximize efficiency

**Example Prompt for Context Management**:
```
Your context window will be automatically compacted as it approaches its limit, 
allowing you to continue working indefinitely from where you left off. Therefore, 
do not stop tasks early due to token budget concerns. As you approach your token 
budget limit, save your current progress and state to memory before the context 
window refreshes. Always be as persistent and autonomous as possible and complete 
tasks fully, even if the end of your budget is approaching.
```

### Starting Fresh vs. Compaction

When a context window is cleared:
- **Starting fresh**: Preferred for Claude 4.5 - excellent at discovering state from filesystem
- **Compaction**: Can work but may lose context

**Prescriptive startup instructions**:
```
Call pwd; you can only read and write files in this directory.
Review progress.txt, tests.json, and the git logs.
Manually run through a fundamental integration test before moving on to implementing new features.
```

## State Persistence

### File Types and Their Purposes

| File Type | Format | Purpose | Example |
|-----------|--------|---------|---------|
| Feature list | JSON | Structured feature tracking with schema | tests.json, api-tests.json |
| Progress notes | Text | Freeform context and decisions | claude-progress.txt |
| Init script | Bash | Start development environment | init.sh |
| Git history | Git | Complete log of changes | git log |
| Technical debt | Markdown | Known issues and shortcuts | TECH_DEBT.md |
| Runbooks | Markdown | Step-by-step procedures | RUNBOOKS.md |

### Feature List Immutability

**Critical Rule**: "It is unacceptable to remove or edit tests because this could lead to missing or buggy functionality."

Only the `passes` field should change from `false` to `true`. Never:
- Remove feature definitions
- Edit feature descriptions
- Lower the total count
- Skip features marked as high priority

### Git as Source of Truth

Use git effectively:
- Commit after each completed feature
- Write descriptive commit messages
- Use git log to understand recent changes
- Create checkpoints that can be restored
- Document why changes were made in commit messages

## Testing and Validation

### End-to-End Testing Tools

Provide agents with tools to verify features work:
- **Browser automation**: Puppeteer MCP, Playwright, Cypress for web apps
- **API testing**: curl, Postman, automated test suites for backends
- **Mobile testing**: Simulators, device testing for mobile apps

**Why this matters**: Agents tend to mark features complete without proper testing. Explicit prompting and verification tools dramatically improve outcomes.

### Testing Workflow

1. **Before starting new feature**: Run integration test to catch existing bugs
2. **During implementation**: Test incrementally
3. **Before marking complete**: Test end-to-end as a real user would
4. **After marking complete**: Update tests.json with passing status

### Verification Requirements

**Insufficient**:
- Code looks correct
- Unit tests pass
- API returns 200 OK

**Sufficient**:
- Feature works end-to-end in actual UI/API
- Tested with real user workflow
- Edge cases verified
- Error states handled

## Claude 4.x Specific Features

### Parallel Tool Execution

Claude 4.x models excel at parallel tool execution. Maximize efficiency:

```
If you intend to call multiple tools and there are no dependencies between the 
tool calls, make all of the independent tool calls in parallel. Prioritize calling 
tools simultaneously whenever the actions can be done in parallel rather than 
sequentially. For example, when reading 3 files, run 3 tool calls in parallel to 
read all 3 files into context at the same time.
```

### Tool Usage Guidance

Claude 4.x models are precise instruction followers. Be explicit:

**Less effective**: "Can you suggest some changes?"
**More effective**: "Change this function to improve its performance."

**Proactive action prompt**:
```
By default, implement changes rather than only suggesting them. If the user's 
intent is unclear, infer the most useful likely action and proceed, using tools 
to discover any missing details instead of guessing.
```

### Communication Style

Claude 4.x models are naturally more concise. For visibility into reasoning:

```
After completing a task that involves tool use, provide a quick summary of the 
work you've done.
```

### Extended Thinking

For complex reasoning after tool use:

```
After receiving tool results, carefully reflect on their quality and determine 
optimal next steps before proceeding. Use your thinking to plan and iterate based 
on this new information, and then take the best next action.
```

### Minimizing Hallucinations

For coding agents specifically:

```
ALWAYS read and understand relevant files before proposing code edits. Do not 
speculate about code you have not inspected. If the user references a specific 
file/path, you MUST open and inspect it before explaining or proposing fixes. 
Be rigorous and persistent in searching code for key facts.
```

### Avoiding Over-Engineering

Claude Opus 4.5 can over-engineer. To keep solutions minimal:

```
Avoid over-engineering. Only make changes that are directly requested or clearly 
necessary. Keep solutions simple and focused. Don't add features, refactor code, 
or make "improvements" beyond what was asked. A bug fix doesn't need surrounding 
code cleaned up. A simple feature doesn't need extra configurability.
```

### Frontend Design Quality

To avoid generic "AI slop" aesthetics:

```
Focus on:
- Typography: Choose fonts that are beautiful, unique, and interesting. Avoid 
  generic fonts like Arial and Inter
- Color & Theme: Commit to a cohesive aesthetic. Dominant colors with sharp 
  accents outperform timid, evenly-distributed palettes
- Motion: Use animations for effects and micro-interactions. Focus on high-impact 
  moments
- Backgrounds: Create atmosphere and depth rather than defaulting to solid colors

Avoid:
- Overused font families (Inter, Roboto, Arial, system fonts)
- Clichéd color schemes (particularly purple gradients on white backgrounds)
- Predictable layouts and component patterns
```

## Common Failure Modes and Solutions

| Problem | Initializer Agent Behavior | Coding Agent Behavior |
|---------|---------------------------|----------------------|
| Claude declares victory too early | Set up feature list file with 50-200+ features | Read feature list at start; choose ONE feature to work on |
| Claude leaves environment with bugs | Create git repo and progress notes file | Start session by reading progress notes and git log; run baseline test |
| Claude marks features done prematurely | Set up structured feature list | Self-verify all features end-to-end; only mark passing after testing |
| Claude spends time figuring out setup | Write init.sh script | Start session by running init.sh |
| Claude loses context between sessions | Create comprehensive initial documentation | Read all state files at session start |

### Specific Anti-Patterns to Avoid

**Agent Design**:
- ❌ Not having an initializer agent for long-running projects
- ❌ Using only one agent type without specialization
- ❌ Letting agents modify feature list structure
- ❌ Not documenting technical debt

**Feature Management**:
- ❌ Creating too few features (<30) that miss edge cases
- ❌ Using unstructured formats (Markdown lists instead of JSON)
- ❌ Allowing agents to remove tests to "complete" projects
- ❌ Not categorizing features by priority

**State Management**:
- ❌ Relying only on context compaction without filesystem state
- ❌ Not using git for tracking changes
- ❌ Missing init scripts for environment setup
- ❌ Not documenting "next steps" at end of sessions

**Testing**:
- ❌ Not providing testing tools (Playwright, etc.)
- ❌ Accepting that "code looks right" without verification
- ❌ Not running baseline tests at session start
- ❌ Skipping end-to-end testing before marking complete

## Implementation Checklist

### First Session (Initializer Agent)
- [ ] Create feature list with 50-200+ features in JSON format
- [ ] Set up git repository with initial commit
- [ ] Write init.sh script to start development environment
- [ ] Create claude-progress.txt for freeform notes
- [ ] Establish baseline integration test
- [ ] Document conventions and patterns
- [ ] Add instructions about feature list immutability
- [ ] Verify development environment works

### Subsequent Sessions (Coding Agent)
- [ ] Run pwd to confirm directory
- [ ] Read claude-progress.txt for context
- [ ] Check git log for recent changes
- [ ] Review feature list status
- [ ] Run init.sh to start environment
- [ ] Execute baseline integration test
- [ ] Choose ONE feature to implement
- [ ] Implement feature completely
- [ ] Test feature end-to-end
- [ ] Commit with descriptive message
- [ ] Update tests.json to mark feature passing
- [ ] Update claude-progress.txt with summary

## Resources

- [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) - Anthropic Research
- [Claude 4 Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices) - Anthropic Documentation
- [Claude Agent SDK Quickstart](https://github.com/anthropics/claude-quickstarts/tree/main/autonomous-coding) - Example Implementation

---

**Version**: 1.0
**Last Updated**: January 2025
**Based on**: Anthropic's long-running agents research and Claude 4.5 capabilities
