/**
 * Telegram Approval Workflow Example
 * Demonstrates how to request user approval before executing sensitive operations
 */

const TelegramNotifier = require('../telegram-notifier');

async function exampleApprovalWorkflow() {
    const notifier = new TelegramNotifier();

    console.log('🔐 Approval Workflow Examples\n');
    console.log('=' .repeat(60));

    try {
        // Example 1: Simple approval request
        console.log('\n📋 Example 1: Simple file modification approval\n');

        const approved1 = await notifier.requestApproval(
            'Modify configuration files',
            'Update database connection strings in config/database.js',
            30000 // 30 second timeout
        );

        if (approved1) {
            console.log('✅ User approved - executing file modifications...');
            // Your code here to modify files
        } else {
            console.log('❌ User denied - skipping modifications');
        }

        // Example 2: Critical operation approval
        console.log('\n📋 Example 2: Critical database operation\n');

        const approved2 = await notifier.requestApproval(
            'Delete old database records',
            'Remove 10,000+ records older than 90 days from users table',
            60000 // 60 second timeout for critical operations
        );

        if (approved2) {
            console.log('✅ User approved - executing database cleanup...');
            // Your code here to delete records
        } else {
            console.log('❌ User denied - database cleanup cancelled');
        }

        // Example 3: Deployment approval
        console.log('\n📋 Example 3: Production deployment\n');

        const approved3 = await notifier.requestApproval(
            'Deploy to Production',
            'Deploy v2.4.1 with database migrations to production environment',
            120000 // 2 minute timeout for deployment decisions
        );

        if (approved3) {
            console.log('✅ User approved - starting deployment...');
            // Your deployment code here
        } else {
            console.log('❌ User denied - deployment cancelled');
        }

        console.log('\n' + '='.repeat(60));
        console.log('✨ All examples completed!\n');

    } catch (error) {
        console.error('❌ Error:', error.message);
        process.exit(1);
    }
}

// Run the examples
if (require.main === module) {
    exampleApprovalWorkflow();
}

module.exports = { exampleApprovalWorkflow };
