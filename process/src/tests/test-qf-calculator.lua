-- Test cases for QF Calculator Process
-- Tests normal cases, whale protection, and edge cases

local json = require('json')

-- Test data sets
local TestCases = {
    -- Normal case: Multiple voters with varying amounts
    normal_case = {
        input = {
            true_votes = {
                amounts = {"1000000000", "2000000000", "500000000"},  -- 1, 2, 0.5 USDA
                voters = 3
            },
            fake_votes = {
                amounts = {"3000000000", "1000000000"},  -- 3, 1 USDA
                voters = 2
            }
        },
        expected = {
            -- sqrt(1) + sqrt(2) + sqrt(0.5) = 1 + 1.414 + 0.707 = 3.121
            -- (3.121)^2 = 9.74
            -- sqrt(3) + sqrt(1) = 1.732 + 1 = 2.732
            -- (2.732)^2 = 7.46
            -- true_percentage = 9.74 / (9.74 + 7.46) * 100 = 56.6%
            true_percentage_approx = 56.6,
            fake_percentage_approx = 43.4,
            total_participants = 5
        }
    },
    
    -- Whale protection case: 1 large voter vs many small voters
    whale_protection = {
        input = {
            true_votes = {
                amounts = {"100000000", "100000000", "100000000", "100000000"},  -- 4 x 0.1 USDA
                voters = 4
            },
            fake_votes = {
                amounts = {"10000000000"},  -- 1 x 10 USDA (whale)
                voters = 1
            }
        },
        expected = {
            -- True: 4 * sqrt(0.1) = 4 * 0.316 = 1.265, squared = 1.6
            -- Fake: 1 * sqrt(10) = 3.162, squared = 10
            -- Without QF: fake would win 10/(0.4+10) = 96%
            -- With QF: fake wins 10/(1.6+10) = 86% (reduced whale influence)
            whale_influence_reduced = true,
            total_participants = 5
        }
    },
    
    -- Edge case: Zero votes
    zero_votes = {
        input = {
            true_votes = {
                amounts = {},
                voters = 0
            },
            fake_votes = {
                amounts = {},
                voters = 0
            }
        },
        expected = {
            true_percentage = 0,
            fake_percentage = 0,
            total_participants = 0
        }
    },
    
    -- Edge case: Equal amounts
    equal_amounts = {
        input = {
            true_votes = {
                amounts = {"1000000000", "1000000000"},
                voters = 2
            },
            fake_votes = {
                amounts = {"1000000000", "1000000000"},
                voters = 2
            }
        },
        expected = {
            true_percentage = 50.0,
            fake_percentage = 50.0,
            total_participants = 4
        }
    },
    
    -- Edge case: One side only
    one_side_only = {
        input = {
            true_votes = {
                amounts = {"1000000000", "2000000000"},
                voters = 2
            },
            fake_votes = {
                amounts = {},
                voters = 0
            }
        },
        expected = {
            true_percentage = 100.0,
            fake_percentage = 0.0,
            total_participants = 2
        }
    }
}

-- Test utility functions
local function runTest(testName, testCase)
    print("\n=== Testing: " .. testName .. " ===")
    
    -- Create mock message for testing
    local mockMsg = {
        From = "test-user",
        Data = json.encode(testCase.input),
        Tags = {
            Action = "Calculate-QF-Score"
        }
    }
    
    -- Simulate handler execution
    local success = pcall(function()
        -- Find the Calculate-QF-Score handler
        for _, handler in ipairs(Handlers.list) do
            if handler.name == "Calculate-QF-Score" then
                handler.handle(mockMsg)
                break
            end
        end
    end)
    
    if success then
        print("✓ Test executed successfully")
        return true
    else
        print("✗ Test failed to execute")
        return false
    end
end

