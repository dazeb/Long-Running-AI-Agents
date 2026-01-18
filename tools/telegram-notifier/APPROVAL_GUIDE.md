# 🔐 Telegram Approval System Guide

The Telegram Notifier includes a powerful **human-in-the-loop approval system** that allows Claude Code to request user authorization before executing sensitive operations.

## ✨ Overview

When Claude needs to perform actions that require human oversight, it can:
1. Send an approval request to Telegram with interactive buttons
2. Wait for the user to click **✅ Approve** or **❌ Deny**
3. Proceed or cancel based on the user's choice

This creates a **safe, auditable workflow** for AI-assisted development.

## 🎯 Use Cases

### Perfect For:
- **File modifications** - Editing configuration files, .env files
- **Database operations** - Deletions, migrations, schema changes
- **Deployments** - Pushing to production, running migrations
- **Security-sensitive tasks** - API key rotations, permission changes
- **Destructive operations** - Deleting files, dropping tables
- **Cost-incurring actions** - Cloud resource provisioning

### When to Use:
✅ Operations that can't be easily undone
✅ Actions that affect production systems
✅ Tasks involving sensitive data
✅ High-cost or high-impact operations
✅ Regulatory compliance requirements

## 🚀 Quick Start

### Command Line Usage

```bash
# Test the approval system
cd .claude/tools/telegram-notifier
node telegram-notifier.js approve "Test Action" "Testing approval workflow" 30000
```

This will:
1. Send a message to your Telegram with Approve/Deny buttons
2. Wait for you to click a button (30 second timeout)
3. Exit with code 0 (approved) or 1 (denied)

### Programmatic Usage

```javascript
const TelegramNotifier = require('./telegram-notifier');
const notifier = new TelegramNotifier();

// Request approval before executing sensitive operation
const approved = await notifier.requestApproval(
    'Modify database configuration',
    'Update production database connection strings',
    60000 // 60 second timeout
);

if (approved) {
    console.log('✅ Proceeding with database update...');
    // Your code here
} else {
    console.log('❌ Operation cancelled by user');
    process.exit(1);
}
```

## 📋 API Reference

### `requestApproval(action, details, timeout)`

Sends an approval request to Telegram and waits for user response.

**Parameters:**
- `action` (string) - Short description of the action (e.g., "Deploy to production")
- `details` (string, optional) - Additional context or details
- `timeout` (number, optional) - Timeout in milliseconds (default: 300000 = 5 minutes)

**Returns:**
- `Promise<boolean>` - `true` if approved, `false` if denied or timeout

**Example:**
```javascript
const approved = await notifier.requestApproval(
    'Delete old logs',
    'Remove 50GB of logs older than 90 days',
    30000
);
```

## 🎨 How It Works

### 1. **Request Sent**
Claude sends a formatted message to Telegram with inline keyboard buttons:

```
🤖 Claude Code Authorization Request

📋 Action: Deploy to Production
📝 Details: Deploy v2.4.1 with database migrations

⏰ Timeout: 60 seconds

Please approve or deny this action:
[✅ Approve] [❌ Deny]
```

### 2. **Polling for Response**
The system polls Telegram's API every 2 seconds checking for button clicks.

### 3. **User Responds**
User clicks either:
- ✅ **Approve** - Returns `true`, Claude proceeds
- ❌ **Deny** - Returns `false`, Claude cancels

### 4. **Confirmation Sent**
A follow-up message confirms the decision:

```
✅ Authorization APPROVED
Action: Deploy to Production
```

### 5. **Buttons Removed**
The interactive buttons are removed from the original message to prevent duplicate clicks.

## 💡 Best Practices

### Timeout Settings

Choose appropriate timeouts based on operation urgency:

```javascript
// Quick decisions (30 seconds)
await notifier.requestApproval('Format code', 'Run Prettier', 30000);

// Standard decisions (1-2 minutes)
await notifier.requestApproval('Database migration', 'Add new columns', 60000);

// Critical decisions (5 minutes)
await notifier.requestApproval('Production deploy', 'Deploy v2.0.0', 300000);
```

### Action Descriptions

Be **clear and specific** in your action descriptions:

✅ **Good:**
```javascript
await notifier.requestApproval(
    'Delete user accounts',
    'Permanently delete 15 inactive accounts (>1 year)',
    60000
);
```

