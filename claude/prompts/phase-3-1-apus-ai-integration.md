# Phase 3-1: Apus AI Integration

## Implementation Target

Implement news truth verification functionality using the Apus AI SDK.

## Requirements

- AI analysis of news content
- Confidence percentage calculation
- Comparison display with human voting

## Implementation Details

### 1. Apus AI Module Integration

```lua
local ApusAI = require("@apus/ai-lib")
```

### 2. AI Evaluation Prompt

```
Please evaluate the truthfulness of the following news with a score from 0 to 1.
1 represents completely true, 0 represents completely false.
Please respond with only the numerical score: [News Content]
```

### 3. AI Evaluation Handlers

- **AI-Evaluate**: Execute AI evaluation
- **Get-AI-Analysis**: Retrieve evaluation results
- **Compare-Results**: Compare with human voting

### 4. Evaluation Result Management

- Save AI evaluation results
- Convert confidence percentage (0-1 → 0%-100%)
- Integration with statistical data

## Display Format

```
AI Evaluation: 75% True
Human Voting: True 45% | Fake 55%
```

## Output File

`process/src/truthfi-core.lua` (addition to Phase 2-2)

## Reference

- `/docs/ao-ecosystem/ApusAI_Inference.md`
- Asynchronous processing best practices
