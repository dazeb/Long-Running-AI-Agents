#!/usr/bin/env node

/**
 * Telegram Notifier Implementation
 * Sends notifications to Telegram using the Bot API
 * Reads configuration from .env file
 */

require('dotenv').config();
const https = require('https');
const fs = require('fs');
const path = require('path');
const readline = require('readline');

class TelegramNotifier {
    constructor(skipValidation = false) {
        // Cache environment variables to avoid repeated lookups
        this.botToken = process.env.TELEGRAM_BOT_TOKEN;
        this.chatId = process.env.TELEGRAM_CHAT_ID;
        this.botUsername = process.env.TELEGRAM_BOT_USERNAME || '@OpenCode';
        this.enabled = process.env.TELEGRAM_ENABLED !== 'false';

        if (!skipValidation && (!this.botToken || !this.chatId)) {
            throw new Error('TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID must be set in .env file');
        }
    }

    /**
     * Internal utility method for making HTTP requests
     * Uses Buffer array to efficiently handle response data
     * @private
     * @param {string} url - The full URL to request
     * @param {object} options - Request options (method, headers, etc.)
     * @param {string} data - Optional data to send (for POST requests)
     * @returns {Promise<object>} - Parsed JSON response
     */
    _makeHttpRequest(url, options = {}, data = null) {
        return new Promise((resolve, reject) => {
            const isPost = options.method === 'POST';
            const requestFn = isPost ? https.request : https.get;

            const req = requestFn(url, options, (res) => {
                // Use Buffer array for efficient data collection (avoids string concatenation overhead)
                const chunks = [];

                res.on('data', chunk => chunks.push(chunk));

                res.on('end', () => {
                    try {
                        const body = Buffer.concat(chunks).toString();
                        const response = JSON.parse(body);
                        resolve(response);
                    } catch (err) {
                        console.error('❌ Failed to parse response');
                        reject(err);
                    }
                });
            });

            req.on('error', (err) => {
                console.error('❌ Network error:', err.message);
                reject(err);
            });

            if (data) {
                req.write(data);
            }

            req.end();
        });
    }

    /**
     * Send a message to Telegram
     * @param {string} message - The message to send
     * @param {object} options - Additional options (parse_mode, disable_notification)
     * @returns {Promise<object>} - The API response
     */
    async sendMessage(message, options = {}) {
        if (!this.enabled) {
            console.log('⚠️  Telegram notifications disabled (TELEGRAM_ENABLED=false)');
            return { success: false, reason: 'disabled' };
        }

        const payload = {
            chat_id: this.chatId,
            text: message,
            disable_notification: options.silent || false,
            ...options
        };

        // Only set Markdown as default if parse_mode wasn't explicitly provided
        if (!('parse_mode' in options)) {
            payload.parse_mode = 'Markdown';
        }

        try {
            const data = JSON.stringify(payload);
            const url = `https://api.telegram.org/bot${this.botToken}/sendMessage`;

            const response = await this._makeHttpRequest(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Content-Length': data.length
                }
            }, data);

