# TruthFi Process Deployment Guide

## Version: 1.0.0
## Phase: 4-1-system-integration

This guide provides comprehensive instructions for deploying the TruthFi Process on the AO Network.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Process Deployment](#process-deployment)
4. [Configuration](#configuration)
5. [External Integrations](#external-integrations)
6. [Testing & Validation](#testing--validation)
7. [Monitoring & Maintenance](#monitoring--maintenance)
8. [Troubleshooting](#troubleshooting)
9. [Performance Optimization](#performance-optimization)

---

## Prerequisites

### System Requirements

1. **AOS CLI**: Version 2.0.4 or higher
2. **Node.js**: Version 16+ (for development tools)
3. **AR Wallet**: Arweave wallet with sufficient AR for deployment
4. **USDA Tokens**: Test USDA for initial testing

### Knowledge Requirements

- Basic understanding of AO Network architecture
- Familiarity with Lua programming
- Understanding of message passing patterns
- Knowledge of token operations on Arweave

### Development Environment

```bash
# Install AOS CLI
npm install -g aos-cli

# Verify installation
aos --version

# Clone TruthFi repository
git clone <repository-url>
cd TruthFi-Agent
```

---

## Environment Setup

### 1. AO Network Connection

```bash
# Connect to AO testnet
aos --wallet path/to/wallet.json --gateway https://ao-testnet.arweave.dev

# Verify connection
aos> .help
```

### 2. Directory Structure

Ensure your project structure matches:

```
TruthFi-Agent/
├── process/
│   ├── src/
│   │   ├── truthfi-core.lua          # Main process file
│   │   └── tests/
│   │       ├── integration-test.lua  # Complete test suite
│   │       └── test-*.lua           # Individual test files
│   ├── docs/
│   │   ├── api-spec.md              # API documentation
│   │   └── deployment-guide.md      # This file
│   └── deploy/                      # Deployment scripts
├── docs/                            # Project documentation
└── README.md
```

### 3. Wallet Configuration

```bash
# Set wallet environment variable
export ARWEAVE_WALLET="path/to/wallet.json"

# Verify wallet balance
aos> balance
```

---

## Process Deployment

### 1. Deploy Main Process

```bash
# Navigate to process source
cd process/src

# Start AOS with main process
aos --load truthfi-core.lua

# Verify deployment
aos> State.name
aos> State.version
aos> State.phase
```

### 2. Initial Configuration

After deployment, configure the process:

```lua
-- Set admin (replace with your process ID)
aos> State.admin = "YOUR_ADMIN_PROCESS_ID"

-- Verify initialization
aos> State.initialized
aos> State.active_tweet.case_id
```

### 3. Load Sample Data

```lua
-- Load sample tweet case
aos> loadSampleTweet()

-- Verify sample data
aos> State.active_tweet.title
aos> State.active_tweet.main_tweet.content
```

---

## Configuration

### 1. Process Metadata

Update these values in `truthfi-core.lua` before deployment:

```lua
State = State or {
    name = "TruthFi Core",
    version = "1.0.0",
    phase = "4-1-system-integration",
    admin = "YOUR_ADMIN_PROCESS_ID",  -- UPDATE THIS
}
```

### 2. External Process IDs

Configure integration process IDs:

```lua
-- Set QF Calculator Process ID
aos> Send({
    Target = ao.id,
    Action = "Set-QF-Process",
    ["Process-ID"] = "QF_CALCULATOR_PROCESS_ID"
})

-- Set USDA Token Process ID  
aos> Send({
    Target = ao.id,
    Action = "Set-USDA-Process",
    ["Process-ID"] = "USDA_TOKEN_PROCESS_ID"
})

-- Set RandAO Process ID
aos> Send({
    Target = ao.id,
    Action = "Set-RandAO-Process", 
    ["Process-ID"] = "RANDAO_PROCESS_ID"
})
```

### 3. AI System Configuration

```lua
-- Enable AI system (default: enabled)
aos> Send({
    Target = ao.id,
    Action = "Toggle-AI-System"
})

-- Update AI prompt template (admin only)
aos> Send({
    Target = ao.id,
    Action = "Set-AI-Prompt",
    Data = "Your custom AI evaluation prompt with {MAIN_TWEET_DATA} and {REFERENCE_TWEETS_DATA} placeholders"
})
```

---

## External Integrations

### 1. QF Calculator Process

Deploy the standalone QF Calculator:

```bash
# Deploy QF Calculator
aos --load qf-calculator.lua

# Note the process ID for TruthFi configuration
```

### 2. USDA Token Integration

Configure USDA token process for deposits:

```lua
-- The USDA process should send Credit-Notice messages to TruthFi
-- Format: Credit-Notice with X-Vote-Type tag
```

### 3. RandAO Integration

```lua
-- Ensure RandAO process can send RandomResponse messages
-- TruthFi will request random numbers for SBT lucky numbers
```

### 4. Apus AI Integration

The Apus AI integration is built-in but requires:
- Access to Apus AI inference service
- Sufficient APUS tokens for evaluation requests
- Network connectivity to Apus AI endpoints

---

## Testing & Validation

### 1. Run Integration Tests

```lua
-- Load and run complete test suite
aos> .load tests/integration-test.lua
aos> runCompleteIntegrationTest()

-- Quick smoke test
aos> runSmokeTest()
```

### 2. Manual Testing

```lua
-- Test basic info
aos> Send({Target = ao.id, Action = "Info"})

-- Test voting flow
aos> Send({
    Target = ao.id,
    Action = "Complete-Vote",
    ["Vote-Type"] = "true"
})

-- Test dashboard data
aos> Send({Target = ao.id, Action = "Dashboard-Data"})

-- Test AI evaluation
aos> Send({Target = ao.id, Action = "AI-Evaluate"})

-- Test results comparison
aos> Send({Target = ao.id, Action = "Compare-Results"})
```

### 3. System Consistency Check

```lua
-- Validate system consistency
aos> Send({Target = ao.id, Action = "Debug-Info"})

-- Check for any consistency issues
aos> validateSystemConsistency()
```

---

## Monitoring & Maintenance

### 1. System Health Monitoring

Regular health checks:

```lua
-- Check system stats
aos> Send({Target = ao.id, Action = "Get-Stats"})

-- Monitor AI system
aos> Send({Target = ao.id, Action = "Get-AI-Stats"})

-- Check pool status
aos> Send({Target = ao.id, Action = "Get-Pool-Info"})
```

### 2. Performance Monitoring

```lua
-- Check handler response times
aos> Send({Target = ao.id, Action = "Debug-Info"})

-- Monitor state consistency
aos> validateSystemConsistency()

-- Check memory usage patterns
aos> State.initialized and "System running" or "System not initialized"
```

### 3. Regular Maintenance

```lua
-- Admin maintenance tasks

-- Reset development/test state (admin only)
aos> Send({
    Target = ao.id,
    Action = "Reset-State",
    ["Reset-Type"] = "voting"  -- or "all", "sbt", "ai"
})

-- Update tweet cases (admin only)
aos> Send({
    Target = ao.id,
    Action = "Set-Tweet-Case",
    Data = json.encode(new_case_data)
})

-- Backup critical state data
aos> json.encode(State.voting_stats)
aos> json.encode(State.user_votes)
```

---

## Troubleshooting

### Common Issues

#### 1. Process Not Responding

**Symptoms**: Handlers not responding to messages
**Solutions**:
```lua
-- Check process status
aos> State.initialized

-- Reload process if needed
aos> .load truthfi-core.lua

-- Verify sample data
aos> State.active_tweet.case_id ~= ""
```

#### 2. Vote Processing Failures

**Symptoms**: Complete-Vote returns errors
**Solutions**:
```lua
-- Check user vote status
aos> State.user_votes["USER_ID"]

-- Verify deposit amount (must be exactly 1 USDA)
aos> processCompleteVote("test_user", "true", 1000000000)

-- Check system consistency
aos> validateSystemConsistency()
```

#### 3. AI Evaluation Issues

**Symptoms**: AI evaluation not working
**Solutions**:
```lua
-- Check AI system status
aos> State.ai_system.enabled

-- Verify AI prompt template
aos> Send({Target = ao.id, Action = "Get-AI-Prompt"})

-- Check pending evaluations
aos> getAIStatistics()

-- Enable AI system if disabled
aos> Send({Target = ao.id, Action = "Toggle-AI-System"})
```

#### 4. SBT Creation Problems

**Symptoms**: SBTs not being created
**Solutions**:
```lua
-- Check SBT creation logic
aos> State.sbt_tokens

-- Verify lucky number generation
aos> createRandomRequest()

-- Check RandAO integration
aos> State.randao_process_id ~= ""
```

#### 5. State Consistency Errors

**Symptoms**: Inconsistent state reported
**Solutions**:
```lua
-- Check specific consistency issues
aos> validateSystemConsistency()

-- Fix vote count mismatches
aos> #getUserVotesList()
aos> State.voting_stats.true_votes + State.voting_stats.fake_votes

-- Recalculate deposits
aos> getPoolStatistics()

-- Reset if severely corrupted (admin only)
aos> Send({
    Target = ao.id,
    Action = "Reset-State",
    ["Reset-Type"] = "all"
})
```

### Debug Commands

```lua
-- Comprehensive debug info
aos> Send({Target = ao.id, Action = "Debug-Info"})

-- Check all integrations
aos> State.qf_calculator_process_id
aos> State.randao_process_id  
aos> State.usda_token_process
aos> State.ai_system.enabled

-- Verify handler registration
aos> Handlers.list()

-- Test core functions
aos> calculateQuadraticVoting()
aos> buildAIPrompt(State.active_tweet)
aos> getPoolStatistics()
```

---

## Performance Optimization

### 1. Handler Optimization

- Minimize state lookups in frequently called handlers
- Use appropriate data structures for quick access
- Implement caching for expensive calculations

### 2. Memory Management

```lua
-- Monitor state size growth
aos> State.user_votes and #State.user_votes or 0
aos> State.sbt_tokens and #State.sbt_tokens or 0

-- Periodic cleanup (if needed)
-- Remove old test data, optimize data structures
```

### 3. Network Efficiency

- Batch external service calls when possible
- Implement proper error handling and retries
- Monitor external service response times

### 4. Scaling Considerations

For production deployment:
- Monitor transaction volumes
- Plan for state growth management
- Consider data archival strategies for old votes/SBTs
- Implement rate limiting if needed

---

## Security Best Practices

### 1. Access Control

```lua
-- Always verify admin access for sensitive operations
if msg.From ~= State.admin then
    sendErrorResponse(msg.From, "Unauthorized", "ADMIN_REQUIRED")
    return
end
```

### 2. Input Validation

```lua
-- Validate all user inputs
if not vote_type or (vote_type ~= "true" and vote_type ~= "fake") then
    return false, "Invalid vote type"
end

-- Verify deposit amounts
if amount ~= 1000000000 then -- Exactly 1 USDA
    return false, "Invalid deposit amount"
end
```

### 3. State Protection

```lua
-- Use consistency checks
local consistency = validateSystemConsistency()
if not consistency.consistent then
    -- Handle inconsistent state
    print("State consistency issues:", table.concat(consistency.issues, ", "))
end
```

---

## Production Deployment Checklist

### Pre-deployment

- [ ] All tests passing (`runCompleteIntegrationTest()`)
- [ ] External integrations configured
- [ ] Admin process ID set correctly
- [ ] Sample data loaded and verified
- [ ] AI system configured and tested
- [ ] Documentation updated

### Post-deployment

- [ ] Verify process responding to Info requests
- [ ] Test complete voting flow
- [ ] Confirm dashboard data availability
- [ ] Validate AI evaluation working
- [ ] Check system consistency
- [ ] Monitor initial performance metrics
- [ ] Backup initial state configuration

### Ongoing Monitoring

- [ ] Daily system health checks
- [ ] Weekly consistency validations
- [ ] Monthly performance reviews
- [ ] Quarterly security audits
- [ ] State backup procedures
- [ ] Update documentation as needed

---

## Support & Resources

### Documentation
- `api-spec.md`: Complete API reference
- `README.md`: Project overview and setup
- Individual test files: Feature-specific testing

### Key Functions for Debugging
- `validateSystemConsistency()`: Check state integrity
- `getPoolStatistics()`: Monitor deposits and voting
- `calculateQuadraticVoting()`: Verify QF calculations
- `getAIStatistics()`: Monitor AI system health

### Community Resources
- AO Network documentation
- Arweave developer community
- TruthFi GitHub repository issues

---

This deployment guide provides comprehensive instructions for successfully deploying and maintaining the TruthFi Process. Follow the procedures carefully and refer to the troubleshooting section for any issues encountered during deployment.

For additional support, refer to the API specification and test files for detailed implementation examples.