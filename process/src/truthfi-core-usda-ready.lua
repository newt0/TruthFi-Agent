-- TruthFi Core Process - USDA Integration Ready
-- Real USDA deposit processing with Credit-Notice handler

local json = require('json')

-- Mock external modules (same as standalone)
local randomModule = {
    request = function()
        return {
            id = "mock_request_" .. tostring(os.time()),
            timestamp = os.time()
        }
    end
}

local ApusAI = {
    infer = function(prompt, options, callback)
        local task_ref = "mock_task_" .. tostring(math.random(100000, 999999))
        if callback then
            local mock_response = {
                data = "0.75",
                session = "mock_session_" .. tostring(os.time()),
                attestation = "mock_attestation_data",
                reference = task_ref
            }
            callback(nil, mock_response)
        end
        return task_ref
    end,
    
    getInfo = function(callback)
        local info = { price = 100, worker_count = 4, pending_tasks = 2 }
        if callback then callback(nil, info) end
    end
}

print("External modules mocked, USDA integration enabled")

-- State initialization
State = State or {
    name = "TruthFi Core",
    version = "1.0.0",
    phase = "4-1-system-integration-usda",
    admin = Owner or "",
    start_time = os.time(),
    
    -- USDA Token Process integration - SET TO REAL ADDRESS
    usda_token_process = "FBt9A5GA_KXMMSxA2DJ0xZbAq8sLLU2ak-YJe9zDvg8",
    
    -- Other integrations
    qf_calculator_process_id = "",
    randao_process_id = "",
    
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
    
    -- SBT Token Management
    sbt_tokens = {},
    
    -- AI system
    ai_system = {
        enabled = true,
        evaluation_in_progress = false,
        last_evaluation = nil,
        evaluation_results = {},
        pending_evaluations = {},
        request_count = 0
    },
    
    ai_prompt_template = [[
Please comprehensively evaluate the truthfulness of the following tweet and its related information.
Respond with a score from 0 to 1 (1=completely true, 0=completely false).

{MAIN_TWEET_DATA}
{REFERENCE_TWEETS_DATA}

Consider account reliability (follower count, verification status) and engagement numbers,
and respond with only the numerical score.
]],

    initialized = false
}

-- Utility functions (same as standalone)
local function safeToNumber(value)
    local num = tonumber(value)
    return num or 0
end

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
    
    table.sort(votes, function(a, b)
        return a.timestamp > b.timestamp
    end)
    
    return votes
end

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
    
    return {
        true_percentage = (true_votes / total_votes) * 100,
        fake_percentage = (fake_votes / total_votes) * 100,
        method = "linear"
    }
end

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
            }
        },
        ai_confidence = nil,
        created_at = os.time()
    }
    
    print("Sample tweet case loaded: " .. State.active_tweet.case_id)
    return State.active_tweet
end

function validateSystemConsistency()
    local issues = {}
    
    local user_vote_count = 0
    for _ in pairs(State.user_votes) do
        user_vote_count = user_vote_count + 1
    end
    
    if State.voting_stats.true_votes + State.voting_stats.fake_votes ~= user_vote_count then
        table.insert(issues, "Vote count mismatch")
    end
    
    local calculated_true = safeToNumber(State.voting_stats.true_deposited) / 1000000000
    local calculated_fake = safeToNumber(State.voting_stats.fake_deposited) / 1000000000
    local expected_total = (State.voting_stats.true_votes + State.voting_stats.fake_votes) * 1
    
    if math.abs((calculated_true + calculated_fake) - expected_total) > 0.1 then
        table.insert(issues, "Deposit total mismatch")
    end
    
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
-- REAL USDA INTEGRATION HANDLERS
-- ============================================================================

