-- TruthFi Core Process - Development Environment
-- Load base functionality
dofile('truthfi-core-standalone.lua')

-- Override settings for development
State.name = "TruthFi Core - Development"
State.phase = "4-1-system-integration-dev"

-- Development-specific configurations
State.ai_system.enabled = true -- Enable all features for testing
State.randao.enabled = true

-- Load additional test data
function loadDevelopmentData()
    -- Additional test cases for development
    State.active_tweet.case_id = "dev_test_case_1"
    State.active_tweet.title = "Development Test Case"
    print("Development environment configured")
end

-- Initialize development environment
loadDevelopmentData()

print("=== TruthFi Development Environment Ready ===")
print("Process ID will be: " .. (ao.id or "Generated on startup"))
print("Environment: Development")
print("==============================================")