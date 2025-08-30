-- QF Calculator Process for TruthFi
-- Implements Gitcoin Quadratic Funding algorithm for democratic voting
-- Built for AO ecosystem

local json = require('json')

-- Initialize global state
State = State or {
    version = "1.0.0",
    algorithm = "quadratic_funding",
    calculations = {},  -- calculation history
    admin = Owner or ""  -- Process owner as admin
}

-- Math utility functions
local function safeSqrt(value)
    local num = tonumber(value)
    if not num or num < 0 then
        return 0
    end
    return math.sqrt(num)
end

local function safeSquare(value)
    local num = tonumber(value)
    if not num then
        return 0
    end
    return num * num
end

-- Core Quadratic Funding calculation function
local function calculateQuadraticFunding(votes_data)
    assert(votes_data, "votes_data is required")
    assert(votes_data.true_votes, "true_votes is required")
    assert(votes_data.fake_votes, "fake_votes is required")
    
    local true_votes = votes_data.true_votes
    local fake_votes = votes_data.fake_votes
    
    -- Validate input structure
    if not true_votes.amounts then true_votes.amounts = {} end
    if not fake_votes.amounts then fake_votes.amounts = {} end
    if not true_votes.voters then true_votes.voters = #true_votes.amounts end
    if not fake_votes.voters then fake_votes.voters = #fake_votes.amounts end
    
    -- Calculate QF scores using sum of square roots
    local true_sqrt_sum = 0
    local fake_sqrt_sum = 0
    
    -- Process true votes
    for _, amount in ipairs(true_votes.amounts) do
        true_sqrt_sum = true_sqrt_sum + safeSqrt(amount)
    end
    
    -- Process fake votes
    for _, amount in ipairs(fake_votes.amounts) do
        fake_sqrt_sum = fake_sqrt_sum + safeSqrt(amount)
    end
    
    -- Square the sums for final QF scores
    local true_qf_score = safeSquare(true_sqrt_sum)
    local fake_qf_score = safeSquare(fake_sqrt_sum)
    local total_score = true_qf_score + fake_qf_score
    
    -- Calculate percentages
    local true_percentage = 0
    local fake_percentage = 0
    
    if total_score > 0 then
        true_percentage = (true_qf_score / total_score) * 100
        fake_percentage = (fake_qf_score / total_score) * 100
    end
    
    -- Calculate total participants
    local total_participants = true_votes.voters + fake_votes.voters
    
    -- Create result
    local result = {
        true_percentage = math.floor(true_percentage * 10 + 0.5) / 10,  -- Round to 1 decimal
        fake_percentage = math.floor(fake_percentage * 10 + 0.5) / 10,  -- Round to 1 decimal
        true_qf_score = tostring(math.floor(true_qf_score + 0.5)),  -- Round and convert to string
        fake_qf_score = tostring(math.floor(fake_qf_score + 0.5)),  -- Round and convert to string
        total_participants = total_participants,
        algorithm = State.algorithm,
        timestamp = os.time()
    }
    
    -- Store calculation in history
    table.insert(State.calculations, {
        input = votes_data,
        output = result,
        timestamp = os.time()
    })
    
    return result
end

-- Handler: Calculate QF Score
Handlers.add(
    "Calculate-QF-Score",
    Handlers.utils.hasMatchingTag("Action", "Calculate-QF-Score"),
    function(msg)
        local success, votes_data = pcall(json.decode, msg.Data)
        
        if not success or not votes_data then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Invalid JSON data provided",
                    status = "error"
                })
            })
            return
        end
        
        local calc_success, result = pcall(calculateQuadraticFunding, votes_data)
        
        if not calc_success then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "QF calculation failed: " .. tostring(result),
                    status = "error"
                })
            })
            return
        end
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                result = result
            })
        })
    end
)

-- Handler: Get QF Info
Handlers.add(
    "Get-QF-Info",
    Handlers.utils.hasMatchingTag("Action", "Get-QF-Info"),
    function(msg)
        local info = {
            version = State.version,
            algorithm = State.algorithm,
            total_calculations = #State.calculations,
            features = {
                "whale_protection",
                "democratic_scoring",
                "transparency"
            },
            description = "Quadratic Funding calculator implementing Gitcoin algorithm for democratic vote weighting"
        }
        
        ao.send({
            Target = msg.From,
            Data = json.encode(info)
        })
    end
)

-- Handler: Set Algorithm (Admin only)
Handlers.add(
    "Set-Algorithm",
    Handlers.utils.hasMatchingTag("Action", "Set-Algorithm"),
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
        
        local success, data = pcall(json.decode, msg.Data)
        
        if not success or not data.algorithm then
            ao.send({
                Target = msg.From,
                Data = json.encode({
                    error = "Invalid algorithm data provided",
                    status = "error"
                })
            })
            return
        end
        
        State.algorithm = data.algorithm
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                message = "Algorithm updated to: " .. State.algorithm
            })
        })
    end
)

-- Handler: Get Calculation History
Handlers.add(
    "Get-Calculation-History",
    Handlers.utils.hasMatchingTag("Action", "Get-Calculation-History"),
    function(msg)
        local limit = 10  -- Default limit
        
        if msg.Tags.Limit then
            limit = tonumber(msg.Tags.Limit) or 10
        end
        
        local history = {}
        local total = #State.calculations
        local start = math.max(1, total - limit + 1)
        
        for i = start, total do
            table.insert(history, State.calculations[i])
        end
        
        ao.send({
            Target = msg.From,
            Data = json.encode({
                status = "success",
                history = history,
                total_calculations = total
            })
        })
    end
)

-- Initialize Process
if not State.initialized then
    State.initialized = true
    print("QF Calculator Process initialized successfully")
    print("Version: " .. State.version)
    print("Algorithm: " .. State.algorithm)
end