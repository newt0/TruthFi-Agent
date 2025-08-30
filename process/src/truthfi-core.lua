-- TruthFi Core Process - Phase 1-1: Basic Structure
-- Decentralized fake news voting platform built on AO ecosystem
-- Manages celebrity marriage news tweet voting with USDA deposits

local json = require('json')

-- ============================================================================
-- GLOBAL STATE INITIALIZATION
-- ============================================================================

State = State or {
    -- Process metadata
    name = "TruthFi Core",
    version = "1.0.0",
    phase = "1-1-basic-structure",
    admin = Owner or "",
    
    -- QF Calculator Process integration
    qf_calculator_process = "",
    
    -- Active tweet case being voted on
    active_tweet = {
        case_id = "",
        title = "",
        main_tweet = {
            tweet_id = "",
            content = "",
            username = "",
            posted_at = "",
            likes = 0,
            retweets = 0,
            followers = 0,
            verified = false
        },
        reference_tweets = {
            -- Array: objects with same schema as main_tweet
        },
        ai_confidence = 0.0
    },
    
    -- Voting statistics
    voting_stats = {
        true_votes = 0,
        fake_votes = 0,
        true_deposited = "0",
        fake_deposited = "0",
        true_voters = 0,
        fake_voters = 0,
        total_deposits = "0",
        unique_voters = 0
    },
    
    -- User vote tracking
    user_votes = {},  -- Format: { [user_address] = { vote: "true"/"fake", amount: "1000000000", timestamp: number } }
    
    -- SBT token tracking (for Phase 2)
    sbt_tokens = {},  -- Format: { [user_address] = { token_id: "", lucky_number: number, metadata: {} } }
    
    -- AI evaluation prompt template (for Phase 3)
    ai_prompt_template = ""
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- Safe number conversion for large integers (USDA amounts)
local function safeToNumber(value)
    if type(value) == "number" then
        return value
    elseif type(value) == "string" then
        return tonumber(value) or 0
    else
        return 0
    end
end

-- Safe string conversion for large integers
local function safeToString(value)
    if type(value) == "string" then
        return value
    elseif type(value) == "number" then
        return tostring(value)
    else
        return "0"
    end
end

-- Add two string numbers (for large integer arithmetic)
local function addStringNumbers(a, b)
    local numA = safeToNumber(a)
    local numB = safeToNumber(b)
    return safeToString(numA + numB)
end

-- ============================================================================
-- INITIALIZATION FUNCTIONS
-- ============================================================================

-- Tweet data configuration function
function initializeTweetCase(tweet_data)
    assert(tweet_data, "Tweet data is required")
    assert(tweet_data.case_id, "Case ID is required")
    assert(tweet_data.title, "Title is required")
    assert(tweet_data.main_tweet, "Main tweet data is required")
    
    State.active_tweet = tweet_data
    
    -- Reset voting stats when new case is loaded
    State.voting_stats = {
        true_votes = 0,
        fake_votes = 0,
        true_deposited = "0",
        fake_deposited = "0",
        true_voters = 0,
        fake_voters = 0,
        total_deposits = "0",
        unique_voters = 0
    }
    
    -- Clear previous votes and SBT tokens
    State.user_votes = {}
    State.sbt_tokens = {}
    
    print("TruthFi: New tweet case initialized - " .. tweet_data.case_id)
end

-- Sample data configuration (for testing)
function loadSampleTweet()
    local sample_data = {
        case_id = "celebrity_marriage_tweet_001",
        title = "Celebrity A and B Marriage Announcement Tweet Fact-Check Vote",
        main_tweet = {
            tweet_id = "1735123456789012345",
            content = "<‰Finally got married! Thank you everyone! #MarriageAnnouncement #Happy",
            username = "celebrity_a_official",
            posted_at = "2024-12-15T10:30:00Z",
            likes = 15420,
            retweets = 3280,
            followers = 2500000,
            verified = true
        },
        reference_tweets = {
            {
                tweet_id = "1735124567890123456",
                content = "Congratulations! What a lovely couple (",
                username = "friend_b_public",
                posted_at = "2024-12-15T11:00:00Z",
                likes = 892,
                retweets = 156,
                followers = 85000,
                verified = false
            },
            {
                tweet_id = "1735125678901234567",
                content = "Wait, is this for real? I can't believe it... really?",
                username = "fan_account_c",
                posted_at = "2024-12-15T11:15:00Z",
                likes = 445,
                retweets = 67,
                followers = 1200,
                verified = false
            }
        },
        ai_confidence = 0.0
    }
    
    initializeTweetCase(sample_data)
    print("TruthFi: Sample tweet data loaded successfully")
end

-- ============================================================================
-- HANDLER IMPLEMENTATIONS
-- ============================================================================

-- Handler: Get Process Information
Handlers.add(
    "Info",
    Handlers.utils.hasMatchingTag("Action", "Info"),
    function(msg)
        local info = {
            name = State.name,
            version = State.version,
            phase = State.phase,
            admin = State.admin,
            qf_calculator_process = State.qf_calculator_process,
            active_case_id = State.active_tweet.case_id,
            features = {
                "tweet_case_management",
                "voting_statistics",
                "qf_calculator_integration",
                "sample_data_loading"
            },
            description = "TruthFi Core Process for decentralized fake news voting on AO ecosystem",
            handlers = {
                "Info",
                "Get-Tweet-Case", 
                "Get-Stats",
                "Set-Tweet-Case",
                "Set-QF-Process",
                "Load-Sample"
            }
        }
        
        ao.send({
            Target = msg.From,
            Data = json.encode(info)
        })
    end
)

-- Handler: Get Current Tweet Case
Handlers.add(
    "Get-Tweet-Case",
    Handlers.utils.hasMatchingTag("Action", "Get-Tweet-Case"),
    function(msg)
        if State.active_tweet.case_id == "" then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "No active tweet case loaded",
                    status = "error",
                    suggestion = "Use Load-Sample action to load sample data"
                })
            })
            return
        end
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                tweet_case = State.active_tweet
            })
        })
    end
)

