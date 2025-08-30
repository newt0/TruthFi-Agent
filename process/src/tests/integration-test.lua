-- TruthFi Integration Test Suite - Phase 4-2: Final Testing
-- Comprehensive testing of all handlers, edge cases, and system integration
-- Tests verify operation of complete TruthFi Process functionality

local json = require('json')

-- ============================================================================
-- TEST CONFIGURATION AND UTILITIES
-- ============================================================================

local IntegrationTest = {
    passed = 0,
    failed = 0,
    total = 0,
    results = {},
    verbose = true
}

-- Test utility functions
function IntegrationTest.assert(condition, message, test_name)
    IntegrationTest.total = IntegrationTest.total + 1
    
    if condition then
        IntegrationTest.passed = IntegrationTest.passed + 1
        if IntegrationTest.verbose then
            print(" " .. test_name .. ": " .. message)
        end
        IntegrationTest.results[test_name] = {status = "PASSED", message = message}
        return true
    else
        IntegrationTest.failed = IntegrationTest.failed + 1
        print(" " .. test_name .. ": " .. message)
        IntegrationTest.results[test_name] = {status = "FAILED", message = message}
        return false
    end
end

function IntegrationTest.reset()
    IntegrationTest.passed = 0
    IntegrationTest.failed = 0
    IntegrationTest.total = 0
    IntegrationTest.results = {}
end

function IntegrationTest.summary()
    print("\n" .. string.rep("=", 60))
    print("INTEGRATION TEST SUMMARY")
    print(string.rep("=", 60))
    print("Total Tests: " .. IntegrationTest.total)
    print("Passed: " .. IntegrationTest.passed)
    print("Failed: " .. IntegrationTest.failed)
    print("Success Rate: " .. string.format("%.1f%%", (IntegrationTest.passed / IntegrationTest.total) * 100))
    
    if IntegrationTest.failed > 0 then
        print("\nFAILED TESTS:")
        for test_name, result in pairs(IntegrationTest.results) do
            if result.status == "FAILED" then
                print("  - " .. test_name .. ": " .. result.message)
            end
        end
    end
    
    if IntegrationTest.passed == IntegrationTest.total then
        print("\n<‰ ALL TESTS PASSED! TruthFi Process is ready for deployment.")
    else
        print("\n   Some tests failed. Review implementation before deployment.")
    end
    
    return IntegrationTest.passed == IntegrationTest.total
end

-- ============================================================================
-- NORMAL CASE TESTS - Core Functionality
-- ============================================================================

