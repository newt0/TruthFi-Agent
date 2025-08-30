-- TruthFi Core Process - Phase 1-1: Basic Structure
-- Decentralized fake news voting platform built on AO ecosystem
-- Manages celebrity marriage news tweet voting with USDA deposits

local json = require('json')

-- RandAO Module Integration
local randomModule = require('@randao/random')(json)

-- ============================================================================
-- GLOBAL STATE INITIALIZATION
-- ============================================================================

State = State or {
    -- Process metadata
    name = "TruthFi Core",
    version = "1.0.0",
    phase = "2-1-randao-integration",
    admin = Owner or "",
    
    -- QF Calculator Process integration
    qf_calculator_process = "",
    
    -- USDA token configuration
    usda_token_process = "",
    required_deposit = "1000000000",  -- 1 USDA in armstrong units
    
    -- Voting configuration
    voting_enabled = true,
    
    -- USDA Pool Management
    pool = {
        total_balance = "0",           -- Total USDA held in process
        true_pool = "0",               -- USDA from true votes
        fake_pool = "0",               -- USDA from fake votes
        deposit_count = 0,              -- Number of deposits received
        last_deposit_time = 0           -- Timestamp of last deposit
    },
    
    -- Deposit history tracking
    deposit_history = {},  -- Array of deposit records
    
    -- RandAO Lucky Number System
    randao = {
        enabled = true,
        pending_requests = {},    -- { [callback_id] = { user: address, timestamp: number, request_type: string } }
        completed_numbers = {},   -- { [user_address] = { lucky_number: number, callback_id: string, timestamp: number } }
        request_count = 0,
        last_request_time = 0
    },
    
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
-- VOTING VALIDATION FUNCTIONS
-- ============================================================================

-- Check if vote amount is exactly 1 USDA
local function isValidVoteAmount(amount)
    return safeToString(amount) == State.required_deposit
end

-- Check if vote choice is valid (true/fake)
local function isValidVoteChoice(choice)
    return choice == "true" or choice == "fake"
end

-- Check if user has already voted
local function hasUserVoted(user_address)
    return State.user_votes[user_address] ~= nil
end

-- Update voting statistics after a vote
local function updateVotingStats(vote_choice, amount, is_new_voter)
    if vote_choice == "true" then
        State.voting_stats.true_votes = State.voting_stats.true_votes + 1
        State.voting_stats.true_deposited = addStringNumbers(State.voting_stats.true_deposited, amount)
        if is_new_voter then
            State.voting_stats.true_voters = State.voting_stats.true_voters + 1
        end
    else  -- fake
        State.voting_stats.fake_votes = State.voting_stats.fake_votes + 1
        State.voting_stats.fake_deposited = addStringNumbers(State.voting_stats.fake_deposited, amount)
        if is_new_voter then
            State.voting_stats.fake_voters = State.voting_stats.fake_voters + 1
        end
    end
    
    State.voting_stats.total_deposits = addStringNumbers(State.voting_stats.total_deposits, amount)
    
    if is_new_voter then
        State.voting_stats.unique_voters = State.voting_stats.unique_voters + 1
    end
end

-- Record user vote
local function recordUserVote(user_address, vote_choice, amount)
    local is_new_voter = not hasUserVoted(user_address)
    
    State.user_votes[user_address] = {
        vote = vote_choice,
        amount = safeToString(amount),
        timestamp = os.time(),
        case_id = State.active_tweet.case_id
    }
    
    updateVotingStats(vote_choice, amount, is_new_voter)
    
    return is_new_voter
end

-- ============================================================================
-- USDA POOL MANAGEMENT FUNCTIONS
-- ============================================================================

-- Update pool balance and history when USDA is received
local function updatePoolBalance(amount, sender, vote_choice, transaction_id)
    local deposit_amount = safeToString(amount)
    
    -- Update total balance
    State.pool.total_balance = addStringNumbers(State.pool.total_balance, deposit_amount)
    
    -- Update vote-specific pools
    if vote_choice == "true" then
        State.pool.true_pool = addStringNumbers(State.pool.true_pool, deposit_amount)
    else  -- fake
        State.pool.fake_pool = addStringNumbers(State.pool.fake_pool, deposit_amount)
    end
    
    -- Update deposit metadata
    State.pool.deposit_count = State.pool.deposit_count + 1
    State.pool.last_deposit_time = os.time()
    
    -- Record deposit in history
    local deposit_record = {
        id = State.pool.deposit_count,
        sender = sender,
        amount = deposit_amount,
        vote_choice = vote_choice,
        timestamp = os.time(),
        case_id = State.active_tweet.case_id,
        transaction_id = transaction_id or ""
    }
    
    table.insert(State.deposit_history, deposit_record)
    
    -- Keep only last 1000 deposits to prevent memory issues
    if #State.deposit_history > 1000 then
        table.remove(State.deposit_history, 1)
    end
    
    print("TruthFi Pool: Updated balance - Total: " .. State.pool.total_balance .. ", True: " .. State.pool.true_pool .. ", Fake: " .. State.pool.fake_pool)
    
    return deposit_record
end

-- Get pool statistics
local function getPoolStatistics()
    local total_balance_num = safeToNumber(State.pool.total_balance)
    local true_pool_num = safeToNumber(State.pool.true_pool)
    local fake_pool_num = safeToNumber(State.pool.fake_pool)
    
    local pool_stats = {
        balances = {
            total = State.pool.total_balance,
            true_pool = State.pool.true_pool,
            fake_pool = State.pool.fake_pool
        },
        metadata = {
            deposit_count = State.pool.deposit_count,
            last_deposit_time = State.pool.last_deposit_time,
            average_deposit = State.pool.deposit_count > 0 and safeToString(total_balance_num / State.pool.deposit_count) or "0"
        },
        percentages = {
            true_percentage = total_balance_num > 0 and (true_pool_num / total_balance_num * 100) or 0,
            fake_percentage = total_balance_num > 0 and (fake_pool_num / total_balance_num * 100) or 0
        },
        voting_consistency = {
            votes_match_deposits = State.voting_stats.total_deposits == State.pool.total_balance
        }
    }
    
    return pool_stats
end

-- Validate deposit consistency with voting
local function validateDepositConsistency()
    local voting_total = State.voting_stats.total_deposits
    local pool_total = State.pool.total_balance
    
    if voting_total ~= pool_total then
        print("WARNING: Deposit inconsistency detected - Voting: " .. voting_total .. ", Pool: " .. pool_total)
        return false
    end
    
    return true
end

-- ============================================================================
-- RANDAO LUCKY NUMBER FUNCTIONS
-- ============================================================================

-- Generate Lucky Number for user after successful vote
local function generateLuckyNumber(user_address, vote_choice)
    if not State.randao.enabled then
        print("RandAO: Lucky Number generation disabled")
        return nil
    end
    
    -- Generate unique callback ID
    local callback_id = randomModule.generateUUID()
    
    -- Record pending request
    State.randao.pending_requests[callback_id] = {
        user = user_address,
        timestamp = os.time(),
        request_type = "lucky_number",
        vote_choice = vote_choice,
        case_id = State.active_tweet.case_id
    }
    
    State.randao.request_count = State.randao.request_count + 1
    State.randao.last_request_time = os.time()
    
    -- Request random number from RandAO
    local success = pcall(function()
        randomModule.requestRandom(callback_id)
    end)
    
    if success then
        print("RandAO: Lucky Number request sent - User: " .. user_address .. ", CallbackID: " .. callback_id)
        return callback_id
    else
        -- Remove failed request
        State.randao.pending_requests[callback_id] = nil
        State.randao.request_count = State.randao.request_count - 1
        print("RandAO: Failed to request Lucky Number for user: " .. user_address)
        return nil
    end
end

-- Process random number response from RandAO
local function processLuckyNumberResponse(callback_id, entropy)
    local request = State.randao.pending_requests[callback_id]
    
    if not request then
        print("RandAO: Received response for unknown callback: " .. callback_id)
        return false
    end
    
    -- Convert entropy to Lucky Number (1-9999 range for SBT)
    local lucky_number = (entropy % 9999) + 1
    
    -- Store completed Lucky Number
    State.randao.completed_numbers[request.user] = {
        lucky_number = lucky_number,
        callback_id = callback_id,
        timestamp = os.time(),
        original_entropy = entropy,
        vote_choice = request.vote_choice,
        case_id = request.case_id
    }
    
    -- Remove from pending requests
    State.randao.pending_requests[callback_id] = nil
    
    print("RandAO: Lucky Number generated - User: " .. request.user .. ", Number: " .. lucky_number)
    
    return {
        user = request.user,
        lucky_number = lucky_number,
        callback_id = callback_id,
        entropy = entropy
    }
end

-- Get Lucky Number for user
local function getUserLuckyNumber(user_address)
    return State.randao.completed_numbers[user_address]
end

-- Get RandAO statistics
local function getRandAOStatistics()
    local pending_count = 0
    for _ in pairs(State.randao.pending_requests) do
        pending_count = pending_count + 1
    end
    
    local completed_count = 0
    for _ in pairs(State.randao.completed_numbers) do
        completed_count = completed_count + 1
    end
    
    return {
        enabled = State.randao.enabled,
        total_requests = State.randao.request_count,
        pending_requests = pending_count,
        completed_numbers = completed_count,
        last_request_time = State.randao.last_request_time,
        success_rate = State.randao.request_count > 0 and (completed_count / State.randao.request_count * 100) or 0
    }
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
            content = "<�Finally got married! Thank you everyone! #MarriageAnnouncement #Happy",
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
-- VOTING SYSTEM HANDLERS
-- ============================================================================

-- Handler: Credit-Notice (USDA deposits for voting)
Handlers.add(
    "Credit-Notice",
    Handlers.utils.hasMatchingTag("Action", "Credit-Notice"),
    function(msg)
        -- Verify this is a USDA deposit
        if msg.From ~= State.usda_token_process and State.usda_token_process ~= "" then
            -- Ignore credits from other tokens
            return
        end
        
        local quantity = msg.Tags.Quantity or "0"
        local sender = msg.Tags.Sender or ""
        local vote_choice = msg.Tags["Vote-Choice"] or ""
        
        -- Validate deposit amount (must be exactly 1 USDA)
        if not isValidVoteAmount(quantity) then
            ao.send({
                Target = sender,
                Data = json.encode({
                    error = "Invalid vote amount. Must deposit exactly 1 USDA (" .. State.required_deposit .. " armstrong)",
                    status = "error",
                    required_amount = State.required_deposit,
                    received_amount = quantity
                })
            })
            return
        end
        
        -- Validate vote choice
        if not isValidVoteChoice(vote_choice) then
            ao.send({
                Target = sender,
                Data = json.encode({
                    error = "Invalid vote choice. Must be 'true' or 'fake'",
                    status = "error",
                    valid_choices = {"true", "fake"},
                    received_choice = vote_choice
                })
            })
            return
        end
        
        -- Check if voting is enabled
        if not State.voting_enabled then
            ao.send({
                Target = sender,
                Data = json.encode({
                    error = "Voting is currently disabled",
                    status = "error"
                })
            })
            return
        end
        
        -- Check if user has already voted
        if hasUserVoted(sender) then
            ao.send({
                Target = sender,
                Data = json.encode({
                    error = "You have already voted on this case. Only one vote per user is allowed.",
                    status = "error",
                    existing_vote = State.user_votes[sender]
                })
            })
            return
        end
        
        -- Check if there's an active tweet case
        if State.active_tweet.case_id == "" then
            ao.send({
                Target = sender,
                Data = json.encode({
                    error = "No active tweet case available for voting",
                    status = "error"
                })
            })
            return
        end
        
        -- Record the vote
        local is_new_voter = recordUserVote(sender, vote_choice, quantity)
        
        -- Update pool balance
        local deposit_record = updatePoolBalance(quantity, sender, vote_choice, msg.Id)
        
        -- Generate Lucky Number via RandAO
        local callback_id = generateLuckyNumber(sender, vote_choice)
        
        -- Send success response
        -- Prepare success response with Lucky Number info
        local response_data = {
            status = "success",
            message = "Vote recorded successfully!",
            vote = {
                choice = vote_choice,
                amount = quantity,
                case_id = State.active_tweet.case_id,
                timestamp = os.time()
            },
            current_stats = State.voting_stats,
            lucky_number = {
                requested = callback_id ~= nil,
                callback_id = callback_id,
                status = callback_id and "pending" or "disabled",
                note = callback_id and "Lucky Number generation in progress via RandAO" or "RandAO Lucky Number generation disabled"
            }
        }
        
        ao.send({
            Target = sender,
            Data = json.encode(response_data)
        })
        
        print("TruthFi: Vote recorded - " .. sender .. " voted " .. vote_choice .. " with " .. quantity .. " armstrong")
    end
)

-- Handler: Submit Vote (Alternative method without automatic USDA transfer)
Handlers.add(
    "Submit-Vote",
    Handlers.utils.hasMatchingTag("Action", "Submit-Vote"),
    function(msg)
        local vote_choice = msg.Tags["Vote-Choice"] or ""
        local amount = msg.Tags["Amount"] or State.required_deposit
        
        -- Validate vote choice
        if not isValidVoteChoice(vote_choice) then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Invalid vote choice. Must be 'true' or 'fake'",
                    status = "error",
                    valid_choices = {"true", "fake"}
                })
            })
            return
        end
        
        -- Check voting enabled
        if not State.voting_enabled then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Voting is currently disabled",
                    status = "error"
                })
            })
            return
        end
        
        -- Check duplicate vote
        if hasUserVoted(msg.From) then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "You have already voted on this case",
                    status = "error",
                    existing_vote = State.user_votes[msg.From]
                })
            })
            return
        end
        
        -- Check active case
        if State.active_tweet.case_id == "" then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "No active tweet case available",
                    status = "error"
                })
            })
            return
        end
        
        -- For this implementation, we'll require USDA transfer via Credit-Notice
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "pending",
                message = "Please send exactly 1 USDA to this process with Vote-Choice tag to complete your vote",
                instructions = {
                    required_amount = State.required_deposit,
                    required_tag = "Vote-Choice: " .. vote_choice,
                    usda_process = State.usda_token_process or "TBD"
                }
            })
        })
    end
)