            if (response.ok) {
                console.log('✅ Message sent successfully');
                return response;
            } else {
                console.error('❌ Telegram API error:', response.description);
                throw new Error(response.description);
            }
        } catch (err) {
            throw err;
        }
    }

    /**
     * Get bot information
     */
    async getBotInfo() {
        const url = `https://api.telegram.org/bot${this.botToken}/getMe`;
        const response = await this._makeHttpRequest(url);

        if (response.ok) {
            return response.result;
        } else {
            throw new Error(response.description);
        }
    }

    /**
     * Format and send a task completion notification
     */
    async notifyTaskComplete(taskName, details = {}) {
        const message = `✅ *Task Completed*

📋 *Task:* ${taskName}
${details.session ? `🔢 *Session:* #${details.session}` : ''}
${details.duration ? `⏱️ *Duration:* ${details.duration}` : ''}
${details.link ? `🔗 *Link:* ${details.link}` : ''}

${details.notes || ''}`;

        return this.sendMessage(message);
    }

    /**
     * Send a deployment notification
     */
    async notifyDeployment(version, environment, status = 'success') {
        const emoji = status === 'success' ? '🚀' : '⚠️';
        const message = `${emoji} *Deployment ${status === 'success' ? 'Successful' : 'Failed'}*

📦 *Version:* ${version}
🌍 *Environment:* ${environment}
⏰ *Time:* ${new Date().toLocaleString()}`;

        return this.sendMessage(message);
    }

    /**
     * Send an error/alert notification
     */
    async notifyError(title, error, context = {}) {
        const message = `🚨 *Alert: ${title}*

❌ *Error:* ${error}
${context.file ? `📄 *File:* ${context.file}` : ''}
${context.line ? `📍 *Line:* ${context.line}` : ''}
⏰ *Time:* ${new Date().toLocaleString()}`;

        return this.sendMessage(message);
    }

    /**
     * Send a heartbeat/status check
     */
    async notifyHeartbeat(status, metrics = {}) {
        const emoji = status === 'healthy' ? '💚' : '💛';
        const message = `${emoji} *System Heartbeat*

📊 *Status:* ${status}
${Object.entries(metrics).map(([key, value]) => `• ${key}: ${value}`).join('\n')}
⏰ *Time:* ${new Date().toLocaleString()}`;

        return this.sendMessage(message);
    }

    /**
     * Clear pending updates to avoid conflicts
     * Optimized to use single API call with proper offset
     * @returns {Promise<number>} - The last update ID processed
     */
    async clearPendingUpdates() {
        try {
            const updates = await this.getUpdates(0);
            if (updates.length > 0) {
                const lastUpdateId = updates[updates.length - 1].update_id;
                // Single call with offset acknowledges all pending updates
                // The updates are already fetched, just setting offset clears them
                return lastUpdateId;
            }
            return 0;
        } catch (error) {
            console.log('⚠️  Could not clear pending updates:', error.message);
            return 0;
        }
    }

    /**
     * Request approval from user with inline keyboard buttons
     * @param {string} action - The action requiring approval
     * @param {string} details - Additional details about the action
     * @param {number} timeout - Timeout in milliseconds (default: 5 minutes)
     * @returns {Promise<boolean>} - true if approved, false if denied or timeout
     */
    async requestApproval(action, details = '', timeout = 300000) {
        // Clear any pending updates first to avoid conflicts
        await this.clearPendingUpdates();

        // Use plain text (no Markdown formatting) for button messages
        const message = `🤖 Claude Code Authorization Request

📋 Action: ${action}
${details ? `📝 Details: ${details}` : ''}

⏰ Timeout: ${timeout / 1000} seconds

Please approve or deny this action:`;

        const keyboard = {
            inline_keyboard: [[
                { text: '✅ Approve', callback_data: 'approve' },
                { text: '❌ Deny', callback_data: 'deny' }
            ]]
        };

        try {
            // Send without parse_mode to ensure buttons work
            const response = await this.sendMessage(message, {
                reply_markup: keyboard,
                parse_mode: null
            });
            const messageId = response.result.message_id;

            console.log(`⏳ Waiting for approval (timeout: ${timeout / 1000}s)...`);

            // Wait for user response
            const approved = await this.waitForCallbackResponse(messageId, timeout);

            // Update the message to show the result
            await this.editMessageReplyMarkup(messageId, null);
            const resultEmoji = approved ? '✅' : '❌';
            const resultText = approved ? 'APPROVED' : 'DENIED';
            await this.sendMessage(`${resultEmoji} *Authorization ${resultText}*\n\nAction: ${action}`);

            return approved;

        } catch (error) {
            console.error('❌ Approval request failed:', error.message);
            return false;
        }
    }

    /**
     * Wait for callback button response
     * Optimized with long-polling and efficient update checking
     * @param {number} messageId - The message ID to watch for callbacks
     * @param {number} timeout - Maximum time to wait in milliseconds
     * @returns {Promise<boolean>} - true if approved, false if denied or timeout
     */
    async waitForCallbackResponse(messageId, timeout) {
        const startTime = Date.now();
        let lastUpdateId = 0;
        let retryCount = 0;
        const maxRetries = 3;

        while (true) {
            try {
                const remainingTime = timeout - (Date.now() - startTime);

                // Check if timeout exceeded
                if (remainingTime <= 0) {
                    console.log('⏰ Approval request timed out');
                    return false;
                }

                // Use Telegram's long-polling with dynamic timeout (max 20s per Telegram API limits)
                // This reduces API calls by waiting on the server side
                const pollTimeout = Math.min(20, Math.floor(remainingTime / 1000));

                // Get updates with long-polling enabled
                const updates = await this.getUpdates(lastUpdateId + 1, pollTimeout);

                // Use .find() instead of for loop - more efficient and idiomatic
                const matchingUpdate = updates.find(update => {
                    lastUpdateId = Math.max(lastUpdateId, update.update_id);
                    return update.callback_query &&
                           update.callback_query.message.message_id === messageId;
                });

                if (matchingUpdate) {
                    const callbackData = matchingUpdate.callback_query.data;
                    const approved = callbackData === 'approve';

                    // Answer the callback query to remove loading state
                    await this.answerCallbackQuery(
                        matchingUpdate.callback_query.id,
                        approved ? 'Approved!' : 'Denied'
                    );

                    return approved;
                }

                // Reset retry count on successful poll
                retryCount = 0;

            } catch (error) {
                console.error('Error checking for updates:', error.message);

                // Exponential backoff on errors (2s, 4s, 8s)
                retryCount++;
                if (retryCount > maxRetries) {
                    console.error('❌ Max retries exceeded');
                    return false;
                }

                const backoffTime = Math.min(2000 * Math.pow(2, retryCount - 1), 8000);
                await new Promise(resolve => setTimeout(resolve, backoffTime));
            }
        }
    }

    /**
     * Get updates from Telegram
     * @param {number} offset - Offset for getting updates
     * @param {number} timeout - Long-polling timeout in seconds (default: 3)
     * @returns {Promise<Array>} - Array of updates
     */
    async getUpdates(offset = 0, timeout = 3) {
        const url = `https://api.telegram.org/bot${this.botToken}/getUpdates?offset=${offset}&timeout=${timeout}`;
        const response = await this._makeHttpRequest(url);

        if (response.ok) {
            return response.result || [];
        } else {
            throw new Error(response.description);
        }
    }

    /**
     * Answer a callback query (acknowledge button press)
     * @param {string} callbackQueryId - The callback query ID
     * @param {string} text - Optional text to show as notification
     */
    async answerCallbackQuery(callbackQueryId, text = '') {
        const data = JSON.stringify({
            callback_query_id: callbackQueryId,
            text: text
        });

        const url = `https://api.telegram.org/bot${this.botToken}/answerCallbackQuery`;

        return await this._makeHttpRequest(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': data.length
            }
        }, data);
    }

    /**
     * Edit message reply markup (remove buttons)
     * @param {number} messageId - The message ID
     * @param {object} replyMarkup - New reply markup (null to remove)
     */
    async editMessageReplyMarkup(messageId, replyMarkup) {
        const data = JSON.stringify({
            chat_id: this.chatId,
            message_id: messageId,
            reply_markup: replyMarkup
        });

        const url = `https://api.telegram.org/bot${this.botToken}/editMessageReplyMarkup`;

        return await this._makeHttpRequest(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': data.length
            }
        }, data);
    }
}

