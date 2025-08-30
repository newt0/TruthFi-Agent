# Phase 1-1: Basic Process Structure

## Implementation Target

Implement the basic structure of the TruthFi Process running on AO.

## Requirements

- Process name: TruthFi Core
- Management of one celebrity marriage news item
- Basic Handler structure
- Global State management

## Implementation Details

### 1. Global State Definition

```lua
State = State or {
    active_news = {
        id = "celebrity_marriage_001",
        title = "Celebrity A and B Marriage Report",
        content = "Marriage news reported by Media X in December 2024",
        ai_confidence = 0.0
    },
    voting_stats = {
        true_votes = 0,
        fake_votes = 0,
        total_deposits = "0",
        unique_voters = 0
    },
    user_votes = {},
    sbt_tokens = {}
}
```

### 2. Basic Handlers

- **Info**: Retrieve Process information
- **Get-News**: Retrieve active news
- **Get-Stats**: Retrieve voting statistics

### 3. Sample News Data

- Celebrity marriage report (using pseudonyms)
- Content suitable for truth/fake determination

## Output File

`process/src/truthfi-core.lua`

## Reference

- AO Process implementation patterns in `/docs/ao-ecosystem/`
- Handler structure best practices

## Expected Deliverables

- Complete Lua code
- Explanatory comments for each function
- Sample data for testing
