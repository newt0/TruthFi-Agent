-- TruthFi Core Process - Standalone Test Version
-- Decentralized fake news voting platform built on AO ecosystem
-- This version includes mocked external dependencies for testing

local json = require('json')

-- Mock RandAO Module Integration
local randomModule = {
    request = function()
        return {
            id = "mock_request_" .. tostring(os.time()),
            timestamp = os.time()
        }
    end
}

-- Mock Apus AI Module Integration
local ApusAI = {
    infer = function(prompt, options, callback)
        local task_ref = "mock_task_" .. tostring(math.random(100000, 999999))
        
        if callback then
            -- Mock AI response
            local mock_response = {
                data = "0.75",  -- 75% confidence
                session = "mock_session_" .. tostring(os.time()),
                attestation = "mock_attestation_data",
                reference = task_ref
            }
            
            -- Simulate callback execution
            callback(nil, mock_response)
        end
        
        return task_ref
    end,
    
    getInfo = function(callback)
        local info = {
            price = 100,
            worker_count = 4,
            pending_tasks = 2
        }
        
        if callback then
            callback(nil, info)
        end
    end
}

print("External modules mocked successfully")

-- ============================================================================
-- GLOBAL STATE INITIALIZATION
-- ============================================================================

State = State or {
    -- Process metadata
    name = "TruthFi Core",
    version = "1.0.0",
    phase = "4-1-system-integration",
    admin = Owner or "",
    start_time = os.time(),
    
    -- QF Calculator Process integration
    qf_calculator_process = "",
    qf_calculator_process_id = "",
    
    -- RandAO Process integration
    randao_process_id = "",
    
    -- USDA Token Process integration
    usda_token_process = "",
    
    -- Tweet case data
    active_tweet = {
        case_id = "",
        title = "",
        main_tweet = {},
        reference_tweets = {}
    },
    
    -- Voting statistics
    voting_stats = {
        true_votes = 0,
        fake_votes = 0,
        true_deposited = "0",
        fake_deposited = "0",
        true_voters = 0,
        fake_voters = 0
    },
    
    -- User voting records
    user_votes = {},
    
    -- Pool and deposit management
    deposits = {},
    deposit_history = {},
    
    -- SBT Token Management
    sbt_tokens = {},
    
    -- RandAO integration state
    randao = {
        enabled = true,
        pending_requests = {},
        completed_requests = {},
        request_count = 0
    },
    
    -- AI evaluation system state
    ai_system = {
        enabled = true,
        evaluation_in_progress = false,
        last_evaluation = nil,
        evaluation_results = {},
        pending_evaluations = {},
        request_count = 0
    },
    
    -- AI evaluation prompt template
    ai_prompt_template = [[
Please comprehensively evaluate the truthfulness of the following tweet and its related information.
Respond with a score from 0 to 1 (1=completely true, 0=completely false).

{MAIN_TWEET_DATA}
{REFERENCE_TWEETS_DATA}

Consider account reliability (follower count, verification status) and engagement numbers,
and respond with only the numerical score.
]],

    -- Initialize flag
    initialized = false
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- Safe number conversion
local function safeToNumber(value)
    local num = tonumber(value)
    return num or 0
end

-- Get user votes list
function getUserVotesList()
    local votes = {}
    for user_id, vote_data in pairs(State.user_votes) do
        table.insert(votes, {
            user_id = user_id,
            vote = vote_data.vote,
            amount = vote_data.amount,
            timestamp = vote_data.timestamp
        })
    end
    
    -- Sort by timestamp (most recent first)
    table.sort(votes, function(a, b)
        return a.timestamp > b.timestamp
    end)
    
    return votes
end

-- Get pool statistics
function getPoolStatistics()
    local true_deposits_usda = safeToNumber(State.voting_stats.true_deposited) / 1000000000
    local fake_deposits_usda = safeToNumber(State.voting_stats.fake_deposited) / 1000000000
    local total_deposits_usda = true_deposits_usda + fake_deposits_usda
    
    return {
        total_deposits_usda = total_deposits_usda,
        true_deposits_usda = true_deposits_usda,
        fake_deposits_usda = fake_deposits_usda,
        total_participants = State.voting_stats.true_voters + State.voting_stats.fake_voters,
        pool_balance = tostring(safeToNumber(State.voting_stats.true_deposited) + safeToNumber(State.voting_stats.fake_deposited))
    }
end

-- Calculate Quadratic Funding voting percentages
function calculateQuadraticVoting()
    local true_votes = State.voting_stats.true_votes
    local fake_votes = State.voting_stats.fake_votes
    local total_votes = true_votes + fake_votes
    
    if total_votes == 0 then
        return {
            true_percentage = 0,
            fake_percentage = 0,
            method = "no_votes"
        }
    end
    
    -- Use square root of vote counts (QF approach)
    local true_sqrt = math.sqrt(true_votes)
    local fake_sqrt = math.sqrt(fake_votes)
    local total_sqrt = true_sqrt + fake_sqrt
    
    if total_sqrt > 0 then
        return {
            true_percentage = (true_sqrt / total_sqrt) * 100,
            fake_percentage = (fake_sqrt / total_sqrt) * 100,
            method = "quadratic"
        }
    end
    
    -- Fallback to linear calculation
    return {
        true_percentage = (true_votes / total_votes) * 100,
        fake_percentage = (fake_votes / total_votes) * 100,
        method = "linear"
    }
end

-- Load sample tweet data
function loadSampleTweet()
    State.active_tweet = {
        case_id = "celebrity_marriage_case_1",
        title = "Celebrity Marriage Announcement Analysis",
        main_tweet = {
            username = "@celebrity_news_official",
            content = "BREAKING: Beloved celebrity couple announces surprise marriage in intimate ceremony!",
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
                content = "Can confirm the marriage announcement is legitimate. Sources close to the couple verify the ceremony took place.",
                followers = 250000,
                verified = true,
                likes = 1200,
                retweets = 340,
                timestamp = os.time() - 1800
            },
            {
                username = "@celebrity_insider",
                content = "Photos from the private ceremony have been shared with close friends and family.",
                followers = 180000,
                verified = false,
                likes = 890,
                retweets = 156,
                timestamp = os.time() - 900
            }
        },
        ai_confidence = nil,
        created_at = os.time()
    }
    
    print("Sample tweet case loaded: " .. State.active_tweet.case_id)
    return State.active_tweet
