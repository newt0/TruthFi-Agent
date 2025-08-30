# Phase 1-1: Basic Process Structure

## Implementation Target

Implement the basic structure of the TruthFi Process running on AO.

## Requirements

- Process name: TruthFi Core
- Management of one celebrity marriage news item
- Basic Handler structure
- Global State management

## Implementation Details

### 1. Global State Definition

```lua
State = State or {
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
    user_votes = {},
    sbt_tokens = {},

    -- AI evaluation prompt template
    ai_prompt_template = ""
}
```

### 2. Initialization Functions

```lua
-- Tweet data configuration function
function initializeTweetCase(tweet_data)
    State.active_tweet = tweet_data
end

-- Sample data configuration (for testing)
function loadSampleTweet()
    local sample_data = {
        case_id = "celebrity_marriage_tweet_001",
        title = "Celebrity A and B Marriage Announcement Tweet Fact-Check Vote",
        main_tweet = {
            tweet_id = "1735123456789012345",
            content = "🎉Finally got married! Thank you everyone! #MarriageAnnouncement #Happy",
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
                content = "Congratulations! What a lovely couple ✨",
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
end
```

### 3. Basic Handlers

- **Info**: Retrieve Process information
- **Get-Tweet-Case**: Retrieve current tweet case
- **Get-Stats**: Retrieve voting statistics (QF Calculator Process integration)
- **Set-Tweet-Case**: Set new tweet case (admin only)
- **Set-QF-Process**: Set QF Calculator Process ID

### 4. Sample Tweet Data

- Data schema definition (empty structure)
- Sample data configuration via initialization function
- Support for future dynamic data updates

## Output File

`process/src/truthfi-core.lua`

## Reference

- AO Process implementation patterns in `/docs/ao-ecosystem/`
- Handler structure best practices

## Expected Deliverables

- Complete Lua code
- Explanatory comments for each function
- Sample data for testing