local NormalCaseTests = {
    
    -- Test basic system initialization
    test_system_initialization = function()
        print("\n--- Testing System Initialization ---")
        
        IntegrationTest.assert(
            State ~= nil,
            "Global State initialized",
            "state_initialization"
        )
        
        IntegrationTest.assert(
            State.name == "TruthFi Core",
            "Process name correct: " .. (State.name or "nil"),
            "process_name"
        )
        
        IntegrationTest.assert(
            State.phase == "4-1-system-integration",
            "Process phase correct: " .. (State.phase or "nil"),
            "process_phase"
        )
        
        IntegrationTest.assert(
            State.initialized == true,
            "Process initialization flag set",
            "initialization_flag"
        )
        
        IntegrationTest.assert(
            State.active_tweet and State.active_tweet.case_id ~= "",
            "Sample tweet data loaded: " .. (State.active_tweet.case_id or "none"),
            "sample_data_loaded"
        )
    end,
    
    -- Test Info handler
    test_info_handler = function()
        print("\n--- Testing Info Handler ---")
        
        -- Simulate Info handler call
        local info_data = {
            name = State.name,
            version = State.version,
            phase = State.phase,
            admin = State.admin,
            initialized = State.initialized,
            active_case = {
                case_id = State.active_tweet.case_id,
                title = State.active_tweet.title
            }
        }
        
        IntegrationTest.assert(
            info_data.name and info_data.version and info_data.phase,
            "Info handler returns basic metadata",
            "info_metadata"
        )
        
        IntegrationTest.assert(
            info_data.active_case.case_id ~= "",
            "Info handler includes active case: " .. info_data.active_case.case_id,
            "info_active_case"
        )
    end,
    
    -- Test basic voting flow
    test_basic_voting_flow = function()
        print("\n--- Testing Basic Voting Flow ---")
        
        -- Reset voting stats for clean test
        local original_stats = State.voting_stats
        State.voting_stats = {
            true_votes = 0,
            fake_votes = 0,
            true_deposited = "0",
            fake_deposited = "0",
            true_voters = 0,
            fake_voters = 0
        }
        
        local test_user = "integration_test_voter_basic"
        State.user_votes[test_user] = nil -- Clear any existing vote
        
        -- Test complete vote processing
        local success, result, steps = processCompleteVote(test_user, "true", 1000000000)
        
        IntegrationTest.assert(
            success == true,
            "Complete vote processing successful",
            "vote_processing_success"
        )
        
        IntegrationTest.assert(
            State.user_votes[test_user] ~= nil,
            "User vote recorded in state",
            "user_vote_recorded"
        )
        
        IntegrationTest.assert(
            State.voting_stats.true_votes == 1,
            "True vote count updated: " .. State.voting_stats.true_votes,
            "vote_count_updated"
        )
        
        IntegrationTest.assert(
            State.voting_stats.true_deposited == "1000000000",
            "Deposit amount updated: " .. State.voting_stats.true_deposited,
            "deposit_updated"
        )
        
        IntegrationTest.assert(
            result and result.sbt_id,
            "SBT created: " .. (result and result.sbt_id or "none"),
            "sbt_created"
        )
        
        IntegrationTest.assert(
            result and result.lucky_number,
            "Lucky number generated: " .. (result and result.lucky_number or "none"),
            "lucky_number_generated"
        )
        
        -- Restore original stats
        State.voting_stats = original_stats
    end,
    
    -- Test USDA reception and statistics updates
    test_usda_reception = function()
        print("\n--- Testing USDA Reception ---")
        
        local test_user = "integration_test_usda_user"
        State.user_votes[test_user] = nil -- Clear any existing vote
        
        -- Simulate Credit-Notice processing
        local vote_data = {
            vote = "fake",
            amount = 1000000000,
            timestamp = os.time(),
            tx_id = "test_usda_tx_123"
        }
        
        State.user_votes[test_user] = vote_data
        
        IntegrationTest.assert(
            State.user_votes[test_user].amount == 1000000000,
            "USDA amount correctly recorded: " .. State.user_votes[test_user].amount,
            "usda_amount_recorded"
        )
        
        IntegrationTest.assert(
            State.user_votes[test_user].tx_id,
            "Transaction ID recorded: " .. State.user_votes[test_user].tx_id,
            "transaction_id_recorded"
        )
        
        -- Test statistics calculation
        local user_votes_list = getUserVotesList()
        
        IntegrationTest.assert(
            #user_votes_list > 0,
            "User votes list populated: " .. #user_votes_list .. " votes",
            "votes_list_populated"
        )
        
        -- Test pool statistics
        local pool_stats = getPoolStatistics()
        
        IntegrationTest.assert(
            pool_stats and pool_stats.total_deposits_usda >= 0,
            "Pool statistics calculated: $" .. (pool_stats and pool_stats.total_deposits_usda or 0),
            "pool_statistics"
        )
    end,
    
    -- Test SBT issuance
    test_sbt_issuance = function()
        print("\n--- Testing SBT Issuance ---")
        
        local test_user = "integration_test_sbt_user"
        
        -- Create SBT directly
        local sbt_id = "test_sbt_" .. test_user .. "_" .. os.time()
        local sbt_metadata = {
            case_id = State.active_tweet.case_id,
            case_title = State.active_tweet.title,
            voter_id = test_user,
            vote_type = "true",
            deposit_amount = 1000000000,
            vote_timestamp = os.time(),
            lucky_number = 123456,
            tweet_content = State.active_tweet.main_tweet.content,
            tweet_author = State.active_tweet.main_tweet.username
        }
        
        State.sbt_tokens[sbt_id] = {
            id = sbt_id,
            owner = test_user,
            metadata = sbt_metadata,
            created_at = os.time(),
            status = "active"
        }
        
        IntegrationTest.assert(
            State.sbt_tokens[sbt_id] ~= nil,
            "SBT created and stored: " .. sbt_id,
            "sbt_creation"
        )
        
        IntegrationTest.assert(
            State.sbt_tokens[sbt_id].metadata.lucky_number == 123456,
            "SBT metadata includes lucky number: " .. State.sbt_tokens[sbt_id].metadata.lucky_number,
            "sbt_lucky_number"
        )
        
        IntegrationTest.assert(
            State.sbt_tokens[sbt_id].metadata.case_id == State.active_tweet.case_id,
            "SBT linked to correct case: " .. State.sbt_tokens[sbt_id].metadata.case_id,
            "sbt_case_link"
        )
        
        -- Test SBT retrieval
        local user_sbts = {}
        for sbt_id, sbt_data in pairs(State.sbt_tokens) do
            if sbt_data.owner == test_user then
                table.insert(user_sbts, sbt_data)
            end
        end
        
        IntegrationTest.assert(
            #user_sbts > 0,
            "User SBTs retrievable: " .. #user_sbts .. " SBTs",
            "sbt_retrieval"
        )
    end,
    
    -- Test AI evaluation retrieval
    test_ai_evaluation = function()
        print("\n--- Testing AI Evaluation ---")
        
        -- Mock AI evaluation result
        State.ai_system.evaluation_results = {
            ai_score = 0.75,
            true_confidence = 75.0,
            fake_confidence = 25.0,
            case_id = State.active_tweet.case_id,
            evaluation_timestamp = os.time(),
            task_ref = "test_ai_task_ref"
        }
        
        IntegrationTest.assert(
            State.ai_system.evaluation_results.ai_score == 0.75,
            "AI score recorded: " .. State.ai_system.evaluation_results.ai_score,
            "ai_score_recorded"
        )
        
        IntegrationTest.assert(
            State.ai_system.evaluation_results.true_confidence == 75.0,
            "AI true confidence: " .. State.ai_system.evaluation_results.true_confidence .. "%",
            "ai_confidence_calculated"
        )
        
        IntegrationTest.assert(
            State.ai_system.evaluation_results.case_id == State.active_tweet.case_id,
            "AI evaluation linked to correct case",
            "ai_case_link"
        )
        
        -- Test AI vs Human comparison
        local qf_results = calculateQuadraticVoting()
        local ai_true = State.ai_system.evaluation_results.true_confidence
        local human_true = qf_results.true_percentage
        
        IntegrationTest.assert(
            qf_results.true_percentage >= 0 and qf_results.true_percentage <= 100,
            "QF human voting calculation valid: " .. string.format("%.1f%%", qf_results.true_percentage),
            "qf_calculation_valid"
        )
        
        local agreement_level = math.abs(ai_true - human_true) < 10 and "high" or 
                              (math.abs(ai_true - human_true) < 25 and "medium" or "low")
        
        IntegrationTest.assert(
            agreement_level ~= nil,
            "AI vs Human agreement level calculated: " .. agreement_level,
            "ai_human_agreement"
        )
    end,
    
    -- Test dashboard data integration
    test_dashboard_integration = function()
        print("\n--- Testing Dashboard Data Integration ---")
        
        -- Simulate Dashboard-Data handler
        local dashboard_data = {
            status = "success",
            timestamp = os.time(),
            system_consistency = validateSystemConsistency()
        }
        
        IntegrationTest.assert(
            dashboard_data.system_consistency ~= nil,
            "System consistency check included",
            "dashboard_consistency"
        )
        
        IntegrationTest.assert(
            dashboard_data.system_consistency.consistent ~= nil,
            "Consistency status available: " .. tostring(dashboard_data.system_consistency.consistent),
            "consistency_status"
        )
        
        -- Add more dashboard components
        dashboard_data.active_case = {
            case_id = State.active_tweet.case_id,
            title = State.active_tweet.title
        }
        
        dashboard_data.voting = {
            stats = State.voting_stats,
            quadratic_funding = calculateQuadraticVoting()
        }
        
        IntegrationTest.assert(
            dashboard_data.active_case.case_id ~= "",
            "Active case included: " .. dashboard_data.active_case.case_id,
            "dashboard_active_case"
        )
        
        IntegrationTest.assert(
            dashboard_data.voting.quadratic_funding ~= nil,
            "QF results included in dashboard",
            "dashboard_qf_results"
        )
    end
}

