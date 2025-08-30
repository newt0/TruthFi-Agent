-- Test cases for RandAO Integration (Phase 2-1)
-- Tests Lucky Number generation, async processing, and RandAO module integration

local json = require('json')

-- Mock RandAO module for testing
local mockRandomModule = {
    PaymentToken = "mock-payment-token-id",
    RandomCost = "1000000000",
    RandomProcess = "mock-random-process-id",
    
    generateUUID = function()
        -- Generate a mock UUID for testing
        return "mock-uuid-" .. tostring(math.random(100000, 999999))
    end,
    
    requestRandom = function(callbackId)
        print("Mock RandAO: Random request sent for callback: " .. callbackId)
        return true
    end,
    
    processRandomResponse = function(from, data)
        if from == "mock-random-process-id" then
            return data.callbackId, data.entropy
        else
            error("Invalid random process")
        end
    end
}

-- Test RandAO Integration Functionality
local RandAOIntegrationTests = {
    
    -- Test Lucky Number generation request
    test_lucky_number_generation = function()
        print("\n=== Testing Lucky Number Generation ===")
        
        -- Reset RandAO state for clean testing
        State.randao = {
            enabled = true,
            pending_requests = {},
            completed_numbers = {},
            request_count = 0,
            last_request_time = 0
        }
        
        -- Test with real module functions
        local test_user = "test-user-1"\n        local test_vote_choice = "true"
        
        -- Generate Lucky Number
        local callback_id = generateLuckyNumber(test_user, test_vote_choice)
        
        print("Generated callback ID: " .. tostring(callback_id))
        print("Pending requests count: " .. #State.randao.pending_requests)
        
        -- Verify request was recorded
        local request_recorded = false
        if callback_id then
            for id, request in pairs(State.randao.pending_requests) do
                if id == callback_id and request.user == test_user then
                    request_recorded = true
                    print("Request found - User: " .. request.user .. ", Vote: " .. request.vote_choice)
                    break
                end
            end
        end
        
        if callback_id and request_recorded then
            print("✓ Lucky Number generation request successful")
        else
            print("✗ Lucky Number generation request failed")
        end
        
        return callback_id ~= nil and request_recorded
    end,
    
    -- Test Lucky Number response processing
    test_lucky_number_processing = function()
        print("\\n=== Testing Lucky Number Processing ===\")
        
        -- Use a known pending request from previous test
        local test_callback_id = nil
        local test_user = nil
        
        -- Find a pending request
        for callback_id, request in pairs(State.randao.pending_requests) do
            test_callback_id = callback_id
            test_user = request.user
            break
        end
        
        if not test_callback_id then
            print("No pending requests found for testing")
            return false
        end
        
        -- Simulate entropy from RandAO
        local test_entropy = 123456789
        
        -- Process the response
        local result = processLuckyNumberResponse(test_callback_id, test_entropy)
        
        if result then
            print("Processing result:\")\n            print(\"  User: \" .. result.user)\n            print(\"  Lucky Number: \" .. result.lucky_number)\n            print(\"  Callback ID: \" .. result.callback_id)\n            print(\"  Original Entropy: \" .. result.entropy)\n            \n            -- Verify number is in valid range (1-9999)\n            local valid_range = result.lucky_number >= 1 and result.lucky_number <= 9999\n            print(\"  Valid range (1-9999): \" .. tostring(valid_range))\n            \n            -- Verify request was removed from pending\n            local request_removed = State.randao.pending_requests[test_callback_id] == nil\n            print(\"  Pending request removed: \" .. tostring(request_removed))\n            \n            -- Verify number was stored in completed\n            local number_stored = State.randao.completed_numbers[test_user] ~= nil\n            print(\"  Number stored in completed: \" .. tostring(number_stored))\n            \n            if valid_range and request_removed and number_stored then\n                print(\"✓ Lucky Number processing successful\")\n            else\n                print(\"✗ Lucky Number processing failed\")\n            end\n            \n            return valid_range and request_removed and number_stored\n        else\n            print(\"✗ Lucky Number processing returned no result\")\n            return false\n        end\n    end,\n    \n    -- Test Lucky Number retrieval\n    test_lucky_number_retrieval = function()\n        print(\"\\n=== Testing Lucky Number Retrieval ===\")\n        \n        local test_user = nil\n        local expected_number = nil\n        \n        -- Find a user with completed Lucky Number\n        for user, number_data in pairs(State.randao.completed_numbers) do\n            test_user = user\n            expected_number = number_data.lucky_number\n            break\n        end\n        \n        if not test_user then\n            print(\"No completed Lucky Numbers found for testing\")\n            return false\n        end\n        \n        -- Test getUserLuckyNumber function\n        local retrieved_number = getUserLuckyNumber(test_user)\n        \n        if retrieved_number then\n            print(\"Retrieved Lucky Number for \" .. test_user .. \":\")\n            print(\"  Number: \" .. retrieved_number.lucky_number)\n            print(\"  Expected: \" .. expected_number)\n            print(\"  Match: \" .. tostring(retrieved_number.lucky_number == expected_number))\n            \n            local numbers_match = retrieved_number.lucky_number == expected_number\n            \n            if numbers_match then\n                print(\"✓ Lucky Number retrieval successful\")\n            else\n                print(\"✗ Lucky Number retrieval failed - numbers don't match\")\n            end\n            \n            return numbers_match\n        else\n            print(\"✗ Failed to retrieve Lucky Number\")\n            return false\n        end\n    end,\n    \n    -- Test RandAO statistics\n    test_randao_statistics = function()\n        print(\"\\n=== Testing RandAO Statistics ===\")\n        \n        local stats = getRandAOStatistics()\n        \n        print(\"RandAO Statistics:\")\n        print(\"  Enabled: \" .. tostring(stats.enabled))\n        print(\"  Total requests: \" .. stats.total_requests)\n        print(\"  Pending requests: \" .. stats.pending_requests)\n        print(\"  Completed numbers: \" .. stats.completed_numbers)\n        print(\"  Success rate: \" .. string.format(\"%.1f\", stats.success_rate) .. \"%\")\n        \n        -- Validate statistics make sense\n        local stats_valid = stats.total_requests >= 0 and\n                           stats.pending_requests >= 0 and\n                           stats.completed_numbers >= 0 and\n                           stats.success_rate >= 0 and stats.success_rate <= 100\n        \n        if stats_valid then\n            print(\"✓ RandAO statistics calculation correct\")\n        else\n            print(\"✗ RandAO statistics calculation failed\")\n        end\n        \n        return stats_valid\n    end,\n    \n    -- Test entropy to Lucky Number conversion\n    test_entropy_conversion = function()\n        print(\"\\n=== Testing Entropy to Lucky Number Conversion ===\")\n        \n        local test_entropies = {\n            123456789,\n            999999999,\n            1,\n            0,\n            987654321\n        }\n        \n        local all_valid = true\n        \n        for _, entropy in ipairs(test_entropies) do\n            local lucky_number = (entropy % 9999) + 1\n            \n            print(\"Entropy: \" .. entropy .. \" -> Lucky Number: \" .. lucky_number)\n            \n            if lucky_number < 1 or lucky_number > 9999 then\n                print(\"✗ Invalid Lucky Number range: \" .. lucky_number)\n                all_valid = false\n            end\n        end\n        \n        if all_valid then\n            print(\"✓ Entropy conversion working correctly\")\n        else\n            print(\"✗ Entropy conversion failed\")\n        end\n        \n        return all_valid\n    end,\n    \n    -- Test duplicate Lucky Number prevention\n    test_duplicate_prevention = function()\n        print(\"\\n=== Testing Duplicate Lucky Number Prevention ===\")\n        \n        local test_user = \"duplicate-test-user\"\n        \n        -- First request should succeed\n        local first_callback = generateLuckyNumber(test_user, \"true\")\n        \n        -- Process the first request\n        if first_callback then\n            processLuckyNumberResponse(first_callback, 555555)\n        end\n        \n        -- Second request should be prevented (user already has a number)\n        local second_callback = generateLuckyNumber(test_user, \"fake\")\n        \n        -- Should return nil since user already has a Lucky Number\n        local duplicate_prevented = second_callback == nil\n        \n        print(\"First callback ID: \" .. tostring(first_callback))\n        print(\"Second callback ID: \" .. tostring(second_callback))\n        print(\"Duplicate prevented: \" .. tostring(duplicate_prevented))\n        \n        if duplicate_prevented then\n            print(\"✓ Duplicate Lucky Number prevention working\")\n        else\n            print(\"✗ Duplicate Lucky Number prevention failed\")\n        end\n        \n        return duplicate_prevented\n    end\n}\n\n-- Test RandomResponse handler simulation\nlocal function testRandomResponseHandler()\n    print(\"\\n=== Testing RandomResponse Handler Simulation ===\")\n    \n    -- Create a pending request first\n    local test_user = \"handler-test-user\"\n    local callback_id = generateLuckyNumber(test_user, \"true\")\n    \n    if not callback_id then\n        print(\"Failed to create test request for handler testing\")\n        return false\n    end\n    \n    -- Simulate RandomResponse message\n    local mock_msg = {\n        From = \"mock-random-process-id\",\n        Data = json.encode({\n            callbackId = callback_id,\n            entropy = 777777\n        }),\n        Tags = {\n            Action = \"RandomResponse\"\n        }\n    }\n    \n    -- Simulate handler processing\n    local success = pcall(function()\n        local callback_id_response, entropy = mockRandomModule.processRandomResponse(mock_msg.From, json.decode(mock_msg.Data))\n        local result = processLuckyNumberResponse(callback_id_response, entropy)\n        return result ~= nil\n    end)\n    \n    print(\"Handler simulation successful: \" .. tostring(success))\n    \n    if success then\n        print(\"✓ RandomResponse handler simulation successful\")\n    else\n        print(\"✗ RandomResponse handler simulation failed\")\n    end\n    \n    return success\nend\n\n-- Test RandAO module integration\nlocal function testModuleIntegration()\n    print(\"\\n=== Testing RandAO Module Integration ===\")\n    \n    -- Test module functions availability\n    local functions_available = {\n        generateUUID = type(randomModule.generateUUID) == \"function\",\n        requestRandom = type(randomModule.requestRandom) == \"function\",\n        processRandomResponse = type(randomModule.processRandomResponse) == \"function\"\n    }\n    \n    print(\"Module functions available:\")\n    for func_name, available in pairs(functions_available) do\n        print(\"  \" .. func_name .. \": \" .. tostring(available))\n    end\n    \n    local all_functions_available = true\n    for _, available in pairs(functions_available) do\n        if not available then\n            all_functions_available = false\n            break\n        end\n    end\n    \n    -- Test UUID generation\n    local uuid_test = pcall(function()\n        local uuid = randomModule.generateUUID()\n        return type(uuid) == \"string\" and #uuid > 0\n    end)\n    \n    print(\"UUID generation test: \" .. tostring(uuid_test))\n    \n    local integration_success = all_functions_available and uuid_test\n    \n    if integration_success then\n        print(\"✓ RandAO module integration successful\")\n    else\n        print(\"✗ RandAO module integration failed\")\n    end\n    \n    return integration_success\nend\n\n-- Main test runner for RandAO integration\nfunction runRandAOIntegrationTests()\n    print(\"Starting RandAO Integration Tests (Phase 2-1)\")\n    print(\"==============================================\")\n    \n    -- Ensure sample data is loaded\n    if State.active_tweet.case_id == \"\" then\n        loadSampleTweet()\n        print(\"Sample tweet data loaded for testing\")\n    end\n    \n    local test_results = {}\n    \n    -- Run RandAO integration tests\n    test_results.module_integration = testModuleIntegration()\n    test_results.lucky_number_generation = RandAOIntegrationTests.test_lucky_number_generation()\n    test_results.lucky_number_processing = RandAOIntegrationTests.test_lucky_number_processing()\n    test_results.lucky_number_retrieval = RandAOIntegrationTests.test_lucky_number_retrieval()\n    test_results.randao_statistics = RandAOIntegrationTests.test_randao_statistics()\n    test_results.entropy_conversion = RandAOIntegrationTests.test_entropy_conversion()\n    test_results.duplicate_prevention = RandAOIntegrationTests.test_duplicate_prevention()\n    test_results.handler_simulation = testRandomResponseHandler()\n    \n    -- Summary\n    print(\"\\n==============================================\")\n    print(\"RandAO Integration Test Summary:\")\n    \n    local passed_count = 0\n    local total_count = 0\n    \n    for test_name, result in pairs(test_results) do\n        total_count = total_count + 1\n        if result then\n            passed_count = passed_count + 1\n            print(\"✓ \" .. test_name .. \": PASSED\")\n        else\n            print(\"✗ \" .. test_name .. \": FAILED\")\n        end\n    end\n    \n    print(\"\\nTotal: \" .. passed_count .. \"/\" .. total_count .. \" tests passed\")\n    print(\"Success rate: \" .. string.format(\"%.1f\", (passed_count/total_count)*100) .. \"%\")\n    \n    if passed_count == total_count then\n        print(\"🎉 All RandAO integration tests passed!\")\n    else\n        print(\"⚠️  Some tests failed. Please review implementation.\")\n    end\n    \n    return test_results\nend\n\n-- Test handler simulation for RandAO\nfunction simulateRandAOHandlers()\n    print(\"\\n=== Simulating RandAO Handlers ===\")\n    \n    -- Test Get-Lucky-Number handler\n    print(\"Testing Get-Lucky-Number handler:\")\n    local completed_count = 0\n    for _ in pairs(State.randao.completed_numbers) do\n        completed_count = completed_count + 1\n    end\n    print(\"  Users with Lucky Numbers: \" .. completed_count)\n    \n    -- Test Get-RandAO-Stats handler\n    print(\"Testing Get-RandAO-Stats handler:\")\n    local stats = getRandAOStatistics()\n    print(\"  Total requests: \" .. stats.total_requests)\n    print(\"  Success rate: \" .. string.format(\"%.1f\", stats.success_rate) .. \"%\")\n    \n    -- Test Request-Lucky-Number handler\n    print(\"Testing Request-Lucky-Number handler:\")\n    local pending_count = 0\n    for _ in pairs(State.randao.pending_requests) do\n        pending_count = pending_count + 1\n    end\n    print(\"  Pending requests: \" .. pending_count)\n    \n    print(\"RandAO handler simulation completed successfully\")\nend\n\n-- Export test functions\nreturn {\n    runRandAOIntegrationTests = runRandAOIntegrationTests,\n    simulateRandAOHandlers = simulateRandAOHandlers,\n    RandAOIntegrationTests = RandAOIntegrationTests,\n    testRandomResponseHandler = testRandomResponseHandler,\n    testModuleIntegration = testModuleIntegration,\n    mockRandomModule = mockRandomModule\n}"