# Phase 3-1: Apus AI Integration

## Implementation Target

Implement tweet truth verification functionality using the Apus AI SDK.

## Requirements

- AI analysis of tweet content (multiple tweet support)
- Confidence percentage calculation
- Comparison display with human voting

## Implementation Details

### 1. Apus AI Module Integration

```lua
local ApusAI = require("@apus/ai-lib")
```

### 2. AI Evaluation Prompt Management

```lua
-- Dynamic prompt construction function
function buildAIPrompt(tweet_case)
    -- Format main_tweet + reference_tweets[]
    -- Include followers, verified information
    -- Customizable prompt template
end

-- Default prompt template
State.ai_prompt_template = [[
Please comprehensively evaluate the truthfulness of the following tweet and its related information.
Respond with a score from 0 to 1 (1=completely true, 0=completely false).

{MAIN_TWEET_DATA}
{REFERENCE_TWEETS_DATA}

Consider account reliability (follower count, verification status) and engagement numbers,
and respond with only the numerical score.
]]
```

### 3. Prompt Management Handlers

- **Set-AI-Prompt**: Update AI evaluation prompt (admin only)
- **Get-AI-Prompt**: Retrieve current prompt

### 4. AI Evaluation Handlers

- **AI-Evaluate**: Execute AI evaluation
- **Get-AI-Analysis**: Retrieve evaluation results
- **Compare-Results**: Compare with human voting

### 5. Evaluation Result Management

- Save AI evaluation results
- Convert confidence percentage (0-1 → 0%-100%)
- Quadratic Funding style human voting calculation
- Integration with statistical data

## Display Format

```
True Deposited:
  $10
  10 people

Fake Deposited:
  $20
  20 people

AI Evaluation: 75% True | 25% Fake
Human Voting: 40% True | 60% Fake
```

## Quadratic Funding Calculation

```lua
-- Reference Gitcoin's Quadratic Funding algorithm
-- Limit influence of large voters (whales)
-- Percentage calculation emphasizing voter count
function calculateQuadraticVoting()
    -- Implementation details specified within prompt
end
```

## Output File

`process/src/truthfi-core.lua` (addition to Phase 2-2)

## Reference

- `/docs/ao-ecosystem/ApusAI_Inference.md`
- Asynchronous processing best practices