end

-- Complete vote processing (integrates all features)
function processCompleteVote(user_id, vote_type, amount)
    local processing_steps = {}
    local rollback_actions = {}
    
    -- Step 1: Validate vote
    table.insert(processing_steps, "vote_validation")
    local existing_vote = State.user_votes[user_id]
    if existing_vote then
        return false, "User has already voted", processing_steps
    end
    
    if vote_type ~= "true" and vote_type ~= "fake" then
        return false, "Invalid vote type", processing_steps
    end
    
    if amount ~= 1000000000 then -- 1 USDA in Armstrongs
        return false, "Invalid deposit amount", processing_steps
    end
    
    -- Step 2: Process vote
    table.insert(processing_steps, "vote_processing")
    State.user_votes[user_id] = {
        vote = vote_type,
        amount = amount,
        timestamp = os.time(),
        tx_id = "integrated_vote_" .. user_id .. "_" .. os.time()
    }
    
    -- Update voting statistics
    if vote_type == "true" then
        State.voting_stats.true_votes = State.voting_stats.true_votes + 1
        State.voting_stats.true_deposited = tostring(safeToNumber(State.voting_stats.true_deposited) + amount)
        State.voting_stats.true_voters = State.voting_stats.true_voters + 1
    else
        State.voting_stats.fake_votes = State.voting_stats.fake_votes + 1
        State.voting_stats.fake_deposited = tostring(safeToNumber(State.voting_stats.fake_deposited) + amount)
        State.voting_stats.fake_voters = State.voting_stats.fake_voters + 1
    end
    
    -- Step 3: Generate Lucky Number
    table.insert(processing_steps, "lucky_number_generation")
    local lucky_number = math.random(1, 999999)
    
    -- Step 4: Create SBT
    table.insert(processing_steps, "sbt_creation")
    local sbt_id = "sbt_" .. user_id .. "_" .. os.time()
    local sbt_metadata = {
        case_id = State.active_tweet.case_id,
        case_title = State.active_tweet.title,
        voter_id = user_id,
        vote_type = vote_type,
        deposit_amount = amount,
        vote_timestamp = os.time(),
        lucky_number = lucky_number,
        tweet_content = State.active_tweet.main_tweet.content,
        tweet_author = State.active_tweet.main_tweet.username
    }
    
    State.sbt_tokens[sbt_id] = {
        id = sbt_id,
        owner = user_id,
        metadata = sbt_metadata,
        created_at = os.time(),
        status = "active"
    }
    
    -- Step 5: Mock AI evaluation
    table.insert(processing_steps, "ai_evaluation_check")
    if not State.ai_system.evaluation_results or 
       State.ai_system.evaluation_results.case_id ~= State.active_tweet.case_id then
        -- Mock AI evaluation
        State.ai_system.evaluation_results = {
            ai_score = 0.75,
            true_confidence = 75.0,
            fake_confidence = 25.0,
            case_id = State.active_tweet.case_id,
            evaluation_timestamp = os.time()
        }
    end
    
    return true, {
        sbt_id = sbt_id,
        lucky_number = lucky_number,
        processing_steps = processing_steps,
        vote_stats = State.voting_stats
    }, processing_steps, rollback_actions
