# Phase 1-1: 基本 Process 構造

## 実装対象

AO 上で動作する TruthFi Process の基本構造を実装してください。

## 要件

- Process 名: TruthFi Core
- 著名人結婚ニュース 1 件の管理
- 基本的な Handler 構造
- グローバル State 管理

## 実装内容

### 1. グローバル State 定義

````lua
State = State or {
### 1. グローバルState定義
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
            -- 配列: main_tweetと同じスキーマのオブジェクト群
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

    -- AI判定プロンプトテンプレート
    ai_prompt_template = ""
}
````

### 2. 初期化関数

```lua
-- ツイートデータ設定関数
function initializeTweetCase(tweet_data)
    State.active_tweet = tweet_data
end

-- サンプルデータ設定（テスト用）
function loadSampleTweet()
    local sample_data = {
        case_id = "celebrity_marriage_tweet_001",
        title = "著名人AとBの結婚報告ツイート真偽投票",
        main_tweet = {
            tweet_id = "1735123456789012345",
            content = "🎉ついに結婚しました！皆様ありがとうございます！ #結婚報告 #幸せ",
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
                content = "おめでとうございます！素敵なカップルですね✨",
                username = "friend_b_public",
                posted_at = "2024-12-15T11:00:00Z",
                likes = 892,
                retweets = 156,
                followers = 85000,
                verified = false
            },
            {
                tweet_id = "1735125678901234567",
                content = "え、これマジ？信じられない...本当に？",
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
    sbt_tokens = {}

}

```

### 3. 基本Handlers
- **Info**: Process情報取得
- **Get-Tweet-Case**: 現在のツイートケース取得
- **Get-Stats**: 投票統計取得（QF Calculator Process連携）
- **Set-Tweet-Case**: 新しいツイートケース設定（管理者用）
- **Set-QF-Process**: QF Calculator Process ID設定

### 4. サンプルツイートデータ
- データスキーマ定義（空の構造体）
- 初期化関数でサンプルデータ設定
- 将来的な動的データ更新に対応

## 出力ファイル

`process/src/truthfi-core.lua`

## 参考

- `/docs/ao-ecosystem/` のAO Process実装パターン
- Handler構造のベストプラクティス

## 期待する成果物

- 完全なLuaコード
- 各関数の説明コメント
- テスト用サンプルデータ
```