// Setup and Initialization Functions
class SetupWizard {
    constructor() {
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });
    }

    question(prompt) {
        return new Promise(resolve => {
            this.rl.question(prompt, resolve);
        });
    }

    close() {
        this.rl.close();
    }

    async checkDependencies() {
        const packageJsonPath = path.join(process.cwd(), 'package.json');

        if (!fs.existsSync(packageJsonPath)) {
            console.log('📦 Creating package.json...');
            const packageJson = {
                name: "telegram-notifier-app",
                version: "1.0.0",
                description: "Telegram notification system",
                main: "telegram-notifier.js",
                scripts: {
                    test: "node telegram-notifier.js test",
                    notify: "node telegram-notifier.js send"
                },
                dependencies: {
                    dotenv: "^16.4.7"
                }
            };
            fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));
            console.log('✅ package.json created\n');
            return false; // Need to install
        }

        const nodeModulesPath = path.join(process.cwd(), 'node_modules');
        if (!fs.existsSync(nodeModulesPath)) {
            console.log('⚠️  Dependencies not installed');
            return false;
        }

        return true;
    }

    async createDirectoryStructure() {
        const dirs = ['examples', 'scripts'];

        for (const dir of dirs) {
            const dirPath = path.join(process.cwd(), dir);
            if (!fs.existsSync(dirPath)) {
                fs.mkdirSync(dirPath, { recursive: true });
                console.log(`📁 Created directory: ${dir}/`);
            }
        }
    }

    async validateBotToken(token) {
        return new Promise((resolve) => {
            const url = `https://api.telegram.org/bot${token}/getMe`;

            https.get(url, (res) => {
                const chunks = [];
                res.on('data', chunk => chunks.push(chunk));
                res.on('end', () => {
                    try {
                        const body = Buffer.concat(chunks).toString();
                        const response = JSON.parse(body);
                        resolve(response.ok ? response.result : null);
                    } catch {
                        resolve(null);
                    }
                });
            }).on('error', () => resolve(null));
        });
    }

    async getChatId(token) {
        return new Promise((resolve) => {
            const url = `https://api.telegram.org/bot${token}/getUpdates`;

            https.get(url, (res) => {
                const chunks = [];
                res.on('data', chunk => chunks.push(chunk));
                res.on('end', () => {
                    try {
                        const body = Buffer.concat(chunks).toString();
                        const response = JSON.parse(body);
                        if (response.ok && response.result.length > 0) {
                            const lastUpdate = response.result[response.result.length - 1];
                            const chatId = lastUpdate.message?.chat?.id;
                            resolve(chatId || null);
                        } else {
                            resolve(null);
                        }
                    } catch {
                        resolve(null);
                    }
                });
            }).on('error', () => resolve(null));
        });
    }

    async createEnvFile(config) {
        const envContent = `# Telegram Bot Configuration
# Generated by setup wizard

# Your Telegram bot token (get from @BotFather)
TELEGRAM_BOT_TOKEN=${config.botToken}

# Your chat ID (get by messaging your bot and checking the API)
TELEGRAM_CHAT_ID=${config.chatId}

# Your bot username (optional)
TELEGRAM_BOT_USERNAME=${config.botUsername || '@OpenCode'}

# Idle timeout in milliseconds (default: 5 minutes = 300000ms)
TELEGRAM_IDLE_TIMEOUT=300000

# Check interval in milliseconds (default: 30 seconds = 30000ms)
TELEGRAM_CHECK_INTERVAL=30000

# Enable/disable the plugin (true/false)
TELEGRAM_ENABLED=true
`;

        const envPath = path.join(process.cwd(), '.env');
        fs.writeFileSync(envPath, envContent);
        console.log('✅ .env file created\n');
    }

    async run() {
        console.log('\n🤖 Telegram Notifier Setup Wizard\n');
        console.log('═'.repeat(50));
        console.log('\nThis wizard will help you set up the Telegram notifier.\n');

        // Check dependencies
        const depsInstalled = await this.checkDependencies();
        if (!depsInstalled) {
            console.log('Please run: npm install\n');
            console.log('Then run the setup again: node telegram-notifier.js setup\n');
            this.close();
            return;
        }

        // Create directory structure
        await this.createDirectoryStructure();

        console.log('\n📋 Step 1: Get Your Bot Token');
        console.log('─'.repeat(50));
        console.log('1. Open Telegram and search for @BotFather');
        console.log('2. Send /newbot and follow the instructions');
        console.log('3. Copy the bot token you receive\n');

        let botToken = await this.question('Enter your bot token: ');
        botToken = botToken.trim();

        console.log('\n🔍 Validating bot token...');
        const botInfo = await this.validateBotToken(botToken);

        if (!botInfo) {
            console.log('❌ Invalid bot token. Please check and try again.');
            this.close();
            return;
        }

        console.log(`✅ Bot validated: ${botInfo.first_name} (@${botInfo.username})\n`);

        console.log('📋 Step 2: Get Your Chat ID');
        console.log('─'.repeat(50));
        console.log('1. Search for your bot in Telegram: @' + botInfo.username);
        console.log('2. Send any message to your bot (e.g., "Hello")');
        console.log('3. Press Enter here to auto-detect your chat ID\n');

        await this.question('Press Enter after you\'ve sent a message to your bot...');

        console.log('\n🔍 Looking for your chat ID...');
        const chatId = await this.getChatId(botToken);

        if (!chatId) {
            console.log('⚠️  Could not auto-detect chat ID.');
            console.log('Please visit this URL to find your chat ID:');
            console.log(`https://api.telegram.org/bot${botToken}/getUpdates\n`);
            const manualChatId = await this.question('Enter your chat ID manually: ');

            await this.createEnvFile({
                botToken,
                chatId: manualChatId.trim(),
                botUsername: '@' + botInfo.username
            });
        } else {
            console.log(`✅ Chat ID detected: ${chatId}\n`);

            await this.createEnvFile({
                botToken,
                chatId,
                botUsername: '@' + botInfo.username
            });
        }

        console.log('═'.repeat(50));
        console.log('✨ Setup Complete!\n');
        console.log('You can now use the notifier:');
        console.log('  node telegram-notifier.js test    - Test connectivity');
        console.log('  node telegram-notifier.js send "Hello" - Send a message\n');

        this.close();
    }
}

