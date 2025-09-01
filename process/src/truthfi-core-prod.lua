-- TruthFi Core Process - Production Environment
-- Load base functionality
dofile('truthfi-core-standalone.lua')

-- Override settings for production
State.name = "TruthFi Core - Production"
State.phase = "4-1-system-integration-prod"

-- Production-specific configurations
State.ai_system.enabled = true

-- Production security settings
local original_reset_handler = Handlers.utils.hasMatchingTag("Action", "Reset-State")

-- Disable Reset-State handler in production
Handlers.remove("Reset-State")

-- Production initialization
function initializeProductionEnvironment()
    -- Load production tweet case
    State.active_tweet = {
        case_id = "celebrity_marriage_case_production",
        title = "Celebrity Marriage Announcement - Production Case",
        main_tweet = {
            username = "@celebrity_news_official",
            content = "BREAKING: Major celebrity couple announces surprise marriage in intimate ceremony!",
            followers = 1500000,
            verified = true,
            likes = 25000,
            retweets = 8500,
            replies = 3200,
            timestamp = os.time() - 3600
        },
        reference_tweets = {
            {
                username = "@entertainment_reporter",
                content = "Can confirm the marriage announcement is legitimate. Multiple sources verify the ceremony took place.",
                followers = 250000,
                verified = true,
                likes = 1200,
                retweets = 340,
                timestamp = os.time() - 1800
            }
        },
        ai_confidence = nil,
        created_at = os.time()
    }
    
    print("Production environment configured with enhanced security")
end

-- Initialize production environment
initializeProductionEnvironment()

print("=== TruthFi Production Environment Ready ===")
print("Process ID will be: " .. (ao.id or "Generated on startup"))
print("Environment: Production")  
print("Security: Enhanced (Reset-State disabled)")
print("=============================================")