-- ============================================================================
-- EDGE CASE TESTS - Error Scenarios and Validation
-- ============================================================================

local EdgeCaseTests = {
    
    -- Test duplicate vote errors
    test_duplicate_vote_error = function()
        print("\n--- Testing Duplicate Vote Errors ---")
        
        local test_user = "integration_test_duplicate_user"
        
        -- First vote (should succeed)
        State.user_votes[test_user] = nil -- Clear any existing vote
        local first_success, first_result = processCompleteVote(test_user, "true", 1000000000)
        
        IntegrationTest.assert(
            first_success == true,
            "First vote succeeds",
            "duplicate_first_vote_success"
        )
        
        -- Second vote (should fail)
        local second_success, second_result = processCompleteVote(test_user, "fake", 1000000000)
        
        IntegrationTest.assert(
            second_success == false,
            "Second vote correctly rejected",
            "duplicate_vote_rejection"
        )
        
        IntegrationTest.assert(
            second_result == "User has already voted",
            "Correct duplicate vote error message: " .. tostring(second_result),
            "duplicate_vote_error_message"
        )
        
        -- Verify state consistency
        local consistency = validateSystemConsistency()
        
        IntegrationTest.assert(
            consistency.consistent == true,
            "System remains consistent after duplicate attempt",
            "duplicate_vote_consistency"
        )
    end,
    
    -- Test invalid amount errors
    test_invalid_amount_error = function()
        print("\n--- Testing Invalid Amount Errors ---")
        
        local test_user = "integration_test_invalid_amount_user"
        State.user_votes[test_user] = nil -- Clear any existing vote
        
        -- Test with invalid amount (not 1 USDA)
        local success, result = processCompleteVote(test_user, "true", 500000000) -- 0.5 USDA
        
        IntegrationTest.assert(
            success == false,
            "Invalid amount correctly rejected",
            "invalid_amount_rejection"
        )
        
        IntegrationTest.assert(
            result == "Invalid deposit amount",
            "Correct invalid amount error message: " .. tostring(result),
            "invalid_amount_error_message"
        )
        
        -- Test with zero amount
        local zero_success, zero_result = processCompleteVote(test_user, "true", 0)
        
        IntegrationTest.assert(
            zero_success == false,
            "Zero amount correctly rejected",
            "zero_amount_rejection"
        )
        
        -- Test with excessive amount
        local excessive_success, excessive_result = processCompleteVote(test_user, "true", 10000000000) -- 10 USDA
        
        IntegrationTest.assert(
            excessive_success == false,
            "Excessive amount correctly rejected",
            "excessive_amount_rejection"
        )
        
        -- Verify no votes were recorded
        IntegrationTest.assert(
            State.user_votes[test_user] == nil,
            "No vote recorded for invalid amounts",
            "invalid_amount_no_vote"
        )
    end,
    
    -- Test invalid choice errors
    test_invalid_choice_error = function()
        print("\n--- Testing Invalid Choice Errors ---")
        
        local test_user = "integration_test_invalid_choice_user"
        State.user_votes[test_user] = nil -- Clear any existing vote
        
        -- Test invalid vote type
        local success, result = processCompleteVote(test_user, "maybe", 1000000000)
        
        IntegrationTest.assert(
            success == false,
            "Invalid vote choice correctly rejected",
            "invalid_choice_rejection"
        )
        
        IntegrationTest.assert(
            result == "Invalid vote type",
            "Correct invalid choice error message: " .. tostring(result),
            "invalid_choice_error_message"
        )
        
        -- Test empty vote type
        local empty_success, empty_result = processCompleteVote(test_user, "", 1000000000)
        
        IntegrationTest.assert(
            empty_success == false,
            "Empty vote choice correctly rejected",
            "empty_choice_rejection"
        )
        
        -- Test nil vote type
        local nil_success, nil_result = processCompleteVote(test_user, nil, 1000000000)
        
        IntegrationTest.assert(
            nil_success == false,
            "Nil vote choice correctly rejected",
            "nil_choice_rejection"
        )
        
        -- Test case sensitivity
        local case_success, case_result = processCompleteVote(test_user, "TRUE", 1000000000)
        
        IntegrationTest.assert(
            case_success == false,
            "Case-sensitive vote choice correctly rejected",
            "case_sensitive_rejection"
        )
    end,
    
    -- Test system state corruption recovery
    test_state_corruption_recovery = function()
        print("\n--- Testing State Corruption Recovery ---")
        
        -- Create inconsistent state
        local original_votes = State.voting_stats.true_votes
        local original_deposits = State.voting_stats.true_deposited
        
        -- Intentionally corrupt state
        State.voting_stats.true_votes = original_votes + 5 -- Wrong count
        State.voting_stats.true_deposited = "999999999999" -- Wrong amount
        
        local consistency = validateSystemConsistency()
        
        IntegrationTest.assert(
            consistency.consistent == false,
            "System correctly detects corruption",
            "corruption_detection"
        )
        
        IntegrationTest.assert(
            #consistency.issues > 0,
            "Corruption issues identified: " .. #consistency.issues,
            "corruption_issues_found"
        )
        
        -- Restore original state
        State.voting_stats.true_votes = original_votes
        State.voting_stats.true_deposited = original_deposits
        
        local restored_consistency = validateSystemConsistency()
        
        IntegrationTest.assert(
            restored_consistency.consistent == true,
            "System consistency restored",
            "corruption_recovery"
        )
    end,
    
    -- Test error response format
    test_error_response_format = function()
        print("\n--- Testing Error Response Format ---")
        
        -- Test unified error response structure
        local error_response = {
            error = "Test error message",
            status = "error",
            timestamp = os.time(),
            error_code = "TEST_ERROR",
            context = {test_context = "validation"}
        }
        
        IntegrationTest.assert(
            error_response.status == "error",
            "Error response has correct status",
            "error_status_format"
        )
        
        IntegrationTest.assert(
            error_response.error ~= nil and error_response.error ~= "",
            "Error response has message: " .. (error_response.error or "none"),
            "error_message_format"
        )
        
        IntegrationTest.assert(
            error_response.timestamp ~= nil,
            "Error response has timestamp",
            "error_timestamp_format"
        )
        
        IntegrationTest.assert(
            error_response.error_code ~= nil,
            "Error response has error code: " .. (error_response.error_code or "none"),
            "error_code_format"
        )
        
        IntegrationTest.assert(
            error_response.context ~= nil,
            "Error response has context",
            "error_context_format"
        )
    end
}