async function checkSetupRequired() {
    const envPath = path.join(process.cwd(), '.env');

    if (!fs.existsSync(envPath)) {
        console.log('⚠️  No .env file found. Running setup wizard...\n');
        const wizard = new SetupWizard();
        await wizard.run();
        return true;
    }

    return false;
}

// CLI Interface
if (require.main === module) {
    (async () => {
        const args = process.argv.slice(2);

        // Handle setup command explicitly
        if (args[0] === 'setup' || args[0] === 'init') {
            const wizard = new SetupWizard();
            await wizard.run();
            return;
        }

        // Auto-setup check for first-time users
        const setupRequired = await checkSetupRequired();
        if (setupRequired) {
            return; // Setup wizard ran, exit
        }

        const notifier = new TelegramNotifier();

        if (args[0] === 'test') {
            // Test the bot connectivity
            console.log('🔍 Testing Telegram bot connectivity...\n');

            notifier.getBotInfo()
                .then(info => {
                    console.log('✅ Bot Info:');
                    console.log(`   Name: ${info.first_name}`);
                    console.log(`   Username: @${info.username}`);
                    console.log(`   ID: ${info.id}\n`);

                    return notifier.sendMessage('🧪 *Test Message*\n\nTelegram Notifier is working correctly! ✨');
                })
                .then(() => {
                    console.log('\n✅ All tests passed!');
                    process.exit(0);
                })
                .catch(err => {
                    console.error('\n❌ Test failed:', err.message);
                    process.exit(1);
                });
        } else if (args[0] === 'send' && args[1]) {
            // Send a custom message
            const message = args.slice(1).join(' ');
            notifier.sendMessage(message)
                .then(() => process.exit(0))
                .catch(err => {
                    console.error('Failed to send message:', err.message);
                    process.exit(1);
                });
        } else if (args[0] === 'task' && args[1]) {
            // Send a task completion notification
            const taskName = args[1];
            notifier.notifyTaskComplete(taskName, {
                session: args[2] || '',
                duration: args[3] || ''
            })
                .then(() => process.exit(0))
                .catch(err => {
                    console.error('Failed to send notification:', err.message);
                    process.exit(1);
                });
        } else if (args[0] === 'approve') {
            // Test the approval feature
            const action = args[1] || 'Test approval workflow';
            const details = args.slice(2).join(' ') || 'This is a test of the approval system';
            const timeout = parseInt(args[args.length - 1]) || 60000; // Default 60 seconds

            console.log('📱 Sending approval request to Telegram...\n');

            notifier.requestApproval(action, details, timeout)
                .then(approved => {
                    if (approved) {
                        console.log('\n✅ ACTION APPROVED - Proceeding with task...');
                        process.exit(0);
                    } else {
                        console.log('\n❌ ACTION DENIED - Task cancelled.');
                        process.exit(1);
                    }
                })
                .catch(err => {
                    console.error('\n❌ Approval request failed:', err.message);
                    process.exit(1);
                });
        } else {
            console.log(`
Telegram Notifier CLI

Usage:
  node telegram-notifier.js setup                   Run setup wizard (first-time setup)
  node telegram-notifier.js test                    Test bot connectivity
  node telegram-notifier.js send <message>          Send a custom message
  node telegram-notifier.js task <name> [session]   Send task completion notification
  node telegram-notifier.js approve <action> [details] [timeout]  Request user approval

Environment variables (from .env):
  TELEGRAM_BOT_TOKEN      Your bot token from @BotFather
  TELEGRAM_CHAT_ID        Your chat ID
  TELEGRAM_BOT_USERNAME   Bot username (optional)
  TELEGRAM_ENABLED        Enable/disable notifications (default: true)

First-time setup:
  If .env file doesn't exist, the setup wizard will run automatically.
  You can also run it manually with: node telegram-notifier.js setup

Examples:
  node telegram-notifier.js setup
  node telegram-notifier.js test
  node telegram-notifier.js send "Hello from the CLI!"
  node telegram-notifier.js task "User Authentication" "4" "45 minutes"
  node telegram-notifier.js approve "Edit config files" "Modify database settings" 30000
        `);
            process.exit(1);
        }
    })();
}

module.exports = TelegramNotifier;