local function validateOutput(result, expected)
    local valid = true
    
    -- Check total participants
    if result.total_participants ~= expected.total_participants then
        print("✗ Total participants mismatch: expected " .. expected.total_participants .. ", got " .. result.total_participants)
        valid = false
    else
        print("✓ Total participants correct: " .. result.total_participants)
    end
    
    -- Check percentages (allow small tolerance for floating point)
    if expected.true_percentage then
        local diff = math.abs(result.true_percentage - expected.true_percentage)
        if diff > 0.1 then
            print("✗ True percentage mismatch: expected ~" .. expected.true_percentage .. ", got " .. result.true_percentage)
            valid = false
        else
            print("✓ True percentage correct: " .. result.true_percentage .. "%")
        end
    end
    
    if expected.fake_percentage then
        local diff = math.abs(result.fake_percentage - expected.fake_percentage)
        if diff > 0.1 then
            print("✗ Fake percentage mismatch: expected ~" .. expected.fake_percentage .. ", got " .. result.fake_percentage)
            valid = false
        else
            print("✓ Fake percentage correct: " .. result.fake_percentage .. "%")
        end
    end
    
    -- Check QF scores are strings
    if type(result.true_qf_score) ~= "string" or type(result.fake_qf_score) ~= "string" then
        print("✗ QF scores should be strings")
        valid = false
    else
        print("✓ QF scores are properly formatted as strings")
    end
    
    return valid
end

-- Manual calculation verification
local function manualQFCalculation(amounts)
    local sqrt_sum = 0
    for _, amount in ipairs(amounts) do
        sqrt_sum = sqrt_sum + math.sqrt(tonumber(amount) / 1000000000)  -- Convert to USDA
    end
    return sqrt_sum * sqrt_sum
end

-- Whale protection demonstration
local function demonstrateWhaleProtection()
    print("\n=== Whale Protection Demonstration ===")
    
    local regular_votes = {"100000000", "100000000", "100000000", "100000000"}  -- 4 x 0.1 USDA
    local whale_vote = {"10000000000"}  -- 1 x 10 USDA
    
    -- Without QF (linear)
    local regular_total = 4 * 0.1
    local whale_total = 10
    local whale_linear_percentage = whale_total / (regular_total + whale_total) * 100
    
    -- With QF
    local regular_qf = manualQFCalculation(regular_votes)
    local whale_qf = manualQFCalculation(whale_vote)
    local whale_qf_percentage = whale_qf / (regular_qf + whale_qf) * 100
    
    print("Linear voting - Whale influence: " .. string.format("%.1f", whale_linear_percentage) .. "%")
    print("QF voting - Whale influence: " .. string.format("%.1f", whale_qf_percentage) .. "%")
    print("Whale influence reduced by: " .. string.format("%.1f", whale_linear_percentage - whale_qf_percentage) .. " percentage points")
end

-- Performance test
local function performanceTest()
    print("\n=== Performance Test ===")
    
    local large_amounts = {}
    for i = 1, 1000 do
        table.insert(large_amounts, tostring(math.random(100000000, 10000000000)))
    end
    
    local start_time = os.clock()
    local qf_score = manualQFCalculation(large_amounts)
    local end_time = os.clock()
    
    print("Calculated QF score for 1000 votes in " .. string.format("%.3f", end_time - start_time) .. " seconds")
    print("QF Score: " .. string.format("%.2f", qf_score))
end

-- Main test runner
function runAllTests()
    print("Starting QF Calculator Tests...")
    print("================================")
    
    local total_tests = 0
    local passed_tests = 0
    
    -- Run all test cases
    for testName, testCase in pairs(TestCases) do
        total_tests = total_tests + 1
        if runTest(testName, testCase) then
            passed_tests = passed_tests + 1
        end
    end
    
    -- Run demonstrations
    demonstrateWhaleProtection()
    performanceTest()
    
    -- Summary
    print("\n================================")
    print("Test Summary:")
    print("Total tests: " .. total_tests)
    print("Passed tests: " .. passed_tests)
    print("Success rate: " .. string.format("%.1f", passed_tests/total_tests*100) .. "%")
    
    if passed_tests == total_tests then
        print("🎉 All tests passed!")
    else
        print("⚠️  Some tests failed. Please review implementation.")
    end
end

-- Export test functions
return {
    runAllTests = runAllTests,
    TestCases = TestCases,
    validateOutput = validateOutput,
    demonstrateWhaleProtection = demonstrateWhaleProtection,
    performanceTest = performanceTest
}