-- Handler: Get Voting Statistics (with QF Calculator integration)
Handlers.add(
    "Get-Stats",
    Handlers.utils.hasMatchingTag("Action", "Get-Stats"),
    function(msg)
        local stats = {
            basic_stats = State.voting_stats,
            qf_calculator_process = State.qf_calculator_process,
            active_case_id = State.active_tweet.case_id
        }
        
        -- If QF Calculator Process is set, include QF calculation capability info
        if State.qf_calculator_process ~= "" then
            stats.qf_integration = {
                enabled = true,
                calculator_process = State.qf_calculator_process,
                note = "QF calculations available via integrated calculator process"
            }
        else
            stats.qf_integration = {
                enabled = false,
                note = "Set QF Calculator Process ID to enable quadratic funding calculations"
            }
        end
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                statistics = stats
            })
        })
    end
)

-- Handler: Set Tweet Case (Admin only)
Handlers.add(
    "Set-Tweet-Case",
    Handlers.utils.hasMatchingTag("Action", "Set-Tweet-Case"),
    function(msg)
        if msg.From ~= State.admin then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Unauthorized: Admin access required",
                    status = "error"
                })
            })
            return
        end
        
        local success, tweet_data = pcall(json.decode, msg.Data)
        
        if not success or not tweet_data then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Invalid JSON tweet data provided",
                    status = "error"
                })
            })
            return
        end
        
        local init_success, error_msg = pcall(initializeTweetCase, tweet_data)
        
        if not init_success then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Tweet case initialization failed: " .. tostring(error_msg),
                    status = "error"
                })
            })
            return
        end
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "Tweet case updated successfully",
                case_id = State.active_tweet.case_id
            })
        })
    end
)

-- Handler: Set QF Calculator Process ID
Handlers.add(
    "Set-QF-Process",
    Handlers.utils.hasMatchingTag("Action", "Set-QF-Process"),
    function(msg)
        if msg.From ~= State.admin then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Unauthorized: Admin access required",
                    status = "error"
                })
            })
            return
        end
        
        local process_id = msg.Tags["Process-ID"] or ""
        
        if process_id == "" then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Process-ID tag is required",
                    status = "error"
                })
            })
            return
        end
        
        State.qf_calculator_process = process_id
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "QF Calculator Process ID updated successfully",
                process_id = process_id
            })
        })
    end
)

-- Handler: Load Sample Tweet Data
Handlers.add(
    "Load-Sample",
    Handlers.utils.hasMatchingTag("Action", "Load-Sample"),
    function(msg)
        local success, error_msg = pcall(loadSampleTweet)
        
        if not success then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Failed to load sample data: " .. tostring(error_msg),
                    status = "error"
                })
            })
            return
        end
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "Sample tweet data loaded successfully",
                case_id = State.active_tweet.case_id,
                title = State.active_tweet.title
            })
        })
    end
)

-- ============================================================================
-- PROCESS INITIALIZATION
-- ============================================================================

-- Initialize Process on first load
if not State.initialized then
    State.initialized = true
    
    print("=== TruthFi Core Process Initialized ===")
    print("Name: " .. State.name)
    print("Version: " .. State.version)
    print("Phase: " .. State.phase)
    print("Admin: " .. State.admin)
    print("========================================")
    
    -- Load sample data by default for testing
    local success = pcall(loadSampleTweet)
    if success then
        print("Sample tweet data loaded for testing")
    else
        print("Warning: Failed to load sample data")
    end
end