-- ============================================================================
-- VOTE RESULT RETRIEVAL HANDLERS
-- ============================================================================

-- Handler: Get User Vote Status
Handlers.add(
    "Get-User-Vote",
    Handlers.utils.hasMatchingTag("Action", "Get-User-Vote"),
    function(msg)
        local user_address = msg.Tags["User"] or msg.From
        local user_vote = State.user_votes[user_address]
        
        if not user_vote then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    status = "success",
                    has_voted = false,
                    message = "User has not voted on the current case",
                    user_address = user_address,
                    active_case_id = State.active_tweet.case_id
                })
            })
            return
        end
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                has_voted = true,
                vote = user_vote,
                user_address = user_address
            })
        })
    end
)

-- Handler: Get Overall Voting Results
Handlers.add(
    "Get-Voting-Results",
    Handlers.utils.hasMatchingTag("Action", "Get-Voting-Results"),
    function(msg)
        local include_qf = msg.Tags["Include-QF"] == "true"
        local result = {
            status = "success",
            case_id = State.active_tweet.case_id,
            case_title = State.active_tweet.title,
            voting_stats = State.voting_stats,
            voting_enabled = State.voting_enabled,
            required_deposit = State.required_deposit
        }
        
        -- Calculate basic percentages
        local total_votes = State.voting_stats.true_votes + State.voting_stats.fake_votes
        if total_votes > 0 then
            result.percentages = {
                true_percentage = math.floor((State.voting_stats.true_votes / total_votes) * 1000 + 0.5) / 10,
                fake_percentage = math.floor((State.voting_stats.fake_votes / total_votes) * 1000 + 0.5) / 10
            }
        else
            result.percentages = {
                true_percentage = 0,
                fake_percentage = 0
            }
        end
        
        -- Include QF calculation if requested and QF Calculator is available
        if include_qf and State.qf_calculator_process ~= "" then
            -- Prepare vote data for QF calculation
            local qf_vote_data = {
                true_votes = {
                    amounts = {},
                    voters = State.voting_stats.true_voters
                },
                fake_votes = {
                    amounts = {},
                    voters = State.voting_stats.fake_voters
                }
            }
            
            -- Collect vote amounts (simplified - each vote is 1 USDA)
            for i = 1, State.voting_stats.true_voters do
                table.insert(qf_vote_data.true_votes.amounts, State.required_deposit)
            end
            
            for i = 1, State.voting_stats.fake_voters do
                table.insert(qf_vote_data.fake_votes.amounts, State.required_deposit)
            end
            
            result.qf_data = qf_vote_data
            result.qf_calculator_process = State.qf_calculator_process
            result.note = "Use qf_data to call QF Calculator Process for quadratic funding percentages"
        end
        
        ao.send({
            Target = msg.From,
            Data = json.encode(result)
        })
    end
)

