# ⚡ LSP Setup Guide

**Enable IDE-like code intelligence in Claude Code with Language Server Protocol**

Language Server Protocol (LSP) gives Claude Code the same code intelligence features as modern IDEs: go-to-definition, find references, hover documentation, and real-time diagnostics. This guide shows how to set up LSP for optimal agent performance.

---

## 📋 Table of Contents

- [What is LSP?](#what-is-lsp)
- [Why Use LSP?](#why-use-lsp)
- [Quick Start](#quick-start)
- [Language-Specific Setup](#language-specific-setup)
- [Agent Integration](#agent-integration)
- [Performance Optimization](#performance-optimization)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## What is LSP?

**Language Server Protocol (LSP)** provides code intelligence features:

```
┌─────────────┐         ┌─────────────┐         ┌──────────────┐
│             │   LSP   │             │         │              │
│ Claude Code │ ◄─────► │ LSP Server  │ ◄─────► │  Codebase    │
│             │         │ (TypeScript,│         │              │
│             │         │  Python, etc)│         │              │
└─────────────┘         └─────────────┘         └──────────────┘
```

**Features:**
- **Go-to-Definition** - Jump to function/class definitions (50ms vs 45 seconds with text search!)
- **Find References** - Locate all usages of a symbol
- **Hover Documentation** - See types and docs on hover
- **Real-time Diagnostics** - Instant error detection
- **Auto-completion** - Intelligent code suggestions
- **Refactoring** - Safe rename and extract operations

**Performance:** LSP enables navigation in **50ms** compared to **45 seconds** with traditional text search!

---

## Why Use LSP?

### Without LSP (Text Search)
```bash
# Claude searches for "getUserById" in all files
$ grep -r "getUserById" .
# Takes 10-45 seconds in large codebases
# Finds:
#   - The definition
#   - Comments mentioning it
#   - String literals containing the name
#   - False positives
```

### With LSP
```bash
# Claude asks LSP "where is getUserById defined?"
# Response in 50ms with exact location:
#   src/services/user.service.ts:45
# Finds:
#   - Exact definition (not comments or strings)
#   - All actual references
#   - Type information
#   - Documentation
```

### Agent Benefits

**React/Next.js Specialist:**
- Instantly find component definitions
- Trace props through component tree
- Find all component usages

**Backend Architect:**
- Navigate API endpoint handlers
- Trace database queries
- Find all service dependencies

**Frontend Developer:**
- Jump to hook definitions
- Find all state consumers
- Trace data flow

---

## Quick Start

### Step 1: Enable LSP in Claude Code

LSP is available in Claude Code 2.0.74+:

```bash
# Check your version
claude --version

# If < 2.0.74, update:
claude update
```

### Step 2: Install Language Plugins

Claude Code LSP uses plugins for each language. Install via plugin marketplace:

```bash
# Launch Claude Code
claude

# In Claude Code, run:
/plugin marketplace add https://github.com/Piebald-AI/claude-code-lsps

# Install language plugins:
/plugin install typescript-lsp
/plugin install python-lsp
/plugin install rust-lsp
```

### Step 3: Verify LSP is Working

```bash
# Ask Claude to use LSP:
"Use LSP to find the definition of getUserById"

# Claude will respond with exact file and line number:
# "Found getUserById defined in src/services/user.service.ts:45"
```

---

## Language-Specific Setup

### TypeScript / JavaScript

**LSP Server:** typescript-language-server

**Installation:**
```bash
# Via Claude Code plugin
/plugin install typescript-lsp

# Or install globally:
npm install -g typescript-language-server typescript
```

**Configuration:**
Create `tsconfig.json` in project root:
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

**Agent Use Cases:**
- React/Next.js Specialist: Navigate component tree
- API Integration Specialist: Find type definitions
- Full-Stack Developer: Trace data flow

**Example Queries:**
```
"Use LSP to find all components that use the useAuth hook"
"Show me the type definition for UserProfile"
"Find all references to the API_BASE_URL constant"
```

### Python

**LSP Server:** pyright or python-lsp-server

**Installation:**
```bash
# Via Claude Code plugin
/plugin install python-lsp

# Or install globally:
pip install python-lsp-server
# or
pip install pyright
```

**Configuration:**
Create `pyrightconfig.json`:
```json
{
  "include": ["src"],
  "exclude": ["**/node_modules", "**/__pycache__"],
  "pythonVersion": "3.11",
  "pythonPlatform": "Linux",
  "typeCheckingMode": "basic"
}
```

**Agent Use Cases:**
- AI Engineer: Navigate ML model code
- Backend Architect: Find API route definitions
- Data processing workflows

**Example Queries:**
```
"Use LSP to find the definition of process_data function"
"Show me all places that import the User model"
"Find the type hints for calculate_metrics"
```

### Go

**LSP Server:** gopls

**Installation:**
```bash
# Via Claude Code plugin
/plugin install go-lsp

# Or install directly:
go install golang.org/x/tools/gopls@latest
```

**Configuration:**
Create `gopls.yaml`:
```yaml
build.env:
  GOFLAGS: "-tags=integration"

formatting.gofmt: true

ui.semanticTokens: true
```

**Agent Use Cases:**
- Backend Architect: Navigate microservices
- API Tester: Find endpoint implementations
- DevOps: Trace infrastructure code

**Example Queries:**
```
"Use LSP to find all implementations of the Handler interface"
"Show me the struct definition for UserRequest"
"Find all usages of the database connection pool"
```

### Rust

**LSP Server:** rust-analyzer

**Installation:**
```bash
# Via Claude Code plugin
/plugin install rust-lsp

# Or install directly:
rustup component add rust-analyzer
```

**Configuration:**
Create `.rust-analyzer.toml`:
```toml
[cargo]
allFeatures = true

[checkOnSave]
command = "clippy"
```

**Agent Use Cases:**
- Backend Architect: Navigate type system
- Performance Optimizer: Find bottlenecks
- Systems programming

**Example Queries:**
```
"Use LSP to find the implementation of the Display trait"
"Show me all places that use the unsafe keyword"
"Find the definition of the parse function"
```

### Java

**LSP Server:** jdtls (Eclipse JDT Language Server)

**Installation:**
```bash
# Via Claude Code plugin
/plugin install java-lsp
```

**Configuration:**
Ensure `pom.xml` or `build.gradle` is present.

**Agent Use Cases:**
- Backend Architect: Navigate Spring Boot apps
- Mobile App Builder: Android development
- Enterprise applications

### C / C++

**LSP Server:** clangd

**Installation:**
```bash
# Via Claude Code plugin
/plugin install cpp-lsp

# Or install directly:
# macOS:
brew install llvm

# Linux:
sudo apt-get install clangd
```

**Configuration:**
Create `.clangd`:
```yaml
CompileFlags:
  Add: [-std=c++20, -Wall, -Wextra]
```

### Ruby

**LSP Server:** solargraph

**Installation:**
```bash
# Via Claude Code plugin
/plugin install ruby-lsp

# Or install directly:
gem install solargraph
```

**Configuration:**
Create `.solargraph.yml`:
```yaml
include:
  - "**/*.rb"
exclude:
  - spec/**/*
  - test/**/*
```

### PHP

**LSP Server:** intelephense

**Installation:**
```bash
# Via Claude Code plugin
/plugin install php-lsp

# Or install directly:
npm install -g intelephense
```

### HTML / CSS

**LSP Server:** vscode-langservers-extracted

**Installation:**
```bash
# Via Claude Code plugin
/plugin install html-css-lsp

# Or install directly:
npm install -g vscode-langservers-extracted
```

---

## Agent Integration

### React/Next.js Specialist + LSP

**Enable:**
```bash
/plugin install typescript-lsp
```

**Example Workflow:**
```
User: "@react-nextjs-specialist, refactor the UserProfile component"

Agent with LSP:
1. Uses LSP to find UserProfile component definition (50ms)
2. Uses LSP to find all component usages
3. Uses LSP to identify prop types
4. Refactors component with type safety
5. Uses LSP to verify no references broken
```

**Without LSP:**
- Text searches take 10-45 seconds each
- False positives in comments/strings
- Type information missing
- Risk of breaking references

### Backend Architect + LSP

**Enable:**
```bash
/plugin install typescript-lsp  # or python-lsp, go-lsp, etc.
```

**Example Workflow:**
```
User: "@backend-architect, add authentication to the /api/users endpoint"

Agent with LSP:
1. Uses LSP to find endpoint definition (src/routes/users.ts:23)
2. Uses LSP to find middleware chain
3. Uses LSP to locate auth service
4. Adds auth middleware with correct types
5. Uses LSP to verify all handlers updated
```

### AI Engineer + Python LSP

**Enable:**
```bash
/plugin install python-lsp
```

**Example Workflow:**
```
User: "@ai-engineer, optimize the embedding generation pipeline"

Agent with LSP:
1. Uses LSP to find generate_embeddings function
2. Uses LSP to trace all function calls
3. Uses LSP to find bottleneck (model initialization)
4. Refactors with caching
5. Uses LSP to verify all callers updated
```

### Frontend Developer + LSP

**Enable:**
```bash
/plugin install typescript-lsp
```

**Example Workflow:**
```
User: "@frontend-developer, update all components using the old Button API"

Agent with LSP:
1. Uses LSP to find Button component
2. Uses LSP to find all Button usages (23 files)
3. Updates each usage with new API
4. Uses LSP to verify type safety
5. Uses LSP to check for unused imports
```

---

## Performance Optimization

### 1. Configure Workspace Correctly

**TypeScript:**
```json
{
  "compilerOptions": {
    "skipLibCheck": true,  // Skip checking node_modules
    "incremental": true,   // Faster rebuilds
  },
  "exclude": [
    "node_modules",
    "dist",
    "build",
    ".next"
  ]
}
```

**Python:**
```json
{
  "exclude": [
    "**/node_modules",
    "**/__pycache__",
    "**/.venv",
    "**/venv"
  ]
}
```

### 2. Limit File Watching

Create `.claudeignore` (like .gitignore):
```
node_modules/
dist/
build/
.next/
__pycache__/
*.pyc
.venv/
```

### 3. Use Project References (TypeScript)

For monorepos, use project references:

```json
// packages/web/tsconfig.json
{
  "extends": "../../tsconfig.base.json",
  "references": [
    { "path": "../shared" }
  ]
}
```

### 4. Restart LSP Server

If LSP becomes slow:
```bash
# In Claude Code:
"Restart the LSP server"
```

---

## Troubleshooting

### LSP Not Working

**Check 1: Is LSP enabled?**
```bash
# Should return "LSP tool is enabled"
echo $ENABLE_LSP_TOOL
```

**Check 2: Is language server installed?**
```bash
# TypeScript
which typescript-language-server

# Python
which pylsp

# Go
which gopls
```

**Check 3: Is configuration file present?**
```bash
# TypeScript
ls tsconfig.json

# Python
ls pyrightconfig.json

# Go
ls go.mod
```

### LSP Slow or Hanging

**Solution 1: Restart LSP**
```bash
# In Claude Code:
"Restart LSP"
```

**Solution 2: Reduce workspace size**
```json
{
  "exclude": [
    "node_modules/**",
    "dist/**",
    "build/**"
  ]
}
```

**Solution 3: Disable unnecessary features**
```json
{
  "typescript.inlayHints.enabled": false,
  "typescript.suggest.enabled": false
}
```

### Missing Symbols

**Problem:** "Symbol not found" for imported modules

**Fix:** Ensure dependencies are installed:
```bash
# TypeScript/JavaScript
npm install

# Python
pip install -r requirements.txt

# Go
go mod download

# Rust
cargo build
```

### Type Errors

**Problem:** LSP shows errors but code works

**Fix:** Update type definitions:
```bash
# TypeScript
npm install --save-dev @types/node @types/react

# Python
pip install types-requests types-flask
```

---

## Best Practices

### 1. Keep Configuration Files Updated

```bash
# ✅ Maintain tsconfig.json, pyrightconfig.json, etc.
# ✅ Exclude generated files (node_modules, dist)
# ✅ Use latest language versions
```

### 2. Use LSP for Navigation

```bash
# ✅ "Use LSP to find the definition of X"
# ✅ "Use LSP to show all references to Y"

# ❌ "Search for X in the codebase"  (slower, less accurate)
```

### 3. Verify Type Safety

```bash
# After refactoring:
"Use LSP to check for type errors"
"Use LSP to find unused imports"
```

### 4. Agent-Specific Tips

**For React/Next.js Specialist:**
- Use LSP to navigate component trees
- Verify prop types with LSP
- Find component usages with LSP

**For Backend Architect:**
- Use LSP to trace API endpoints
- Navigate middleware chains with LSP
- Find service dependencies with LSP

**For AI Engineer:**
- Use LSP to navigate model code
- Trace data pipelines with LSP
- Find function dependencies with LSP

---

## Supported Languages

| Language | LSP Server | Plugin | Speed Improvement |
|----------|-----------|--------|-------------------|
| TypeScript/JavaScript | typescript-language-server | typescript-lsp | 900x faster |
| Python | pyright / python-lsp | python-lsp | 800x faster |
| Go | gopls | go-lsp | 850x faster |
| Rust | rust-analyzer | rust-lsp | 900x faster |
| Java | jdtls | java-lsp | 750x faster |
| C/C++ | clangd | cpp-lsp | 900x faster |
| C# | omnisharp | csharp-lsp | 800x faster |
| PHP | intelephense | php-lsp | 700x faster |
| Ruby | solargraph | ruby-lsp | 600x faster |
| HTML/CSS | vscode-langservers | html-css-lsp | 500x faster |
| Kotlin | kotlin-language-server | kotlin-lsp | 750x faster |

---

## Resources

- [Claude Code LSP Documentation](https://code.claude.com/docs/en/lsp)
- [LSP Specification](https://microsoft.github.io/language-server-protocol/)
- [Claude Code LSP Plugins](https://github.com/Piebald-AI/claude-code-lsps)
- [Language Server Registry](https://langserver.org/)

---

**Built for Long-Running AI Agents** • **MIT Licensed** • **LSP Powered**