❌ **Bad:**
```javascript
await notifier.requestApproval(
    'Delete stuff',
    'Clean up',
    60000
);
```

### Error Handling

Always handle approval failures gracefully:

```javascript
try {
    const approved = await notifier.requestApproval('Risky operation', 'Details...');

    if (!approved) {
        console.log('❌ User denied operation');
        await cleanup(); // Rollback any preparatory steps
        return;
    }

    // Proceed with operation
    await executeRiskyOperation();

} catch (error) {
    console.error('❌ Approval system error:', error);
    // Don't proceed if approval system fails
    return;
}
```

### Multiple Approval Steps

For complex workflows, request approval at each critical step:

```javascript
// Step 1: Approve backup
const backupApproved = await notifier.requestApproval(
    'Create database backup',
    'Backup current production database before migration'
);
if (!backupApproved) return;

await createBackup();

// Step 2: Approve migration
const migrationApproved = await notifier.requestApproval(
    'Run database migration',
    'Execute 5 SQL migration scripts on production'
);
if (!migrationApproved) return;

await runMigrations();

// Step 3: Approve verification
const verifyApproved = await notifier.requestApproval(
    'Verify migration success',
    'Run verification queries and health checks'
);
if (!verifyApproved) return;

await verifyMigration();
```

## 🔧 Integration with Claude Code

### Workflow Integration

When Claude Code needs approval, it can pause and wait for user input:

```javascript
// Claude Code workflow
async function deployToProduction() {
    const notifier = new TelegramNotifier();

    // 1. Notify user of intent
    await notifier.sendMessage('📦 Starting production deployment process...');

    // 2. Request approval
    const approved = await notifier.requestApproval(
        'Deploy to Production',
        `Deploy ${version} to production environment with:
- Database migrations (3 scripts)
- New API endpoints
- Breaking changes in auth flow`,
        120000
    );

    if (!approved) {
        await notifier.sendMessage('❌ Deployment cancelled by user');
        return false;
    }

    // 3. Execute deployment
    await notifier.sendMessage('🚀 Deployment approved - starting now...');
    await executeDeploy();

    // 4. Confirm completion
    await notifier.notifyDeployment(version, 'production', 'success');

    return true;
}
```

### Script Integration

Add approval gates to existing scripts:

```bash
#!/bin/bash
# deploy.sh with approval gate

echo "Requesting deployment approval..."
node .claude/tools/telegram-notifier/telegram-notifier.js approve \
    "Deploy to Production" \
    "Deploy v2.4.1 with database migrations" \
    60000

if [ $? -eq 0 ]; then
    echo "✅ Approved - deploying..."
    docker-compose up -d
    npm run migrate
else
    echo "❌ Denied - aborting deployment"
    exit 1
fi
```

## 📊 Example Workflows

### Example 1: Configuration File Updates

```javascript
const fs = require('fs');
const notifier = new TelegramNotifier();

async function updateConfig() {
    // Show what will change
    const oldConfig = fs.readFileSync('.env', 'utf8');
    const changes = 'Update API_KEY and DATABASE_URL';

    // Request approval
    const approved = await notifier.requestApproval(
        'Update .env file',
        changes,
        45000
    );

    if (!approved) {
        console.log('❌ Config update cancelled');
        return;
    }

    // Update file
    fs.writeFileSync('.env', newConfig);
    await notifier.sendMessage('✅ Configuration updated successfully');
}
```

### Example 2: Database Cleanup

```javascript
async function cleanupOldRecords() {
    const notifier = new TelegramNotifier();

    // Count records to be deleted
    const count = await db.count('users', { lastLogin: { $lt: cutoffDate } });

    // Request approval with specific details
    const approved = await notifier.requestApproval(
        'Delete inactive user accounts',
        `Delete ${count} accounts with no login in past 365 days`,
        90000
    );

    if (!approved) {
        await notifier.sendMessage('❌ Cleanup cancelled - no records deleted');
        return;
    }

    // Execute deletion
    const result = await db.delete('users', { lastLogin: { $lt: cutoffDate } });
    await notifier.sendMessage(`✅ Deleted ${result.deletedCount} inactive accounts`);
}
```

### Example 3: Cloud Resource Provisioning

```javascript
async function provisionResources() {
    const notifier = new TelegramNotifier();

    const cost = calculateMonthlyCost(resourceSpec);

    const approved = await notifier.requestApproval(
        'Provision cloud resources',
        `Create 3 EC2 instances + RDS database