-- Handler: Set USDA Token Process (Admin only)
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
        
        State.usda_token_process = process_id
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "USDA Token Process ID updated successfully",
                process_id = process_id
            })
        })
    end
)

-- Handler: Toggle Voting (Admin only)
Handlers.add(
    "Toggle-Voting",
    Handlers.utils.hasMatchingTag("Action", "Toggle-Voting"),
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
        
        State.voting_enabled = not State.voting_enabled
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "Voting " .. (State.voting_enabled and "enabled" or "disabled"),
                voting_enabled = State.voting_enabled
            })
        })
    end
)

-- ============================================================================
-- RANDAO HANDLERS
-- ============================================================================

-- Handler: RandomResponse (Process random number from RandAO)
Handlers.add(
    "RandomResponse",
    Handlers.utils.hasMatchingTag("Action", "RandomResponse"),
    function(msg)
        local success, callback_id, entropy = pcall(function()
            return randomModule.processRandomResponse(msg.From, json.decode(msg.Data))
        end)
        
        if not success then
            print("RandAO: Failed to process random response - " .. tostring(callback_id))
            return
        end
        
        -- Process the Lucky Number
        local result = processLuckyNumberResponse(callback_id, entropy)
        
        if result then
            -- Notify user about their Lucky Number
            ao.send({
                Target = result.user,
                Data = json.encode({
                    status = "success",
                    action = "lucky_number_generated",
                    lucky_number = {
                        number = result.lucky_number,
                        callback_id = result.callback_id,
                        entropy = result.entropy,
                        case_id = State.active_tweet.case_id
                    },
                    message = "Your Lucky Number has been generated: " .. result.lucky_number,
                    next_steps = "Your SBT will be issued with this Lucky Number"
                })
            })
            
            print("RandAO: Lucky Number notification sent to " .. result.user)
        end
    end
)

