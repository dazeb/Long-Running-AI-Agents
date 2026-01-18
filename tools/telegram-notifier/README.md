# 📱 Telegram Notifier

Production-ready Telegram notification system for Claude AI Agents.

## 🚀 Quick Start

### First-Time Setup
```bash
# The setup wizard launches automatically
node telegram-notifier.js test
```

Or run manually:
```bash
npm install
node telegram-notifier.js setup
```

### Usage

```bash
# Test connectivity
npm test

# Send a message
node telegram-notifier.js send "Hello!"

# Task completion
node telegram-notifier.js task "Feature XYZ" "5" "30 mins"

# See all examples
npm run examples
```

## 📚 Documentation

- **[TELEGRAM_QUICK_START.md](TELEGRAM_QUICK_START.md)** - 2-minute quick reference
- **[TELEGRAM_NOTIFIER_GUIDE.md](TELEGRAM_NOTIFIER_GUIDE.md)** - Complete usage guide
- **[SETUP_WIZARD_DEMO.md](SETUP_WIZARD_DEMO.md)** - Setup wizard walkthrough
- **[TELEGRAM_IMPROVEMENTS.md](TELEGRAM_IMPROVEMENTS.md)** - 10 advanced features

## 🎯 Features

- 🧙 Interactive setup wizard
- ✅ Real-time bot validation
- 🔍 Auto-detects chat ID
- 📁 Creates all necessary files
- 🛡️ Secure .env configuration

## 📋 Notification Types

1. ✅ Task completions
2. 🚀 Deployment status
3. 🚨 Error alerts
4. 💚 System health checks
5. 📊 Progress reports
6. 💬 Custom messages

## 💻 Programmatic Usage

```javascript
const TelegramNotifier = require('./telegram-notifier');
const notifier = new TelegramNotifier();

// Task completion
await notifier.notifyTaskComplete('Feature XYZ', {
    session: '5',
    duration: '30 minutes',
    notes: 'Implemented with tests'
});

// Deployment
await notifier.notifyDeployment('v2.4.1', 'production', 'success');

// Error alert
await notifier.notifyError('API Timeout', 'Connection failed', {
    file: 'api/client.js',
    line: '127'
});
```

## 🔧 Integration

### Git Hooks
```bash
# .git/hooks/post-commit
#!/bin/bash
./scripts/notify.sh commit
```

### CI/CD
```yaml
- name: Notify Success
  run: node telegram-notifier.js send "✅ Build successful"
```

### NPM Scripts
```json
{
  "scripts": {
    "posttest": "node telegram-notifier.js task 'Tests completed'"
  }
}
```

## 🔐 Security

Your `.env` file contains sensitive credentials:
- Automatically in `.gitignore`
- Never committed to version control
- Validated before use

## 📁 Structure

```
telegram-notifier/
├── telegram-notifier.js          # Main implementation
├── package.json                   # NPM configuration
├── examples/                      # Usage examples
├── scripts/                       # Automation scripts
└── *.md                           # Documentation
```

## ✅ Status

- **Bot**: Fully operational
- **Setup**: Interactive wizard included
- **Documentation**: Complete
- **Examples**: 6 working notification types

---

Part of the [Claude AI Agents Collection](../)