Estimated cost: $${cost}/month`,
        120000
    );

    if (!approved) {
        await notifier.sendMessage('❌ Resource provisioning cancelled');
        return;
    }

    await notifier.sendMessage('⚙️ Provisioning resources...');
    const resources = await aws.provision(resourceSpec);
    await notifier.sendMessage(`✅ Resources provisioned
Instance IDs: ${resources.instances.join(', ')}
Database endpoint: ${resources.db.endpoint}`);
}
```

## 🔒 Security Considerations

### 1. **Timeout Settings**
- Use shorter timeouts (30-60s) for routine operations
- Longer timeouts (2-5min) for critical decisions requiring review
- Timeouts prevent indefinite blocking

### 2. **Audit Trail**
- All approvals/denials are logged in Telegram chat
- Permanent record of who approved what and when
- Can be exported for compliance

### 3. **Fail-Safe Defaults**
- Timeouts default to **denial** (safe by default)
- Network errors default to **denial**
- Any error → operation cancelled

### 4. **No Auto-Approval**
- System **never** auto-approves
- Always requires explicit human click
- Can't be bypassed programmatically

## 🐛 Troubleshooting

### Approval Request Not Appearing

**Symptom:** No message appears in Telegram

**Solutions:**
1. Check bot token and chat ID in `.env`
2. Verify bot has permission to send messages
3. Test with `node telegram-notifier.js test`

### Timeout Before Response

**Symptom:** Operation cancelled before you can respond

**Solutions:**
1. Increase timeout value (3rd parameter)
2. Check Telegram app is open and notifications enabled
3. Ensure stable internet connection

### Buttons Not Working

**Symptom:** Clicking buttons does nothing

**Solutions:**
1. Check bot permissions include "inline queries"
2. Verify bot token is valid
3. Make sure polling is working (check console for errors)

### Multiple Approval Requests

**Symptom:** Old approval requests still showing buttons

**Solutions:**
1. Buttons are automatically removed after response
2. Old requests that timed out can be manually dismissed
3. Each request has unique message ID - won't interfere

## 📈 Advanced Features

### Custom Buttons

Extend with custom button options:

```javascript
// Add "Skip" option
const keyboard = {
    inline_keyboard: [[
        { text: '✅ Approve', callback_data: 'approve' },
        { text: '❌ Deny', callback_data: 'deny' },
        { text: '⏭️ Skip', callback_data: 'skip' }
    ]]
};
```

### Approval Chains

Create workflows requiring multiple approvals:

```javascript
async function multiStepApproval() {
    const approvals = [
        { action: 'Backup database', details: 'Create snapshot' },
        { action: 'Run migrations', details: 'Execute 5 scripts' },
        { action: 'Deploy code', details: 'Deploy v2.0.0' },
        { action: 'Run smoke tests', details: 'Verify critical paths' }
    ];

    for (const step of approvals) {
        const approved = await notifier.requestApproval(
            step.action,
            step.details,
            60000
        );

        if (!approved) {
            await notifier.sendMessage(`❌ Workflow cancelled at: ${step.action}`);
            return false;
        }

        // Execute step...
    }

    return true;
}
```

### Conditional Approvals

Only request approval for high-impact operations:

```javascript
async function deleteRecords(count) {
    const notifier = new TelegramNotifier();

    // Auto-proceed for small deletions
    if (count < 100) {
        await db.delete(query);
        return;
    }

    // Require approval for large deletions
    const approved = await notifier.requestApproval(
        'Delete records',
        `Delete ${count} records (above threshold of 100)`,
        60000
    );

    if (approved) {
        await db.delete(query);
    }
}
```

## ✅ Summary

The Telegram Approval System provides:

- 🔐 **Human-in-the-loop** safety for AI operations
- 📱 **Mobile approval** - approve/deny from anywhere
- ⚡ **Real-time** response with interactive buttons
- 🔒 **Fail-safe** defaults (timeout/error = denial)
- 📊 **Audit trail** in Telegram chat history
- 🎯 **Simple API** - one method call to request approval
- ⏱️ **Configurable timeouts** for different operation types

Perfect for creating **safe, auditable AI-assisted workflows** where humans maintain control over critical decisions.

---

**Part of the** [Claude AI Agents Collection](../../)