-- Handler: Get Lucky Number Status
Handlers.add(
    "Get-Lucky-Number",
    Handlers.utils.hasMatchingTag("Action", "Get-Lucky-Number"),
    function(msg)
        local user_address = msg.Tags["User"] or msg.From
        local lucky_number = getUserLuckyNumber(user_address)
        
        if lucky_number then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    status = "success",
                    user_address = user_address,
                    lucky_number = lucky_number,
                    has_lucky_number = true
                })
            })
        else
            -- Check if there's a pending request
            local pending_request = nil
            for callback_id, request in pairs(State.randao.pending_requests) do
                if request.user == user_address then
                    pending_request = {
                        callback_id = callback_id,
                        timestamp = request.timestamp,
                        request_type = request.request_type
                    }
                    break
                end
            end
            
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    status = "success",
                    user_address = user_address,
                    has_lucky_number = false,
                    pending_request = pending_request,
                    message = pending_request and "Lucky Number generation in progress" or "No Lucky Number found for this user"
                })
            })
        end
    end
)

-- Handler: Get RandAO Statistics
Handlers.add(
    "Get-RandAO-Stats",
    Handlers.utils.hasMatchingTag("Action", "Get-RandAO-Stats"),
    function(msg)
        local randao_stats = getRandAOStatistics()
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                randao_statistics = randao_stats,
                module_info = {
                    payment_token = randomModule.PaymentToken or "N/A",
                    random_cost = randomModule.RandomCost or "N/A",
                    random_process = randomModule.RandomProcess or "N/A"
                }
            })
        })
    end
)

