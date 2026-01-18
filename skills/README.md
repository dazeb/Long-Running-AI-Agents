# Agent Skills System

This directory contains **composable skills** that enhance all agents in this repository. Skills are systematic workflows and methodologies that guide agents through complex processes from brainstorming to completion.

> **Source**: Skills adapted from [obra/superpowers](https://github.com/obra/superpowers) - A comprehensive skills library for Claude Code agents.

## What Are Skills?

Skills are **structured methodologies** that agents follow when performing specific types of work. Unlike agent capabilities (which define *what* an agent knows), skills define *how* agents should approach certain tasks.

Think of skills as:
- 📋 **Checklists** for complex processes
- 🛡️ **Safety protocols** to avoid common mistakes
- 🎯 **Best practices** codified into systematic workflows
- 🔄 **Repeatable processes** that work across projects

## Available Skills

### 🛠️ Development Skills

#### test-driven-development
**When to use**: Before implementing any feature or bugfix

Enforces the RED-GREEN-REFACTOR cycle:
1. Write failing test first (RED)
2. Watch it fail to verify it tests the right thing
3. Write minimal code to pass (GREEN)
4. Refactor while staying green

**Core principle**: If you didn't watch the test fail, you don't know if it tests the right thing.

**Key files**:
- `test-driven-development/SKILL.md` - Complete TDD methodology
- `test-driven-development/testing-anti-patterns.md` - Common mistakes to avoid

#### systematic-debugging
**When to use**: Encountering any bug, test failure, or unexpected behavior

Four-phase root cause analysis:
1. **Root Cause Investigation** - Gather evidence, reproduce, trace data flow
2. **Pattern Analysis** - Find working examples, compare differences
3. **Hypothesis Testing** - Form theory, test minimally
4. **Implementation** - Create failing test, fix root cause, verify

**Core principle**: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST

**Key files**:
- `systematic-debugging/SKILL.md` - Complete debugging methodology
- `systematic-debugging/root-cause-tracing.md` - Backward tracing technique
- `systematic-debugging/defense-in-depth.md` - Multi-layer validation
- `systematic-debugging/condition-based-waiting.md` - Replace timeouts with polling

#### verification-before-completion
**When to use**: Before marking any task as complete

Validates that fixes actually work through:
- Running full test suite
- Manual verification of specific functionality
- Checking for regressions
- Verifying edge cases

**Core principle**: Passing tests ≠ working feature. Verify the actual behavior.

### 📋 Planning Skills

#### brainstorming
**When to use**: Before any creative work - features, components, modifications

Collaborative design refinement through:
1. Understanding current project context
2. Asking questions one at a time (prefer multiple choice)
3. Exploring 2-3 approaches with trade-offs
4. Presenting design in 200-300 word sections
5. Validating each section before continuing

**Core principle**: YAGNI ruthlessly - remove unnecessary features from all designs.

**Output**: Design document in `docs/plans/YYYY-MM-DD-<topic>-design.md`

#### writing-plans
**When to use**: After design is complete, before implementation

Creates detailed implementation plans with:
- Bite-sized tasks (2-5 minutes each)
- Test-first approach for each task
- Clear acceptance criteria
- Task dependencies identified

**Output**: Implementation plan in `docs/plans/YYYY-MM-DD-<topic>-implementation.md`

#### executing-plans
**When to use**: When implementing from a plan

Systematic plan execution:
1. Read full plan first
2. Execute tasks in order
3. Use TDD for each task
4. Create human checkpoints for reviews
5. Update plan status as you progress

### 🤝 Collaboration Skills

#### dispatching-parallel-agents
**When to use**: When multiple independent tasks can run concurrently

Enables spawning up to 5 agents simultaneously for:
- Independent feature development
- Parallel testing and implementation
- Multi-component system work

**Example**: Backend API + Frontend UI + Tests all in parallel

#### requesting-code-review
**When to use**: Before submitting code for human review

Pre-review validation checklist:
- Tests pass and cover new code
- Code follows project conventions
- No debug code or TODOs left
- Documentation updated
- Spec compliance verified

#### receiving-code-review
**When to use**: After receiving review feedback

Structured feedback response:
1. Read all feedback completely
2. Group related comments
3. Address in priority order
4. Verify each fix
5. Respond to reviewer with changes

#### subagent-driven-development
**When to use**: For two-stage code review process

Implements:
1. **Spec Reviewer** - Validates against requirements
2. **Code Reviewer** - Evaluates code quality

Two agents review independently, providing comprehensive feedback.

### 🔄 Workflow Skills

#### using-git-worktrees
**When to use**: When working on multiple features simultaneously

Creates isolated development branches using Git worktrees:
- Work on multiple features without stashing
- Test different approaches in parallel
- Keep main workspace clean

#### finishing-a-development-branch
**When to use**: When feature work is complete

Systematic branch completion:
1. Final verification (tests, linting, manual testing)
2. Decide: Merge directly or create PR
3. Clean up temporary artifacts
4. Update documentation
5. Close related issues

### 🎓 Meta Skills

#### using-superpowers
**When to use**: Introduction to the skills system

Overview of all available skills and when to use them.

#### writing-skills
**When to use**: Creating new skills for this system

Methodology for creating well-structured, testable skills with:
- Clear activation criteria
- Step-by-step procedures
- Examples and anti-patterns
- Verification checklists

## How Agents Use Skills

### Automatic Activation

Agents should automatically use relevant skills based on task context:

```markdown
Task: "Fix the authentication bug"
→ Agent activates: systematic-debugging skill
→ Follows four-phase investigation
→ Creates failing test
→ Implements fix
→ Uses verification-before-completion

Task: "Add user profile feature"
→ Agent activates: brainstorming skill
→ Explores design options
→ Creates design document
→ Activates: writing-plans skill
→ Creates implementation plan
→ Activates: test-driven-development for each task
→ Uses verification-before-completion when done
```

### Skill References in Agent Definitions

Agents reference skills in their documentation:

```markdown
## Best Practices
- Use the `test-driven-development` skill for all feature work
- Apply `systematic-debugging` when encountering issues
- Start complex features with `brainstorming` skill
```

### Skill Chaining

Skills often work together in sequences:

1. **Feature Development Chain**:
   - `brainstorming` → `writing-plans` → `executing-plans` → `test-driven-development` → `verification-before-completion`

2. **Bug Fix Chain**:
   - `systematic-debugging` → `test-driven-development` → `verification-before-completion`

3. **Collaborative Development Chain**:
   - `brainstorming` → `writing-plans` → `dispatching-parallel-agents` → `requesting-code-review` → `receiving-code-review`

## Integration with Existing Agent System

### Skills vs. Capabilities

| Aspect | Skills | Capabilities |
|--------|--------|--------------|
| **What** | HOW to do work | WHAT agent knows |
| **Scope** | Process/methodology | Knowledge/expertise |
| **Usage** | Activated by context | Always available |
| **Location** | `.claude/skills/` | Agent definition `## Capabilities` |
| **Sharing** | Used by all agents | Specific to agent |

### Skills + Agents = Powerful Workflows

**Example**: React Next.js Specialist + Skills

```markdown
Agent: @react-nextjs-specialist
Capabilities: React 18+, Next.js 14+, TypeScript, SSR, etc.
Skills:
  - test-driven-development (for all feature work)
  - systematic-debugging (for performance issues)
  - brainstorming (for complex component design)

When user asks: "Add a shopping cart feature"
1. Agent uses brainstorming skill to design the feature
2. Agent uses writing-plans skill to break down implementation
3. Agent uses test-driven-development skill for each component
4. Agent applies React/Next.js expertise (capabilities)
5. Agent uses verification-before-completion before finishing
```

## Skill Activation Patterns

### Explicit Activation
User explicitly requests a skill:
```
"Use TDD to implement the login feature"
"Debug this systematically"
"Let's brainstorm this feature first"
```

### Implicit Activation
Agent detects context requiring a skill:
```
Bug encountered → systematic-debugging
New feature → brainstorming + test-driven-development
Test failure → systematic-debugging + test-driven-development
Code review request → requesting-code-review
```

### Multi-Skill Workflows
Complex tasks may use multiple skills:
```
"Build a new payment system"
→ brainstorming (design)
→ writing-plans (implementation strategy)
→ using-git-worktrees (isolated workspace)
→ test-driven-development (for each component)
→ dispatching-parallel-agents (parallel work)
→ verification-before-completion (final check)
→ finishing-a-development-branch (merge/PR)
```

## Best Practices for Agents

### DO ✅
- Reference skills by name when using them: "Following test-driven-development skill..."
- Complete each phase of a skill before proceeding
- Chain skills naturally based on task requirements
- Use skills proactively without waiting for explicit requests

### DON'T ❌
- Skip steps within a skill workflow
- Mix partial skill approaches (do TDD properly or don't)
- Rationalize skipping skills ("too simple for TDD")
- Use skills as optional suggestions (they're mandatory for quality)

## Adding New Skills

To add a new skill to this system:

1. Create directory: `.claude/skills/your-skill-name/`
2. Create `SKILL.md` with frontmatter:
   ```yaml
   ---
   name: your-skill-name
   description: When to use this skill
   ---
   ```
3. Document:
   - Overview
   - When to use
   - Step-by-step process
   - Examples
   - Anti-patterns
   - Verification checklist
4. Add to `.claude-plugin/plugin.json` skills section
5. Update this README
6. Reference in relevant agent definitions

## Resources

- **Original Skills Repository**: https://github.com/obra/superpowers
- **Skills Directory**: `.claude/skills/`
- **Plugin Configuration**: `.claude-plugin/plugin.json`
- **Agent Definitions**: `.claude/agents/{category}/{agent-name}.md`

## Philosophy

> "Skills are not optional suggestions - they're proven methodologies that separate professional software development from ad-hoc coding. Follow them systematically, and you'll write better code faster with fewer bugs."

The skills system embodies:
- **Test-first always** - No production code without failing tests
- **Systematic over random** - Structured investigation beats guessing
- **YAGNI ruthlessly** - Simplicity is the primary objective
- **Evidence-based** - Verify assumptions, don't trust instincts
- **Process over shortcuts** - Proper method is faster than rework
