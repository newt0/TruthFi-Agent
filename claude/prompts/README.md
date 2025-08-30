# TruthFi Process Implementation Guide

## Execution Order

### Phase 1: Basic System

1. `phase-1-1-basic-structure.md` - Process basic structure and news management
2. `phase-1-2-voting-system.md` - USDA voting system implementation
3. `phase-1-3-usda-pool-management.md` - USDA pool management functionality

### Phase 2: SBT・RandAO

4. `phase-2-1-randao-integration.md` - RandAO integration and Lucky Number
5. `phase-2-2-sbt-issuance-system.md` - SBT issuance system

### Phase 3: AI Integration

6. `phase-3-1-apus-ai-integration.md` - Apus AI judgment functionality

### Phase 4: Integration・Testing

7. `phase-4-1-system-integration.md` - Full system integration
8. `phase-4-2-final-testing.md` - Final testing

## Output Files

- Main Process: `process/src/truthfi-core.lua`
- Test files: `process/src/tests/`
- Documentation: `process/docs/`

## Prerequisites

- Review reference documents in `/docs/ao-ecosystem/`
- Complete AOS environment setup
- Prepare test USDA・AO tokens

## Phase Completion Checklist

### Phase 1 Complete ✅

- [ ] Basic voting functionality operational
- [ ] USDA reception and statistics update
- [ ] Duplicate vote prevention

### Phase 2 Complete ✅

- [ ] RandAO Lucky Number retrieval
- [ ] SBT issuance functionality
- [ ] Metadata configuration

### Phase 3 Complete ✅

- [ ] Apus AI judgment result retrieval
- [ ] Confidence percentage display

### Phase 4 Complete ✅

- [ ] Full system integration
- [ ] Error handling
- [ ] Frontend integration preparation

## Error Response

- **Mid-phase errors**: Re-execute the relevant phase
- **Integration errors**: Use `debug-troubleshooting.md`
- **Performance issues**: Reference `performance-optimization.md`

## Support Prompts

- `debug-troubleshooting.md` - Debug assistance
- `performance-optimization.md` - Optimization
- `deployment-preparation.md` - Deployment preparation
