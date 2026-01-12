# 🔌 MCP Integration Guide

**Extend Claude Code with Model Context Protocol (MCP) Servers**

Model Context Protocol (MCP) is an open standard that enables Claude Code to connect to external tools, databases, and APIs. This guide shows how to integrate MCP servers with our Long-Running AI Agents.

---

## 📋 Table of Contents

- [What is MCP?](#what-is-mcp)
- [Quick Start](#quick-start)
- [Recommended MCP Servers](#recommended-mcp-servers)
- [Configuration](#configuration)
- [Agent-Specific Integrations](#agent-specific-integrations)
- [Building Custom MCP Servers](#building-custom-mcp-servers)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## What is MCP?

**Model Context Protocol (MCP)** is an open source protocol that connects AI systems to data sources and tools:

```
┌─────────────┐         ┌─────────────┐         ┌──────────────┐
│             │   MCP   │             │   API   │              │
│ Claude Code │ ◄─────► │ MCP Server  │ ◄─────► │ External API │
│             │         │             │         │              │
└─────────────┘         └─────────────┘         └──────────────┘
```

**Benefits:**
- ✅ Access live data (GitHub, databases, APIs)
- ✅ Connect to specialized tools (research, search, documentation)
- ✅ Extend agent capabilities without code changes
- ✅ Standardized protocol (works across all AI tools)

---

## Quick Start

### Step 1: Install Claude Code MCP Support

MCP support is built into Claude Code 2.0+. No additional installation needed!

### Step 2: Create `.mcp.json` Configuration

In your project root, create `.mcp.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### Step 3: Set Environment Variables

```bash
# Add to ~/.bashrc or ~/.zshrc
export GITHUB_TOKEN="your_github_token_here"
```

### Step 4: Use in Claude Code

```bash
# Claude now has access to GitHub via MCP!
# Ask: "List all open pull requests in this repo"
# Ask: "Show me issues labeled 'bug'"
```

---

## Recommended MCP Servers

### 1. **GitHub MCP** - Essential for Development

**What it does:** Access GitHub repos, issues, PRs, and code

**Install:**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Use with:**
- **Project Initializer**: Analyze existing repo structure
- **DevOps Automator**: Set up CI/CD workflows
- **Backend Architect**: Review API endpoint implementations

**Example queries:**
```
"List all open issues labeled 'bug'"
"Show me the latest 5 commits"
"Create a new issue for the user authentication bug"
"List all PRs awaiting review"
```

### 2. **Perplexity MCP** - Real-Time Web Research

**What it does:** Search the web for current information

**Install:**
```json
{
  "mcpServers": {
    "perplexity": {
      "command": "npx",
      "args": ["-y", "@perplexity/mcp-server"],
      "env": {
        "PERPLEXITY_API_KEY": "${PERPLEXITY_API_KEY}"
      }
    }
  }
}
```

**Use with:**
- **AI Engineer**: Research latest LLM techniques
- **Trend Researcher**: Analyze market trends
- **Content Creator**: Find current statistics

**Example queries:**
```
"What are the latest Next.js 15 features?"
"Find best practices for React Server Components 2026"
"Research current TypeScript 5.5 recommendations"
```

### 3. **Sequential Thinking MCP** - Complex Problem Solving

**What it does:** Breaks down complex tasks systematically

**Install:**
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@sequential-thinking/mcp-server"]
    }
  }
}
```

**Use with:**
- **Project Initializer**: Plan large project structure
- **Backend Architect**: Design complex system architecture
- **Agent Creator**: Design new agent capabilities

**Example queries:**
```
"Break down building a real-time chat application"
"Plan the architecture for a multi-tenant SaaS"
"Design a scalable microservices system"
```

### 4. **Context7 MCP** - Up-to-Date Documentation

**What it does:** Access current framework documentation

**Install:**
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    }
  }
}
```

**Use with:**
- **React/Next.js Specialist**: Get latest API references
- **Frontend Developer**: Check current framework docs
- **Mobile App Builder**: Reference React Native docs

**Example queries:**
```
"Show me the latest Next.js App Router documentation"
"What's the current Tailwind CSS v4 config format?"
"Get React 19 hooks documentation"
```

### 5. **Claude Context MCP** - Semantic Codebase Search

**What it does:** Search your entire codebase semantically

**Install:**
```json
{
  "mcpServers": {
    "claude-context": {
      "command": "npx",
      "args": ["-y", "@zilliztech/claude-context"],
      "env": {
        "WORKSPACE_PATH": "${PWD}"
      }
    }
  }
}
```

**Use with:**
- **Backend Architect**: Find all API endpoint definitions
- **Frontend Developer**: Locate component usage patterns
- **Web Performance Optimizer**: Find performance bottlenecks

**Example queries:**
```
"Find all components that use useState"
"Show me where authentication is implemented"
"List all database query functions"
```

### 6. **Filesystem MCP** - File Operations

**What it does:** Read/write files, manage directories

**Install:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${PWD}"]
    }
  }
}
```

**Use with:**
- **Project Initializer**: Create project structure
- **DevOps Automator**: Manage config files
- **Content Creator**: Generate blog post files

### 7. **PostgreSQL MCP** - Database Access

**What it does:** Query and modify PostgreSQL databases

**Install:**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

**Use with:**
- **Backend Architect**: Design database schemas
- **API Tester**: Verify database state
- **Analytics Reporter**: Query production metrics

### 8. **Slack MCP** - Team Communication

**What it does:** Send messages, read channels, post updates

**Install:**
```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "${SLACK_BOT_TOKEN}"
      }
    }
  }
}
```

**Use with:**
- **Project Shipper**: Announce releases
- **Support Responder**: Monitor support channels
- **Team communication automation

---

## Configuration

### Complete .mcp.json Example

Create `.mcp.json` in your project root:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "perplexity": {
      "command": "npx",
      "args": ["-y", "@perplexity/mcp-server"],
      "env": {
        "PERPLEXITY_API_KEY": "${PERPLEXITY_API_KEY}"
      }
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@sequential-thinking/mcp-server"]
    },
    "claude-context": {
      "command": "npx",
      "args": ["-y", "@zilliztech/claude-context"],
      "env": {
        "WORKSPACE_PATH": "${PWD}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### Environment Variables

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# GitHub
export GITHUB_TOKEN="ghp_your_token_here"

# Perplexity
export PERPLEXITY_API_KEY="pplx-your-key-here"

# Database
export DATABASE_URL="postgresql://user:pass@localhost:5432/db"

# Slack
export SLACK_BOT_TOKEN="xoxb-your-token-here"
```

### User-Level Configuration

For servers used across all projects, add to `~/.config/claude-code/mcp.json`:

```json
{
  "mcpServers": {
    "perplexity": {
      "command": "npx",
      "args": ["-y", "@perplexity/mcp-server"],
      "env": {
        "PERPLEXITY_API_KEY": "${PERPLEXITY_API_KEY}"
      }
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@sequential-thinking/mcp-server"]
    }
  }
}
```

---

## Agent-Specific Integrations

### Project Initializer + GitHub MCP

**Setup:**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Usage:**
```
"@project-initializer, analyze the existing GitHub repo structure
and create a tests.json that matches the current implementation"
```

**Benefits:**
- Automatically discovers existing features
- Creates accurate task breakdown
- Integrates with existing workflows

### AI Engineer + Perplexity MCP

**Setup:**
```json
{
  "mcpServers": {
    "perplexity": {
      "command": "npx",
      "args": ["-y", "@perplexity/mcp-server"],
      "env": {
        "PERPLEXITY_API_KEY": "${PERPLEXITY_API_KEY}"
      }
    }
  }
}
```

**Usage:**
```
"@ai-engineer, research the latest RAG techniques for 2026
and implement a knowledge base system"
```

**Benefits:**
- Access to current AI research
- Latest best practices
- Up-to-date framework recommendations

### Backend Architect + PostgreSQL MCP

**Setup:**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

**Usage:**
```
"@backend-architect, analyze the current database schema
and design API endpoints for the new user management system"
```

**Benefits:**
- Understands existing schema
- Prevents conflicts
- Generates optimized queries

### Content Creator + Perplexity MCP

**Setup:**
```json
{
  "mcpServers": {
    "perplexity": {
      "command": "npx",
      "args": ["-y", "@perplexity/mcp-server"],
      "env": {
        "PERPLEXITY_API_KEY": "${PERPLEXITY_API_KEY}"
      }
    }
  }
}
```

**Usage:**
```
"@content-creator, research current web performance trends
and write a technical blog post with 2026 statistics"
```

**Benefits:**
- Current data and statistics
- Latest trends and insights
- Fact-checked content

---

## Building Custom MCP Servers

### Why Build Custom Servers?

- Connect to proprietary APIs
- Integrate internal tools
- Custom business logic
- Team-specific workflows

### Quick Start Template

```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server(
  {
    name: "custom-server",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Define tools
server.setRequestHandler("tools/list", async () => {
  return {
    tools: [
      {
        name: "custom_tool",
        description: "Does something useful",
        inputSchema: {
          type: "object",
          properties: {
            query: {
              type: "string",
              description: "The query to process",
            },
          },
          required: ["query"],
        },
      },
    ],
  };
});

// Handle tool calls
server.setRequestHandler("tools/call", async (request) => {
  if (request.params.name === "custom_tool") {
    // Your custom logic here
    const result = `Processed: ${request.params.arguments.query}`;

    return {
      content: [
        {
          type: "text",
          text: result,
        },
      ],
    };
  }

  throw new Error(`Unknown tool: ${request.params.name}`);
});

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main();
```

### Example: Internal API MCP Server

```typescript
// internal-api-server.ts
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import fetch from "node-fetch";

const server = new Server(
  {
    name: "internal-api",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

server.setRequestHandler("tools/list", async () => {
  return {
    tools: [
      {
        name: "get_customer",
        description: "Get customer data from internal API",
        inputSchema: {
          type: "object",
          properties: {
            customer_id: {
              type: "string",
              description: "Customer ID",
            },
          },
          required: ["customer_id"],
        },
      },
    ],
  };
});

server.setRequestHandler("tools/call", async (request) => {
  if (request.params.name === "get_customer") {
    const { customer_id } = request.params.arguments;

    const response = await fetch(
      `https://api.internal.company.com/customers/${customer_id}`,
      {
        headers: {
          Authorization: `Bearer ${process.env.INTERNAL_API_KEY}`,
        },
      }
    );

    const data = await response.json();

    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(data, null, 2),
        },
      ],
    };
  }
});

// Start server...
```

**Configuration:**
```json
{
  "mcpServers": {
    "internal-api": {
      "command": "node",
      "args": ["path/to/internal-api-server.js"],
      "env": {
        "INTERNAL_API_KEY": "${INTERNAL_API_KEY}"
      }
    }
  }
}
```

---

## Troubleshooting

### MCP Server Not Found

**Error:** `Command not found: npx`

**Fix:**
```bash
# Install Node.js and npm
# macOS:
brew install node

# Linux:
sudo apt-get install nodejs npm
```

### Connection Timeout

**Error:** `MCP server connection timeout`

**Fix:**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "timeout": 30000  // Increase timeout to 30 seconds
    }
  }
}
```

### Environment Variable Not Found

**Error:** `GITHUB_TOKEN is not defined`

**Fix:**
```bash
# Add to shell config
echo 'export GITHUB_TOKEN="your_token"' >> ~/.bashrc
source ~/.bashrc

# Or set in .mcp.json directly (not recommended for secrets):
{
  "mcpServers": {
    "github": {
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

### High Token Usage

**Problem:** MCP responses are very large

**Fix:**
- Use specific queries instead of broad searches
- Request summaries instead of full data
- Configure output limits in MCP server settings

---

## Best Practices

### 1. Security

```bash
# ✅ Use environment variables
export GITHUB_TOKEN="secret"

# ❌ Don't hardcode secrets
{
  "env": {
    "GITHUB_TOKEN": "ghp_hardcoded_secret"  // BAD!
  }
}
```

### 2. Performance

```json
// ✅ Only enable servers you need
{
  "mcpServers": {
    "github": { ... }  // Using GitHub? Enable it
  }
}

// ❌ Don't enable everything
{
  "mcpServers": {
    "github": { ... },
    "slack": { ... },
    "postgres": { ... },  // All enabled = slower startup
    "jira": { ... }
  }
}
```

### 3. Organization

```
# ✅ Project-specific servers
project/.mcp.json          # GitHub, project DB

# ✅ User-level servers
~/.config/claude-code/mcp.json  # Perplexity, Sequential Thinking
```

### 4. Token Management

When MCP responses exceed 10,000 tokens, Claude Code shows a warning. To manage this:

- Request specific data only
- Use filters and limits
- Ask for summaries first, then details

---

## Resources

- [Official MCP Documentation](https://modelcontextprotocol.io/)
- [MCP Server Registry](https://github.com/modelcontextprotocol/servers)
- [Claude Code MCP Guide](https://code.claude.com/docs/en/mcp)
- [Building MCP Servers](https://modelcontextprotocol.io/docs/develop)

---

**Built for Long-Running AI Agents** • **MIT Licensed** • **MCP Compatible**
