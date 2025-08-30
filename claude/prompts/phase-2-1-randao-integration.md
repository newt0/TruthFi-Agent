# Phase 2-1: RandAO Integration

## Implementation Target

Implement Lucky Number generation functionality using the RandAO SDK.

## Requirements

- Integration of the provided RandAO Module (@randao/random)
- Lucky Number generation for SBT issuance
- Proper management of asynchronous processing

## Implementation Details

### 1. RandAO Module Integration

```lua
local randomModule = require('@randao/random')(json)
```

### 2. Lucky Number Management

- Random request recording
- Random response processing
- Integration into SBT metadata

### 3. RandomResponse Handler

```lua
Handlers.add(
    "RandomResponse",
    Handlers.utils.hasMatchingTag("Action", "RandomResponse"),
    function(msg)
        -- Process random number reception from RandAO
    end
)
```

## Features

- `randomModule.generateUUID()`: CallbackID generation
- `randomModule.requestRandom()`: Random request
- `randomModule.processRandomResponse()`: Response processing

## Output File

`process/src/truthfi-core.lua` (addition to Phase 1-3)

## Reference

- `/docs/ao-ecosystem/RandAO_Module_README.md`
- `/docs/ao-ecosystem/RandAO_source.lua`