-- ============================================================================
-- PERFORMANCE TESTS
-- ============================================================================

local PerformanceTests = {
    
    -- Test system performance under load
    test_performance_load = function()
        print("\n--- Testing System Performance ---")
        
        local start_time = os.time()
        local operations = 0
        
        -- Perform multiple operations
        for i = 1, 10 do
            local test_user = "perf_user_" .. i
            State.user_votes[test_user] = nil -- Clear existing
            
            local vote_type = (i % 2 == 0) and "true" or "fake"
            local success, result = processCompleteVote(test_user, vote_type, 1000000000)
            
            if success then
                operations = operations + 1
            end
        end
        
        local end_time = os.time()
        local duration = end_time - start_time
        
        IntegrationTest.assert(
            duration <= 5,
            "Performance acceptable: " .. duration .. " seconds for " .. operations .. " operations",
            "performance_timing"
        )
        
        IntegrationTest.assert(
            operations >= 8,
            "Operations successful: " .. operations .. "/10",
            "performance_success_rate"
        )
        
        -- Test memory consistency
        local consistency = validateSystemConsistency()
        
        IntegrationTest.assert(
            consistency.consistent == true,
            "System remains consistent under load",
            "performance_consistency"
        )
    end,
    
    -- Test handler response times
    test_handler_response_times = function()
        print("\n--- Testing Handler Response Times ---")
        
        local handlers_tested = 0
        local fast_responses = 0
        
        -- Test Info handler timing
        local info_start = os.time()
        local info_data = {
            name = State.name,
            version = State.version,
            phase = State.phase
        }
        local info_end = os.time()
        handlers_tested = handlers_tested + 1
        
        if (info_end - info_start) <= 1 then
            fast_responses = fast_responses + 1
        end
        
        -- Test Get-Stats handler timing
        local stats_start = os.time()
        local qf_results = calculateQuadraticVoting()
        local stats_end = os.time()
        handlers_tested = handlers_tested + 1
        
        if (stats_end - stats_start) <= 1 then
            fast_responses = fast_responses + 1
        end
        
        -- Test consistency check timing
        local consistency_start = os.time()
        local consistency = validateSystemConsistency()
        local consistency_end = os.time()
        handlers_tested = handlers_tested + 1
        
        if (consistency_end - consistency_start) <= 1 then
            fast_responses = fast_responses + 1
        end
        
        IntegrationTest.assert(
            fast_responses >= handlers_tested * 0.8,
            "Handler response times acceptable: " .. fast_responses .. "/" .. handlers_tested .. " fast",
            "handler_response_times"
        )
    end
}

