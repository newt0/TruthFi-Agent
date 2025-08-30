# Phase 1-3: USDA Pool Management

## Implementation Target

Implement simple pool management functionality for USDA received through voting.

## Requirements

- Manage received USDA within the Process
- Preparation for LiquidOps integration (to be implemented in later phases)
- Accurate tracking of statistical information

## Implementation Details

### 1. USDA Balance Management

```lua
-- Track USDA balance within Process
-- Record deposit history
-- Update statistical data
```

### 2. Enhanced Credit-Notice Handler

- Balance updates on USDA reception
- Record sender information
- Link with voting transactions

### 3. Pool Information Retrieval Handlers

- **Get-Pool-Info**: Pool statistics information
- **Get-Deposit-History**: Deposit history

## Security Considerations

- Reject unauthorized transfers
- Consistency checks with voting
- Ensure balance accuracy

## Output File

`process/src/truthfi-core.lua` (addition to Phase 1-2)

## Reference

- Token management patterns in `/docs/ao-ecosystem/`
- Implementation examples of in-Process balance tracking
