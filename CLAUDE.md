# Claude Configuration for TruthFi MVP

## Project Overview

**TruthFi** is a decentralized fake news voting platform built on the AO ecosystem. Users vote on news authenticity by depositing USDA tokens, receive SBTs (Soul Bound Tokens) as voting records, and compare their judgments with AI analysis.

### Key Technologies

- **AO Network**: Decentralized compute platform
- **USDA**: Stable cryptocurrency for deposits
- **Apus AI SDK**: AI-powered news authenticity analysis
- **RandAO**: Decentralized randomness for gamification
- **Atomic Assets**: SBT (Soul Bound Token) implementation

### MVP Scope

- Single fake news item voting (celebrity marriage news)
- Fixed 1 USDA deposit per vote
- True/Fake binary voting system
- SBT issuance with Lucky Numbers
- AI confidence percentage display

## Project Structure

```
truthfi-mvp/
├── Claude.md                          # This file
├── README.md                          # Project documentation
├── docs/                              # Reference documentation
│   ├── ao-ecosystem/                  # AO dApps documentation
│   └── project/                       # Project-specific docs
├── claude/
│   └── prompts/                       # Claude Code prompts
│       ├── phase-1-1-basic-structure.md
│       ├── phase-1-2-voting-system.md
│       ├── phase-2-1-randao-integration.md
│       └── ...
├── process/                           # AO Process implementation
│   ├── src/
│   │   ├── truthfi-core.lua          # Main process file
│   │   ├── handlers/                 # Process handlers
│   │   ├── modules/                  # Utility modules
│   │   └── tests/                    # Test files
│   ├── deploy/                       # Deployment scripts
│   └── docs/                         # Process documentation
└── scripts/                          # Development scripts
```

## Development Guidelines

### Code Implementation Rules

1. **Language**: Primary implementation in Lua for AO Process
2. **Style**: Follow AO ecosystem conventions from `/docs/ao-ecosystem/`
3. **Error Handling**: Use `assert()` for critical validations, graceful degradation for non-critical
4. **State Management**: Single global `State` table with structured data
5. **Testing**: Write tests in `/process/src/tests/` for each major feature

### AO Process Patterns

**Handler Structure**

```lua
Handlers.add(
    "HandlerName",
    Handlers.utils.hasMatchingTag("Action", "ActionName"),
    function(msg)
        -- Implementation
        ao.send({Target = msg.From, Data = result})
    end
)
```

**State Management**

```lua
-- Global state structure
State = State or {
    active_news = {},
    voting_stats = {},
    user_votes = {},
    sbt_tokens = {}
}
```

### External SDK Integration

**RandAO Module**

- Use `@randao/random` package
- Reference: `/docs/ao-ecosystem/RandAO_Module_README.md`
- Lucky Number generation for SBT metadata

**Apus AI SDK**

- Reference: `/docs/ao-ecosystem/ApusAI_Inference.md`
- News authenticity confidence scoring (0-1 scale)

**USDA Integration**

- Reference: `/docs/ao-ecosystem/Bridge_Stables_to_AO_Astro.md`
- Fixed 1 USDA deposit per vote

### Implementation Phases

1. **Phase 1**: Basic voting system with USDA deposits
2. **Phase 2**: SBT issuance with RandAO Lucky Numbers
3. **Phase 3**: Apus AI integration for authenticity analysis
4. **Phase 4**: System integration and testing

## Claude Code Instructions

### Context Awareness

- Always reference `/docs/ao-ecosystem/` for AO implementation patterns
- Follow the phase-based implementation approach
- Maintain consistency with existing AO dApps architecture

### Code Quality Standards

- Include comprehensive error handling
- Add descriptive comments for complex logic
- Provide test cases for critical functions
- Follow Lua best practices for AO environment

### Integration Requirements

- Ensure compatibility with AO Process message passing
- Handle asynchronous operations properly (RandAO, Apus AI)
- Maintain state consistency across handler executions
- Implement proper validation for external data

## Testing Strategy

### Local Testing

- Use AOS CLI for handler testing
- Mock external services (Apus AI, RandAO) during development
- Validate state changes after each operation

### Integration Testing

- Test complete user flow: vote → deposit → SBT issuance
- Verify external SDK integrations
- Test error scenarios and edge cases

## Deployment Notes

### Prerequisites

- AO testnet environment setup
- Test USDA tokens for development
- Apus AI SDK access credentials
- RandAO module installation

### Configuration

- Process deployment on AO testnet
- External service endpoint configuration
- Initial state setup with sample news

## Reference Documentation

All AO ecosystem documentation is available in `/docs/ao-ecosystem/`:

- Atomic Assets implementation
- Botega DeFi platform patterns
- Dexi autonomous agents architecture
- USDA bridge functionality
- RandAO randomness protocols
- Apus AI inference services

## Development Workflow

1. **Phase Selection**: Choose implementation phase from prompts
2. **Prompt Execution**: Use Claude Code with phase-specific prompt
3. **Testing**: Validate implementation locally
4. **Integration**: Combine with existing codebase
5. **Documentation**: Update process docs and API specs

---

_This configuration enables Claude to understand the TruthFi project context, AO ecosystem requirements, and implementation guidelines for effective code generation._
