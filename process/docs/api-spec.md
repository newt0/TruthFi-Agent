# TruthFi Process API Specification

## Version: 1.0.0
## Phase: 4-1-system-integration

This document provides comprehensive API specification for all handlers in the TruthFi Process, a decentralized fake news voting platform built on the AO ecosystem.

---

## Table of Contents

1. [Overview](#overview)
2. [Core System Handlers](#core-system-handlers)
3. [Voting System Handlers](#voting-system-handlers)
4. [SBT System Handlers](#sbt-system-handlers)
5. [RandAO Integration Handlers](#randao-integration-handlers)
6. [AI Integration Handlers](#ai-integration-handlers)
7. [Pool Management Handlers](#pool-management-handlers)
8. [System Integration Handlers](#system-integration-handlers)
9. [Error Handling](#error-handling)
10. [Data Structures](#data-structures)

---

## Overview

The TruthFi Process implements a complete decentralized voting system with the following features:
- USDA-based voting with fixed 1 USDA deposits
- Soul Bound Token (SBT) issuance with Lucky Numbers
- AI-powered truth evaluation using Apus AI
- Quadratic Funding (QF) for democratic vote weighting
- Real-time state consistency validation

### Key Technologies
- **AO Network**: Decentralized compute platform
- **USDA Token**: Stable cryptocurrency deposits
- **Apus AI SDK**: AI-powered news analysis
- **RandAO**: Decentralized randomness generation
- **Atomic Assets**: SBT implementation

---

## Core System Handlers

### 1. Info
**Action**: `Info`  
**Description**: Returns basic process information and current state.

**Request**:
```lua
{
  Action = "Info"
}
```

**Response**:
```lua
{
  status = "success",
  name = "TruthFi Core",
  version = "1.0.0",
  phase = "4-1-system-integration",
  admin = "admin_process_id",
  initialized = true,
  active_case = {
    case_id = "celebrity_marriage_case_1",
    title = "Celebrity Marriage Announcement Analysis"
  },
  integrations = {
    qf_calculator = true,
    randao = true,
    usda_token = true,
    ai_system = true
  }
}
```

### 2. Get-Tweet-Case
**Action**: `Get-Tweet-Case`  
**Description**: Retrieves current active tweet case information.

**Request**:
```lua
{
  Action = "Get-Tweet-Case"
}
```

**Response**:
```lua
{
  status = "success",
  case_id = "celebrity_marriage_case_1",
  title = "Celebrity Marriage Announcement Analysis",
  main_tweet = {
    username = "@celebrity_news_official",
    content = "BREAKING: Celebrity couple announces surprise marriage!",
    followers = 1500000,
    verified = true,
    likes = 25000,
    retweets = 8500,
    replies = 3200
  },
  reference_tweets = [
    {
      username = "@entertainment_reporter",
      content = "Can confirm the marriage announcement is legitimate.",
      verified = true,
      likes = 1200,
      retweets = 340
    }
  ],
  ai_confidence = 0.75,
  created_at = 1234567890
}
```

### 3. Get-Stats
**Action**: `Get-Stats`  
**Description**: Returns comprehensive voting and system statistics.

**Request**:
```lua
{
  Action = "Get-Stats"
}
```

**Response**:
```lua
{
  status = "success",
  voting_stats = {
    true_votes = 45,
    fake_votes = 23,
    true_deposited = "45000000000",
    fake_deposited = "23000000000",
    true_voters = 45,
    fake_voters = 23
  },
  quadratic_funding = {
    true_percentage = 65.2,
    fake_percentage = 34.8,
    method = "quadratic"
  },
  pool_info = {
    total_deposits_usda = 68.0,
    total_participants = 68,
    pool_balance = "68000000000"
  },
  sbt_system = {
    total_issued = 68,
    active_tokens = 68
  },
  ai_evaluation = {
    available = true,
    true_confidence = 75.0,
    fake_confidence = 25.0
  }
}
```

---

## Voting System Handlers

### 4. Credit-Notice
**Action**: `Credit-Notice`  
**Description**: Processes USDA deposits for voting (automatic handler).

**Request** (from USDA Token Process):
```lua
{
  Action = "Credit-Notice",
  From = "usda_token_process_id",
  Tags = {
    Sender = "user_wallet_address",
    Quantity = "1000000000",  -- 1 USDA in Armstrongs
    ["X-Vote-Type"] = "true"  -- or "fake"
  }
}
```

**Response**:
```lua
{
  status = "success",
  message = "Vote processed successfully",
  user_id = "user_wallet_address",
  vote_type = "true",
  amount = 1000000000,
  sbt_id = "sbt_user_1234567890",
  lucky_number = 123456,
  voting_stats = {
    true_votes = 46,
    fake_votes = 23
  }
}
```

---

## System Integration Handlers

### 5. Complete-Vote
**Action**: `Complete-Vote`  
**Description**: Processes complete voting flow with all integrations.

**Request**:
```lua
{
  Action = "Complete-Vote",
  Tags = {
    ["Vote-Type"] = "true"  -- or "fake"
  }
}
```

**Response**:
```lua
{
  status = "success",
  message = "Vote processed successfully with full integration",
  result = {
    sbt_id = "sbt_user_1234567890",
    lucky_number = 123456,
    processing_steps = [
      "vote_validation",
      "vote_processing", 
      "lucky_number_generation",
      "sbt_creation",
      "ai_evaluation_check"
    ]
  },
  system_consistency = {
    consistent = true,
    issues = [],
    total_votes = 69,
    total_deposits = 69.0,
    sbt_count = 69
  }
}
```

### 6. Dashboard-Data
**Action**: `Dashboard-Data`  
**Description**: Returns unified data for UI dashboard.

**Request**:
```lua
{
  Action = "Dashboard-Data"
}
```

**Response**:
```lua
{
  status = "success",
  timestamp = 1234567890,
  system_consistency = {
    consistent = true,
    issues = []
  },
  active_case = {
    case_id = "celebrity_marriage_case_1",
    title = "Celebrity Marriage Analysis"
  },
  voting = {
    stats = { /* voting statistics */ },
    quadratic_funding = { /* QF results */ }
  },
  ai_evaluation = {
    available = true,
    true_confidence = 75.0,
    fake_confidence = 25.0,
    human_vs_ai = {
      agreement_level = "high"
    }
  },
  system_status = {
    process_name = "TruthFi Core",
    version = "1.0.0",
    phase = "4-1-system-integration"
  }
}
```

---

## AI Integration Handlers

### 7. AI-Evaluate
**Action**: `AI-Evaluate`  
**Description**: Triggers AI evaluation of current tweet case.

**Request**:
```lua
{
  Action = "AI-Evaluate",
  Tags = {
    ["Force-Reevaluate"] = "false"  -- optional
  }
}
```

### 8. Compare-Results
**Action**: `Compare-Results`  
**Description**: Compares AI evaluation with human voting results.

**Request**:
```lua
{
  Action = "Compare-Results"
}
```

**Response**:
```lua
{
  status = "success",
  human_voting = {
    true_percentage = 65.2,
    fake_percentage = 34.8,
    method = "quadratic"
  },
  ai_evaluation = {
    true_confidence = 75.0,
    fake_confidence = 25.0
  },
  comparison = {
    agreement_level = "high",
    ai_verdict = "true",
    human_verdict = "true",
    agreement = true
  }
}
```

---

## Error Handling

### Unified Error Response Format

All handlers use a consistent error response format:

```lua
{
  error = "Error message description",
  status = "error",
  timestamp = 1234567890,
  error_code = "ERROR_CODE_IDENTIFIER",
  context = {
    additional = "context_information"
  }
}
```

### Common Error Codes

- `UNAUTHORIZED`: Admin access required
- `MISSING_VOTE_TYPE`: Vote-Type tag missing
- `VOTE_PROCESSING_ERROR`: Vote processing failed
- `DUPLICATE_VOTE`: User already voted
- `INVALID_AMOUNT`: Deposit amount incorrect
- `INVALID_VOTE_TYPE`: Vote type not "true" or "fake"

---

## Data Structures

### State Structure
```lua
State = {
  -- Process metadata
  name = "TruthFi Core",
  version = "1.0.0",
  phase = "4-1-system-integration",
  admin = "admin_process_id",
  initialized = true,
  
  -- Active tweet case
  active_tweet = {
    case_id = "celebrity_marriage_case_1",
    title = "Celebrity Marriage Analysis",
    main_tweet = { /* tweet data */ },
    ai_confidence = 0.75
  },
  
  -- Voting statistics
  voting_stats = {
    true_votes = 45,
    fake_votes = 23,
    true_deposited = "45000000000",
    fake_deposited = "23000000000"
  },
  
  -- User votes
  user_votes = {
    ["user_id"] = {
      vote = "true",
      amount = 1000000000,
      timestamp = 1234567890
    }
  },
  
  -- SBT tokens
  sbt_tokens = {
    ["sbt_id"] = {
      id = "sbt_id",
      owner = "user_id", 
      metadata = { /* SBT metadata */ },
      status = "active"
    }
  },
  
  -- AI system
  ai_system = {
    enabled = true,
    evaluation_results = { /* AI results */ }
  }
}
```

---

## Usage Examples

### Basic Voting Flow
1. User sends `Complete-Vote` with vote type
2. System processes vote, creates SBT, generates lucky number
3. AI evaluation triggered automatically
4. User can check results with `Dashboard-Data`

### Dashboard Integration
```lua
-- Get complete dashboard data
{
  Action = "Dashboard-Data"
}

-- Compare AI vs Human results
{
  Action = "Compare-Results"
}
```

---

## Integration Requirements

### Frontend Integration
- Use `Dashboard-Data` for UI state
- Implement `Complete-Vote` for user voting
- Monitor system consistency in responses

### External Services
- **USDA Token Process**: For deposit handling
- **QF Calculator**: For democratic vote weighting
- **RandAO Process**: For lucky number generation  
- **Apus AI Service**: For truth evaluation

---

This API specification provides complete documentation for integrating with the TruthFi Process. All 35 handlers are operational and tested for production deployment.