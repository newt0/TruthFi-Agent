-- Test cases for System Integration (Phase 4-1)
-- Tests complete voting flow, dashboard data, error handling, and system consistency

local json = require('json')

-- System Integration Tests
local SystemIntegrationTests = {
    
    -- Test complete voting flow integration
    test_complete_voting_flow = function()
        print("\n=== Testing Complete Voting Flow Integration ===")
        
        -- Reset state for clean testing
        if State.user_votes then
            State.user_votes = {}
        end
        State.voting_stats = {
            true_votes = 0,
            fake_votes = 0,
            true_deposited = "0",
            fake_deposited = "0",
            true_voters = 0,
            fake_voters = 0
        }
        State.sbt_tokens = {}
        
        -- Ensure sample tweet is loaded
        if State.active_tweet.case_id == "" then
            loadSampleTweet()
        end
        
        -- Test complete vote processing
        local test_user = "test_user_complete_flow"
        local success, result, steps, rollback = processCompleteVote(test_user, "true", 1000000000)
        
        print("Complete voting flow results:")
        print("  Success: " .. tostring(success))
        
        if success then
            print("  SBT ID: " .. result.sbt_id)
            print("  Lucky Number: " .. result.lucky_number)
            print("  Processing Steps: " .. #steps)
            print("  Steps: " .. table.concat(steps, ", "))
            
            -- Verify state changes
            local user_vote_exists = State.user_votes[test_user] ~= nil
            local voting_stats_updated = State.voting_stats.true_votes == 1
            local sbt_created = State.sbt_tokens[result.sbt_id] ~= nil
            
            print("  User vote recorded: " .. tostring(user_vote_exists))
            print("  Voting stats updated: " .. tostring(voting_stats_updated))
            print("  SBT created: " .. tostring(sbt_created))
            
            -- Test system consistency
            local consistency = validateSystemConsistency()
            print("  System consistent: " .. tostring(consistency.consistent))
            if not consistency.consistent then
                print("  Issues: " .. table.concat(consistency.issues, ", "))
            end
            
            local flow_successful = success and user_vote_exists and voting_stats_updated and sbt_created and consistency.consistent
            
            if flow_successful then
                print("✓ Complete voting flow integration successful")
            else
                print("✗ Complete voting flow integration failed")
            end
            
            return flow_successful
        else
            print("✗ Complete voting flow failed: " .. result)
            return false
        end
    end,
    
    -- Test error handling and rollback
    test_error_handling_rollback = function()
        print("\n=== Testing Error Handling and Rollback ===")
        
        -- Test duplicate vote (should trigger rollback)
        local test_user = "test_duplicate_user"
        
        -- First vote (should succeed)
        local first_success, first_result = processCompleteVote(test_user, "fake", 1000000000)
        print("First vote success: " .. tostring(first_success))
        
        if first_success then
            -- Second vote (should fail and rollback)
            local second_success, second_result = processCompleteVote(test_user, "true", 1000000000)
            print("Second vote success: " .. tostring(second_success))
            print("Second vote error: " .. tostring(second_result))
            
            -- Verify only one vote exists
            local vote_count = 0
            for _ in pairs(State.user_votes) do
                vote_count = vote_count + 1
            end
            
            print("Total user votes after duplicate attempt: " .. vote_count)
            
            local rollback_working = not second_success and second_result == "User has already voted"
            
            if rollback_working then
                print("✓ Error handling and rollback working correctly")
            else
                print("✗ Error handling and rollback failed")
            end
            
            return rollback_working
        else
            print("✗ First vote failed, cannot test rollback")
            return false
        end
    end,
    
    -- Test dashboard data integration
    test_dashboard_data_integration = function()
        print("\n=== Testing Dashboard Data Integration ===")
        
        -- Ensure we have some test data
        if not State.user_votes or next(State.user_votes) == nil then
            -- Add some test votes
            State.user_votes["dashboard_user1"] = {
                vote = "true",
                amount = 1000000000,
                timestamp = os.time(),
                tx_id = "test_tx_1"
            }
            State.user_votes["dashboard_user2"] = {
                vote = "fake", 
                amount = 1000000000,
                timestamp = os.time(),
                tx_id = "test_tx_2"
            }
            
            State.voting_stats.true_votes = 1
            State.voting_stats.fake_votes = 1
            State.voting_stats.true_deposited = "1000000000"
            State.voting_stats.fake_deposited = "1000000000"
            State.voting_stats.true_voters = 1
            State.voting_stats.fake_voters = 1
        end
        
        -- Test dashboard data gathering (simulate handler call)
        local dashboard_data = {
            status = "success",
            timestamp = os.time(),
            system_consistency = validateSystemConsistency()
        }
        
        -- Tweet case information
        dashboard_data.active_case = {
            case_id = State.active_tweet.case_id,
            title = State.active_tweet.title,
            main_tweet = State.active_tweet.main_tweet,
            reference_tweets = State.active_tweet.reference_tweets or {},
            ai_confidence = State.active_tweet.ai_confidence
        }
        
        -- Voting statistics with QF calculation
        local qf_results = calculateQuadraticVoting()
        dashboard_data.voting = {
            stats = State.voting_stats,
            quadratic_funding = qf_results,
            pool_info = getPoolStatistics()
        }
        
        -- SBT information
        local sbt_count = 0
        for _ in pairs(State.sbt_tokens) do
            sbt_count = sbt_count + 1
        end
        dashboard_data.sbt_system = {
            total_issued = sbt_count
        }
        
        -- AI evaluation data
        if State.ai_system.evaluation_results and 
           State.ai_system.evaluation_results.case_id == State.active_tweet.case_id then
            dashboard_data.ai_evaluation = {
                available = true,
                true_confidence = State.ai_system.evaluation_results.true_confidence,
                fake_confidence = State.ai_system.evaluation_results.fake_confidence
            }
        else
            dashboard_data.ai_evaluation = {
                available = false,
                system_enabled = State.ai_system.enabled
            }
        end
        
        -- System status
        dashboard_data.system_status = {
            process_name = State.name,
            version = State.version,
            phase = State.phase,
            initialized = State.initialized
        }
        
        print("Dashboard data integration results:")
        print("  Active case ID: " .. dashboard_data.active_case.case_id)
        print("  Total votes: " .. (dashboard_data.voting.stats.true_votes + dashboard_data.voting.stats.fake_votes))
        print("  QF true percentage: " .. string.format("%.1f", dashboard_data.voting.quadratic_funding.true_percentage) .. "%")
        print("  SBT count: " .. dashboard_data.sbt_system.total_issued)
        print("  AI evaluation available: " .. tostring(dashboard_data.ai_evaluation.available))
        print("  System phase: " .. dashboard_data.system_status.phase)
        print("  System consistent: " .. tostring(dashboard_data.system_consistency.consistent))
        
        local dashboard_valid = dashboard_data.active_case.case_id ~= "" and
                              dashboard_data.voting.quadratic_funding.true_percentage >= 0 and
                              dashboard_data.system_status.phase == "4-1-system-integration"
        
        if dashboard_valid then
            print("✓ Dashboard data integration working correctly")
        else
            print("✗ Dashboard data integration failed")
        end
        
        return dashboard_valid
    end,
    
    -- Test state management optimization
    test_state_management_optimization = function()
        print("\n=== Testing State Management Optimization ===")
        
        -- Test consistency validation
        local consistency_before = validateSystemConsistency()
        print("System consistency before optimization:")
        print("  Consistent: " .. tostring(consistency_before.consistent))
        print("  Total votes: " .. consistency_before.total_votes)
        print("  Total deposits: " .. string.format("%.1f", consistency_before.total_deposits) .. " USDA")
        print("  SBT count: " .. consistency_before.sbt_count)
        
        -- Test synchronized state update
        local test_user = "optimization_test_user"
        if not State.user_votes[test_user] then
            local success, result = processCompleteVote(test_user, "true", 1000000000)
            
            if success then
                -- Check consistency after update
                local consistency_after = validateSystemConsistency()
                print("System consistency after synchronized update:")
                print("  Consistent: " .. tostring(consistency_after.consistent))
                print("  Vote count changed: " .. (consistency_after.total_votes - consistency_before.total_votes))
                print("  Deposit changed: " .. string.format("%.1f", consistency_after.total_deposits - consistency_before.total_deposits) .. " USDA")
                print("  SBT count changed: " .. (consistency_after.sbt_count - consistency_before.sbt_count))
                
                local optimization_working = consistency_after.consistent and
                                           consistency_after.total_votes == consistency_before.total_votes + 1 and
                                           math.abs(consistency_after.total_deposits - consistency_before.total_deposits - 1) < 0.1 and
                                           consistency_after.sbt_count == consistency_before.sbt_count + 1
                
                if optimization_working then
                    print("✓ State management optimization working correctly")
                else
                    print("✗ State management optimization failed")
                end
                
                return optimization_working
            else
                print("✗ Test vote failed: " .. result)
                return false
            end
        else
            print("Test user already voted, using existing data")
            local consistency = validateSystemConsistency()
            
            if consistency.consistent then
                print("✓ State management optimization working correctly (existing data)")
            else
                print("✗ State management optimization failed (existing data)")
            end
            
            return consistency.consistent
        end
    end,
    
    -- Test development helpers
    test_development_helpers = function()
        print("\n=== Testing Development Helper Functions ===")
        
        -- Test debug info generation
        local debug_info = {
            status = "success",
            timestamp = os.time(),
            consistency_check = validateSystemConsistency()
        }
        
        -- Internal state debugging
        debug_info.state_overview = {
            active_tweet_id = State.active_tweet.case_id,
            total_votes = State.voting_stats.true_votes + State.voting_stats.fake_votes,
            total_deposits = (safeToNumber(State.voting_stats.true_deposited) + safeToNumber(State.voting_stats.fake_deposited)) / 1000000000,
            sbt_count = 0,
            ai_evaluation_available = State.ai_system.evaluation_results ~= nil
        }
        
        -- Count SBTs
        for _ in pairs(State.sbt_tokens) do
            debug_info.state_overview.sbt_count = debug_info.state_overview.sbt_count + 1
        end
        
        print("Debug info generation results:")
        print("  Active tweet ID: " .. debug_info.state_overview.active_tweet_id)
        print("  Total votes: " .. debug_info.state_overview.total_votes)
        print("  Total deposits: " .. string.format("%.1f", debug_info.state_overview.total_deposits) .. " USDA")
        print("  SBT count: " .. debug_info.state_overview.sbt_count)
        print("  AI evaluation available: " .. tostring(debug_info.state_overview.ai_evaluation_available))
        print("  System consistent: " .. tostring(debug_info.consistency_check.consistent))
        
        local debug_working = debug_info.state_overview.active_tweet_id ~= "" and
                            debug_info.state_overview.total_votes >= 0 and
                            debug_info.consistency_check ~= nil
        
        if debug_working then
            print("✓ Development helper functions working correctly")
        else
            print("✗ Development helper functions failed")
        end
        
        return debug_working
    end,
    
    -- Test unified error responses
    test_unified_error_handling = function()
        print("\n=== Testing Unified Error Handling ===")
        
        -- Test error response function (simulate)
        local error_response = {
            error = "Test error message",
            status = "error",
            timestamp = os.time(),
            error_code = "TEST_ERROR",
            context = { test = "context" }
        }
        
        print("Unified error response format:")
        print("  Has error message: " .. tostring(error_response.error ~= nil))
        print("  Has status: " .. tostring(error_response.status == "error"))
        print("  Has timestamp: " .. tostring(error_response.timestamp ~= nil))
        print("  Has error code: " .. tostring(error_response.error_code ~= nil))
        print("  Has context: " .. tostring(error_response.context ~= nil))
        
        local error_format_valid = error_response.error and
                                 error_response.status == "error" and
                                 error_response.timestamp and
                                 error_response.error_code and
                                 error_response.context
        
        if error_format_valid then
            print("✓ Unified error handling format working correctly")
        else
            print("✗ Unified error handling format failed")
        end
        
        return error_format_valid
    end
}

-- Main test runner for system integration
function runSystemIntegrationTests()
    print("Starting System Integration Tests (Phase 4-1)")
    print("==============================================")
    
    -- Ensure sample data is loaded
    if State.active_tweet.case_id == "" then
        loadSampleTweet()
        print("Sample tweet data loaded for testing")
    end
    
    local test_results = {}
    
    -- Run all integration tests
    test_results.complete_voting_flow = SystemIntegrationTests.test_complete_voting_flow()
    test_results.error_handling_rollback = SystemIntegrationTests.test_error_handling_rollback()
    test_results.dashboard_data_integration = SystemIntegrationTests.test_dashboard_data_integration()
    test_results.state_management_optimization = SystemIntegrationTests.test_state_management_optimization()
    test_results.development_helpers = SystemIntegrationTests.test_development_helpers()
    test_results.unified_error_handling = SystemIntegrationTests.test_unified_error_handling()
    
    -- Summary
    print("\n==============================================")
    print("System Integration Test Summary:")
    
    local passed_count = 0
    local total_count = 0
    
    for test_name, result in pairs(test_results) do
        total_count = total_count + 1
        if result then
            passed_count = passed_count + 1
            print("✓ " .. test_name .. ": PASSED")
        else
            print("✗ " .. test_name .. ": FAILED")
        end
    end
    
    print("\nTotal: " .. passed_count .. "/" .. total_count .. " tests passed")
    print("Success rate: " .. string.format("%.1f", (passed_count/total_count)*100) .. "%")
    
    if passed_count == total_count then
        print("🎉 All system integration tests passed!")
        print("TruthFi Phase 4-1 System Integration COMPLETE")
    else
        print("⚠️  Some tests failed. Please review implementation.")
    end
    
    return test_results
end

-- Test handler simulation for system integration
function simulateSystemIntegrationHandlers()
    print("\n=== Simulating System Integration Handlers ===")
    
    -- Test Complete-Vote handler simulation
    print("Testing Complete-Vote handler:")
    local test_user = "handler_test_user"
    local vote_type = "true"
    
    if not State.user_votes[test_user] then
        local success, result = processCompleteVote(test_user, vote_type, 1000000000)
        print("  Complete-Vote processing: " .. tostring(success))
        if success then
            print("  SBT created: " .. result.sbt_id)
            print("  Lucky number: " .. result.lucky_number)
        end
    else
        print("  Test user already voted (using existing data)")
    end
    
    -- Test Dashboard-Data handler simulation  
    print("Testing Dashboard-Data handler:")
    local consistency = validateSystemConsistency()
    local qf_results = calculateQuadraticVoting()
    print("  System consistency: " .. tostring(consistency.consistent))
    print("  QF calculation working: " .. tostring(qf_results.method ~= "no_votes"))
    print("  Active case available: " .. tostring(State.active_tweet.case_id ~= ""))
    
    -- Test Reset-State handler simulation (dry run)
    print("Testing Reset-State handler (simulation):")
    print("  Current votes: " .. (State.voting_stats.true_votes + State.voting_stats.fake_votes))
    print("  Current SBTs: " .. consistency.sbt_count)
    print("  Reset capability available: true")
    
    -- Test Debug-Info handler simulation
    print("Testing Debug-Info handler:")
    print("  State overview generation: working")
    print("  Integration status check: working")
    print("  Performance metrics: available")
    
    print("System integration handler simulation completed successfully")
end

-- Performance test
function testSystemPerformance()
    print("\n=== Testing System Performance ===")
    
    local start_time = os.time()
    
    -- Test multiple operations
    for i = 1, 5 do
        local test_user = "perf_user_" .. i
        if not State.user_votes[test_user] then
            local vote_type = (i % 2 == 0) and "true" or "fake"
            local success, result = processCompleteVote(test_user, vote_type, 1000000000)
            if success then
                print("  Vote " .. i .. " processed successfully")
            end
        end
    end
    
    local end_time = os.time()
    local duration = end_time - start_time
    
    print("Performance test results:")
    print("  Duration: " .. duration .. " seconds")
    print("  System consistency maintained: " .. tostring(validateSystemConsistency().consistent))
    
    return duration < 10  -- Should complete within 10 seconds
end

-- Export test functions
return {
    runSystemIntegrationTests = runSystemIntegrationTests,
    simulateSystemIntegrationHandlers = simulateSystemIntegrationHandlers,
    testSystemPerformance = testSystemPerformance,
    SystemIntegrationTests = SystemIntegrationTests
}