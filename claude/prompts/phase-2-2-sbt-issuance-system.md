# Phase 2-2: SBT Issuance System

## Implementation Target

Implement a system to issue SBT (Soul Bound Token) upon voting completion.

## Requirements

- SBT issuance as Atomic Assets
- Metadata including voting information and Lucky Number
- SBT management per user

## Implementation Details

### 1. SBT Issuance Process

- Automatic issuance upon voting completion
- Lucky Number acquisition wait
- Metadata construction

### 2. SBT Metadata Structure

```json
{
  "vote_choice": "true/fake",
  "vote_timestamp": 1703123456789,
  "news_id": "celebrity_marriage_001",
  "lucky_number": 777,
  "deposit_amount": "1000000000"
}
```

### 3. SBT Management Handlers

- **Issue-SBT**: SBT issuance processing
- **Get-User-SBTs**: User SBT list
- **Get-SBT-Info**: SBT detailed information

## Atomic Asset Integration

- Process spawn
- Metadata configuration
- Ownership management

## Output File

`process/src/truthfi-core.lua` (addition to Phase 2-1)

## Reference

- `/docs/ao-ecosystem/AtomicAssets.md`
- `/docs/ao-ecosystem/AO_Collections.md`