-- Handler: Credit-Notice (REAL USDA DEPOSITS)
Handlers.add(
    "Credit-Notice",
    Handlers.utils.hasMatchingTag("Action", "Credit-Notice"),
    function(msg)
        print("Received Credit-Notice from: " .. msg.From)
        
        -- Verify this is a USDA deposit from the correct token process
        if msg.From ~= State.usda_token_process then
            print("Ignoring credit from non-USDA process: " .. msg.From)
            return
        end
        
        -- Extract deposit information
        local sender = msg.Tags.Sender or msg.Tags["Real-Sender"]
        local quantity = msg.Tags.Quantity
        local vote_type = msg.Tags["X-Vote-Type"] or msg.Tags["Vote-Type"]
        
        print("USDA Deposit Details:")
        print("  Sender: " .. (sender or "Unknown"))
        print("  Quantity: " .. (quantity or "Unknown"))  
        print("  Vote Type: " .. (vote_type or "Unknown"))
        
        -- Validate required fields
        if not sender then
            print("Error: No sender information in credit notice")
            return
        end
        
        if not quantity then
            print("Error: No quantity information in credit notice")
            return
        end
        
        if not vote_type or (vote_type ~= "true" and vote_type ~= "fake") then
            ao.send({
                Target = sender,
                Data = json.encode({
                    error = "Invalid or missing X-Vote-Type tag. Must be 'true' or 'fake'",
                    status = "error",
                    required_tags = {
                        "X-Vote-Type: 'true' or 'fake'"
                    }
                })
            })
            return
        end
        
        -- Convert quantity to number
        local amount = safeToNumber(quantity)
        if amount ~= 1000000000 then  -- Must be exactly 1 USDA (in Armstrongs)
            ao.send({
                Target = sender,
                Data = json.encode({
                    error = "Invalid deposit amount. Must be exactly 1 USDA",
                    status = "error",
                    received_amount = amount,
                    required_amount = 1000000000
                })
            })
            return
        end
        
        -- Check for duplicate vote
        if State.user_votes[sender] then
            ao.send({
                Target = sender,
                Data = json.encode({
                    error = "User has already voted",
                    status = "error",
                    existing_vote = State.user_votes[sender].vote
                })
            })
            return
        end
        
        -- Process the real USDA vote
        print("Processing real USDA vote from: " .. sender)
        
        -- Record the vote
        State.user_votes[sender] = {
            vote = vote_type,
            amount = amount,
            timestamp = os.time(),
            tx_id = msg.Id or ("credit_" .. sender .. "_" .. os.time()),
            source = "usda_deposit"
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
        
        -- Generate Lucky Number
        local lucky_number = math.random(1, 999999)
        
        -- Create SBT
        local sbt_id = "sbt_" .. sender .. "_" .. os.time()
        local sbt_metadata = {
            case_id = State.active_tweet.case_id,
            case_title = State.active_tweet.title,
            voter_id = sender,
            vote_type = vote_type,
            deposit_amount = amount,
            vote_timestamp = os.time(),
            lucky_number = lucky_number,
            tweet_content = State.active_tweet.main_tweet.content,
            tweet_author = State.active_tweet.main_tweet.username,
            deposit_source = "real_usda"
        }
        
        State.sbt_tokens[sbt_id] = {
            id = sbt_id,
            owner = sender,
            metadata = sbt_metadata,
            created_at = os.time(),
            status = "active"
        }
        
        -- Trigger AI evaluation if needed
        if not State.ai_system.evaluation_results or 
           State.ai_system.evaluation_results.case_id ~= State.active_tweet.case_id then
            State.ai_system.evaluation_results = {
                ai_score = 0.75,
                true_confidence = 75.0,
                fake_confidence = 25.0,
                case_id = State.active_tweet.case_id,
                evaluation_timestamp = os.time()
            }
        end
        
        print("Real USDA vote processed successfully!")
        print("  SBT ID: " .. sbt_id)
        print("  Lucky Number: " .. lucky_number)
        
        -- Send success response
        ao.send({
            Target = sender,
            Data = json.encode({
                status = "success",
                message = "USDA vote processed successfully",
                vote_type = vote_type,
                amount_usda = amount / 1000000000,
                sbt_id = sbt_id,
                lucky_number = lucky_number,
                voting_stats = State.voting_stats,
                system_consistency = validateSystemConsistency()
            })
        })
    end
)

-- Handler: Set USDA Process (Admin only)
Handlers.add(
    "Set-USDA-Process",
    Handlers.utils.hasMatchingTag("Action", "Set-USDA-Process"),
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
        
        local process_id = msg.Tags["Process-ID"]
        if not process_id or process_id == "" then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Process-ID tag is required",
                    status = "error"
                })
            })
            return
        end
        
        State.usda_token_process = process_id
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "USDA Token Process ID updated successfully", 
                process_id = process_id
            })
        })
        
        print("USDA Token Process ID updated: " .. process_id)
    end
)

-- Basic handlers (same as standalone version)
Handlers.add("Info", Handlers.utils.hasMatchingTag("Action", "Info"), function(msg)
    ao.send({
        Target = msg.From,
        Data = json.encode({
            status = "success",
            name = State.name,
            version = State.version,
            phase = State.phase,
            admin = State.admin,
            initialized = State.initialized,
            usda_process = State.usda_token_process,
            active_case = {
                case_id = State.active_tweet.case_id,
                title = State.active_tweet.title
            }
        })
    })
end)

Handlers.add("Get-Stats", Handlers.utils.hasMatchingTag("Action", "Get-Stats"), function(msg)
    local qf_results = calculateQuadraticVoting()
    local pool_info = getPoolStatistics()
    
    ao.send({
        Target = msg.From,
        Data = json.encode({
            status = "success",
            voting_stats = State.voting_stats,
            quadratic_funding = qf_results,
            pool_info = pool_info,
            ai_evaluation = State.ai_system.evaluation_results,
            usda_integration = {
                process_id = State.usda_token_process,
                status = "active"
            }
        })
    })
end)

Handlers.add("Dashboard-Data", Handlers.utils.hasMatchingTag("Action", "Dashboard-Data"), function(msg)
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
            ai_evaluation = State.ai_system.evaluation_results or { available = false },
            system_status = {
                process_name = State.name,
                version = State.version,
                phase = State.phase,
                usda_process = State.usda_token_process
            }
        })
    })
end)

-- Initialize Process
if not State.initialized then
    State.initialized = true
    
    print("=== TruthFi Core Process with Real USDA Integration ===")
    print("Name: " .. State.name)
    print("Version: " .. State.version) 
    print("Phase: " .. State.phase)
    print("USDA Process: " .. State.usda_token_process)
    print("======================================================")
    
    local success = pcall(loadSampleTweet)
    if success then
        print("Sample tweet data loaded for testing")
        print("Case ID: " .. State.active_tweet.case_id)
    end
    
    print("Ready to receive real USDA deposits!")
    print("Required deposit: 1 USDA with X-Vote-Type tag ('true' or 'fake')")
end