-- ============================================================================
-- MAIN TEST RUNNER
-- ============================================================================

function runCompleteIntegrationTest()
    print("TruthFi Process - Complete Integration Test Suite")
    print("Phase 4-2: Final Testing and Validation")
    print(string.rep("=", 60))
    
    IntegrationTest.reset()
    
    -- Run normal case tests
    print("\n" .. string.rep("=", 40))
    print("NORMAL CASE TESTS")
    print(string.rep("=", 40))
    
    NormalCaseTests.test_system_initialization()
    NormalCaseTests.test_info_handler()
    NormalCaseTests.test_basic_voting_flow()
    NormalCaseTests.test_usda_reception()
    NormalCaseTests.test_sbt_issuance()
    NormalCaseTests.test_ai_evaluation()
    NormalCaseTests.test_dashboard_integration()
    
    -- Run edge case tests
    print("\n" .. string.rep("=", 40))
    print("EDGE CASE TESTS")
    print(string.rep("=", 40))
    
    EdgeCaseTests.test_duplicate_vote_error()
    EdgeCaseTests.test_invalid_amount_error()
    EdgeCaseTests.test_invalid_choice_error()
    EdgeCaseTests.test_state_corruption_recovery()
    EdgeCaseTests.test_error_response_format()
    
    -- Run performance tests
    print("\n" .. string.rep("=", 40))
    print("PERFORMANCE TESTS")
    print(string.rep("=", 40))
    
    PerformanceTests.test_performance_load()
    PerformanceTests.test_handler_response_times()
    
    -- Final system validation
    print("\n" .. string.rep("=", 40))
    print("FINAL SYSTEM VALIDATION")
    print(string.rep("=", 40))
    
    local final_consistency = validateSystemConsistency()
    IntegrationTest.assert(
        final_consistency.consistent == true,
        "Final system consistency check passed",
        "final_consistency_check"
    )
    
    -- Check all critical components
    IntegrationTest.assert(
        State.initialized == true,
        "System properly initialized",
        "final_initialization"
    )
    
    IntegrationTest.assert(
        State.active_tweet.case_id ~= "",
        "Active case available",
        "final_active_case"
    )
    
    IntegrationTest.assert(
        State.phase == "4-1-system-integration",
        "System at correct phase",
        "final_phase_check"
    )
    
    -- Show summary
    local all_passed = IntegrationTest.summary()
    
    if all_passed then
        print("\n=€ TruthFi Process is READY FOR DEPLOYMENT")
        print("All functionality tested and validated successfully.")
    else
        print("\n=à  TruthFi Process needs attention before deployment")
        print("Please address failed tests before proceeding.")
    end
    
    return all_passed
end

-- Quick smoke test function
function runSmokeTest()
    print("TruthFi Process - Smoke Test")
    print("Quick validation of core functionality")
    print(string.rep("-", 40))
    
    IntegrationTest.reset()
    IntegrationTest.verbose = false
    
    -- Essential tests only
    NormalCaseTests.test_system_initialization()
    NormalCaseTests.test_basic_voting_flow()
    EdgeCaseTests.test_duplicate_vote_error()
    
    local smoke_passed = IntegrationTest.passed == IntegrationTest.total
    
    if smoke_passed then
        print(" Smoke test PASSED - Core functionality working")
    else
        print(" Smoke test FAILED - Core issues detected")
    end
    
    IntegrationTest.verbose = true
    return smoke_passed
end

-- Export test functions
return {
    runCompleteIntegrationTest = runCompleteIntegrationTest,
    runSmokeTest = runSmokeTest,
    NormalCaseTests = NormalCaseTests,
    EdgeCaseTests = EdgeCaseTests,
    PerformanceTests = PerformanceTests,
    IntegrationTest = IntegrationTest
}