/**
 * Telegram Notifier Usage Examples
 * Demonstrates various ways to use the Telegram notifier
 */

const TelegramNotifier = require('../telegram-notifier');

async function runExamples() {
    const notifier = new TelegramNotifier();

    console.log('📱 Telegram Notifier Examples\n');

    try {
        // Example 1: Simple message
        console.log('1️⃣ Sending simple message...');
        await notifier.sendMessage('👋 Hello from Claude AI Agents!');
        console.log('   ✅ Sent\n');

        await sleep(1000);

        // Example 2: Task completion notification
        console.log('2️⃣ Sending task completion notification...');
        await notifier.notifyTaskComplete('User Authentication System', {
            session: '4',
            duration: '45 minutes',
            notes: 'Implemented JWT tokens with refresh mechanism'
        });
        console.log('   ✅ Sent\n');

        await sleep(1000);

        // Example 3: Deployment notification
        console.log('3️⃣ Sending deployment notification...');
        await notifier.notifyDeployment('v2.4.1', 'production', 'success');
        console.log('   ✅ Sent\n');

        await sleep(1000);

        // Example 4: Error/Alert notification
        console.log('4️⃣ Sending error alert...');
        await notifier.notifyError('Database Connection Failed',
            'Connection timeout after 30 seconds',
            {
                file: 'src/db/connection.js',
                line: '42'
            }
        );
        console.log('   ✅ Sent\n');

        await sleep(1000);

        // Example 5: System heartbeat
        console.log('5️⃣ Sending system heartbeat...');
        await notifier.notifyHeartbeat('healthy', {
            'CPU Usage': '45%',
            'Memory': '2.3GB / 8GB',
            'Uptime': '3 days',
            'Active Tasks': '12'
        });
        console.log('   ✅ Sent\n');

        await sleep(1000);

        // Example 6: Formatted markdown message
        console.log('6️⃣ Sending formatted message...');
        const formattedMessage = `
📊 *Daily Progress Report*

✅ *Completed Tasks:*
• User Authentication System
• Payment Gateway Integration
• Email Notification Service

🔄 *In Progress:*
• Dashboard Analytics
• Mobile App Optimization

📈 *Metrics:*
• Code Coverage: 87%
• Build Time: 2m 34s
• Tests Passed: 245/248

_Generated on ${new Date().toLocaleDateString()}_
        `.trim();

        await notifier.sendMessage(formattedMessage);
        console.log('   ✅ Sent\n');

        console.log('✨ All examples completed successfully!');

    } catch (error) {
        console.error('❌ Error running examples:', error.message);
        process.exit(1);
    }
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

// Run examples if called directly
if (require.main === module) {
    runExamples();
}

module.exports = { runExamples };