-- Handler: Toggle RandAO (Admin only)
Handlers.add(
    "Toggle-RandAO",
    Handlers.utils.hasMatchingTag("Action", "Toggle-RandAO"),
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
        
        State.randao.enabled = not State.randao.enabled
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "RandAO Lucky Number generation " .. (State.randao.enabled and "enabled" or "disabled"),
                randao_enabled = State.randao.enabled
            })
        })
    end
)

-- Handler: Manual Lucky Number Request (for testing)
Handlers.add(
    "Request-Lucky-Number",
    Handlers.utils.hasMatchingTag("Action", "Request-Lucky-Number"),
    function(msg)
        -- Check if user has voted
        if not State.user_votes[msg.From] then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "You must vote first to request a Lucky Number",
                    status = "error"
                })
            })
            return
        end
        
        -- Check if user already has a Lucky Number
        if getUserLuckyNumber(msg.From) then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "You already have a Lucky Number",
                    status = "error",
                    existing_number = getUserLuckyNumber(msg.From)
                })
            })
            return
        end
        
        -- Check for pending request
        for callback_id, request in pairs(State.randao.pending_requests) do
            if request.user == msg.From then
                ao.send({
                    Target = msg.From,
                    Data = json.encode({
                        error = "Lucky Number request already pending",
                        status = "error",
                        callback_id = callback_id
                    })
                })
                return
            end
        end
        
        local user_vote = State.user_votes[msg.From]
        local callback_id = generateLuckyNumber(msg.From, user_vote.vote)
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "Lucky Number request submitted",
                callback_id = callback_id,
                note = "You will receive your Lucky Number shortly"
            })
        })
    end
)

