# Phase 0-1: QF Calculator Process

## Implementation Target

Implement an independent AO Process that performs Quadratic Funding calculations.

## Requirements

- Gitcoin Quadratic Funding algorithm implementation
- Limit influence of large voters (whales)
- Democratic score calculation prioritizing voter count
- Support for calls from other Processes

## Implementation Details

### 1. Global State Definition

```lua
State = State or {
    version = "1.0.0",
    algorithm = "quadratic_funding",
    calculations = {}  -- calculation history
}
```

### 2. QF Calculation Algorithm

```lua
-- Quadratic Funding calculation function
function calculateQuadraticFunding(votes_data)
    -- votes_data = {
    --     true_votes: { amounts: [], voters: [] },
    --     fake_votes: { amounts: [], voters: [] }
    -- }

    -- Use sum of √(vote amount) for whale protection
    -- true_score = (√amount1 + √amount2 + ...)^2
    -- fake_score = (√amount1 + √amount2 + ...)^2
    -- true_percentage = true_score / (true_score + fake_score) * 100
end
```

### 3. Basic Handlers

- **Calculate-QF-Score**: Execute QF score calculation
- **Get-QF-Info**: Process information and algorithm details
- **Set-Algorithm**: Change QF calculation method (admin only)

### 4. Input/Output Format

```lua
-- Input
{
    "true_votes": {
        "amounts": ["1000000000", "2000000000", "500000000"],
        "voters": 3
    },
    "fake_votes": {
        "amounts": ["3000000000", "1000000000"],
        "voters": 2
    }
}

-- Output
{
    "true_percentage": 45.2,
    "fake_percentage": 54.8,
    "true_qf_score": "1234567890",
    "fake_qf_score": "1500000000",
    "total_participants": 5
}
```

## Quadratic Funding Features

- **Square Root Calculation**: Use √(vote amount) to limit large voter influence
- **Democracy Focus**: More voters provide greater advantage
- **Transparency**: Record and publish calculation process

## Output File

`process/src/qf-calculator.lua`

## Reference

- Gitcoin Quadratic Funding documentation
- Inter-Process communication patterns in `/docs/ao-ecosystem/`

## Test Cases

- Normal cases (multiple voters)
- Whale protection (1 large voter vs many small voters)
- Edge cases (0 votes, equal amount votes)