end

-- System consistency validation
function validateSystemConsistency()
    local issues = {}
    
    -- Check voting consistency
    local user_vote_count = 0
    for _ in pairs(State.user_votes) do
        user_vote_count = user_vote_count + 1
    end
    
    if State.voting_stats.true_votes + State.voting_stats.fake_votes ~= user_vote_count then
        table.insert(issues, "Vote count mismatch")
    end
    
    -- Check deposit consistency  
    local calculated_true = safeToNumber(State.voting_stats.true_deposited) / 1000000000
    local calculated_fake = safeToNumber(State.voting_stats.fake_deposited) / 1000000000
    local expected_total = (State.voting_stats.true_votes + State.voting_stats.fake_votes) * 1
    
    if math.abs((calculated_true + calculated_fake) - expected_total) > 0.1 then
        table.insert(issues, "Deposit total mismatch")
    end
    
    -- Check SBT consistency
    local sbt_count = 0
    for _ in pairs(State.sbt_tokens) do
        sbt_count = sbt_count + 1
    end
    
    return {
        consistent = #issues == 0,
        issues = issues,
        total_votes = State.voting_stats.true_votes + State.voting_stats.fake_votes,
        total_deposits = calculated_true + calculated_fake,
        sbt_count = sbt_count,
        ai_available = State.ai_system.evaluation_results ~= nil
    }
end

-- ============================================================================
-- BASIC HANDLERS
-- ============================================================================

-- Handler: Info
Handlers.add(
    "Info",
    Handlers.utils.hasMatchingTag("Action", "Info"),
    function(msg)
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                name = State.name,
                version = State.version,
                phase = State.phase,
                admin = State.admin,
                initialized = State.initialized,
                active_case = {
                    case_id = State.active_tweet.case_id,
                    title = State.active_tweet.title
                }
            })
        })
    end
)

-- Handler: Get-Stats
Handlers.add(
    "Get-Stats",
    Handlers.utils.hasMatchingTag("Action", "Get-Stats"),
    function(msg)
        local qf_results = calculateQuadraticVoting()
        local pool_info = getPoolStatistics()
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                voting_stats = State.voting_stats,
                quadratic_funding = qf_results,
                pool_info = pool_info,
                ai_evaluation = State.ai_system.evaluation_results
            })
        })
    end
)

-- Handler: Complete-Vote
Handlers.add(
    "Complete-Vote",
    Handlers.utils.hasMatchingTag("Action", "Complete-Vote"),
    function(msg)
        local vote_type = msg.Tags["Vote-Type"]
        local user_id = msg.From
        
        if not vote_type then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Vote-Type tag is required",
                    status = "error"
                })
            })
            return
        end
        
        local success, result, steps = processCompleteVote(user_id, vote_type, 1000000000)
        
        if success then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    status = "success",
                    message = "Vote processed successfully",
                    result = result,
                    processing_steps = steps,
                    system_consistency = validateSystemConsistency()
                })
            })
        else
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = result,
                    status = "error"
                })
            })
        end
    end
)

-- Handler: Dashboard-Data
Handlers.add(
    "Dashboard-Data",
    Handlers.utils.hasMatchingTag("Action", "Dashboard-Data"),
    function(msg)
        local qf_results = calculateQuadraticVoting()
        local pool_info = getPoolStatistics()
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                timestamp = os.time(),
                system_consistency = validateSystemConsistency(),
                active_case = State.active_tweet,
                voting = {
                    stats = State.voting_stats,
                    quadratic_funding = qf_results,
                    pool_info = pool_info
                },
                ai_evaluation = State.ai_system.evaluation_results or {
                    available = false
                },
                system_status = {
                    process_name = State.name,
                    version = State.version,
                    phase = State.phase
                }
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
    print("========================================")
    
    -- Load sample data by default for testing
    local success = pcall(loadSampleTweet)
    if success then
        print("Sample tweet data loaded for testing")
        print("Case ID: " .. State.active_tweet.case_id)
    else
        print("Warning: Failed to load sample data")
    end
end

print("TruthFi Process ready for testing!")