-- ============================================================================
-- POOL MANAGEMENT HANDLERS
-- ============================================================================

-- Handler: Get Pool Information
Handlers.add(
    "Get-Pool-Info",
    Handlers.utils.hasMatchingTag("Action", "Get-Pool-Info"),
    function(msg)
        local pool_stats = getPoolStatistics()
        local consistency_check = validateDepositConsistency()
        
        local pool_info = {
            status = "success",
            pool_statistics = pool_stats,
            consistency_status = {
                is_consistent = consistency_check,
                last_check_time = os.time()
            },
            case_info = {
                active_case_id = State.active_tweet.case_id,
                case_title = State.active_tweet.title
            },
            liquidops_ready = false,  -- For future implementation
            metadata = {
                total_deposits_processed = State.pool.deposit_count,
                pool_creation_time = State.pool.last_deposit_time > 0 and (State.pool.last_deposit_time - State.pool.deposit_count) or 0
            }
        }
        
        ao.send({
            Target = msg.From,
            Data = json.encode(pool_info)
        })
    end
)

-- Handler: Get Deposit History
Handlers.add(
    "Get-Deposit-History",
    Handlers.utils.hasMatchingTag("Action", "Get-Deposit-History"),
    function(msg)
        local limit = tonumber(msg.Tags["Limit"]) or 50  -- Default limit
        local offset = tonumber(msg.Tags["Offset"]) or 0  -- Default offset
        local filter_choice = msg.Tags["Vote-Choice"]  -- Optional filter
        local filter_sender = msg.Tags["Sender"]  -- Optional filter
        
        -- Apply filters
        local filtered_history = {}
        for _, deposit in ipairs(State.deposit_history) do
            local include = true
            
            if filter_choice and deposit.vote_choice ~= filter_choice then
                include = false
            end
            
            if filter_sender and deposit.sender ~= filter_sender then
                include = false
            end
            
            if include then
                table.insert(filtered_history, deposit)
            end
        end
        
        -- Apply pagination
        local paginated_history = {}
        local start_idx = offset + 1
        local end_idx = math.min(start_idx + limit - 1, #filtered_history)
        
        for i = start_idx, end_idx do
            table.insert(paginated_history, filtered_history[i])
        end
        
        local history_info = {
            status = "success",
            deposits = paginated_history,
            pagination = {
                total_records = #filtered_history,
                offset = offset,
                limit = limit,
                returned_count = #paginated_history
            },
            filters_applied = {
                vote_choice = filter_choice,
                sender = filter_sender
            },
            summary = {
                total_all_deposits = #State.deposit_history,
                total_filtered = #filtered_history
            }
        }
        
        ao.send({
            Target = msg.From,
            Data = json.encode(history_info)
        })
    end
)

-- Handler: Pool Consistency Check (Admin only)
Handlers.add(
    "Pool-Consistency-Check",
    Handlers.utils.hasMatchingTag("Action", "Pool-Consistency-Check"),
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
        
        local consistency_check = validateDepositConsistency()
        local detailed_analysis = {
            voting_stats = State.voting_stats,
            pool_stats = State.pool,
            discrepancies = {}
        }
        
        -- Check for discrepancies
        if State.voting_stats.total_deposits ~= State.pool.total_balance then
            table.insert(detailed_analysis.discrepancies, {
                type = "total_balance_mismatch",
                voting_total = State.voting_stats.total_deposits,
                pool_total = State.pool.total_balance,
                difference = addStringNumbers(State.voting_stats.total_deposits, "-" .. State.pool.total_balance)
            })
        end
        
        if State.voting_stats.true_deposited ~= State.pool.true_pool then
            table.insert(detailed_analysis.discrepancies, {
                type = "true_pool_mismatch",
                voting_true = State.voting_stats.true_deposited,
                pool_true = State.pool.true_pool
            })
        end
        
        if State.voting_stats.fake_deposited ~= State.pool.fake_pool then
            table.insert(detailed_analysis.discrepancies, {
                type = "fake_pool_mismatch",
                voting_fake = State.voting_stats.fake_deposited,
                pool_fake = State.pool.fake_pool
            })
        end
        
        local consistency_report = {
            status = "success",
            is_consistent = consistency_check,
            analysis = detailed_analysis,
            recommendations = #detailed_analysis.discrepancies > 0 and {
                "Review deposit processing logic",
                "Check for missed or duplicate transactions",
                "Verify voting statistics calculation"
            } or {"Pool is consistent with voting statistics"},
            check_timestamp = os.time()
        }
        
        ao.send({
            Target = msg.From,
            Data = json.encode(consistency_report)
        })
    end
)

-- Handler: Reset Pool (Admin only - for testing)
Handlers.add(
    "Reset-Pool",
    Handlers.utils.hasMatchingTag("Action", "Reset-Pool"),
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
        
        -- Reset pool data
        State.pool = {
            total_balance = "0",
            true_pool = "0",
            fake_pool = "0",
            deposit_count = 0,
            last_deposit_time = 0
        }
        
        -- Clear deposit history
        State.deposit_history = {}
        
        -- Also reset voting stats to maintain consistency
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
        
        -- Clear user votes
        State.user_votes = {}
        
        print("TruthFi: Pool and voting data reset by admin")
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "Pool and voting data reset successfully",
                timestamp = os.time()
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