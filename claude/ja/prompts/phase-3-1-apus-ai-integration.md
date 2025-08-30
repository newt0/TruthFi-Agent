# Phase 3-1: Apus AI 統合

## 実装対象

Apus AI SDK を使用してツイートの真偽判定機能を実装してください。

## 要件

- ツイート内容の AI 分析（複数ツイート対応）
- 信頼度パーセンテージ算出
- 人間投票との対比表示

## 実装内容

### 1. Apus AI Module 統合

```lua
local ApusAI = require("@apus/ai-lib")
```

### 2. AI 判定プロンプト管理

```lua
-- プロンプト動的構築関数
function buildAIPrompt(tweet_case)
    -- main_tweet + reference_tweets[] を整形
    -- followers, verified 情報も含める
    -- カスタマイズ可能なプロンプトテンプレート
end

-- デフォルトプロンプトテンプレート
State.ai_prompt_template = [[
以下のツイートとその関連情報の真偽性を総合的に判定してください。
0から1のスコアで回答してください（1=完全に真実、0=完全に虚偽）。

{MAIN_TWEET_DATA}
{REFERENCE_TWEETS_DATA}

アカウントの信頼性（フォロワー数、認証状況）とエンゲージメント数も考慮して、
スコアのみ数値で回答してください。
]]
```

### 3. プロンプト管理 Handler

- **Set-AI-Prompt**: AI 判定プロンプト更新（管理者用）
- **Get-AI-Prompt**: 現在のプロンプト取得

### 3. AI 判定 Handler

- **AI-Evaluate**: AI 判定実行
- **Get-AI-Analysis**: 判定結果取得
- **Compare-Results**: 人間投票との比較

### 4. 判定結果管理

- AI 判定結果の保存
- 信頼度パーセンテージ変換 (0-1 → 0%-100%)
- Quadratic Funding 式人間投票計算
- 統計データとの統合

## 表示形式

```
True Deposited:
  $10
  10名

Fake Deposited:
  $20
  20名

AI判定: 75% True | 25% Fake
人間投票: 40% True | 60% Fake
```

## Quadratic Funding 計算

```lua
-- GitcoinのQuadratic Fundingアルゴリズム参考
-- 大口投票者（クジラ）の影響を制限
-- 投票者数を重視した%計算
function calculateQuadraticVoting()
    -- 実装詳細はプロンプト内で指定
end
```

## 出力ファイル

`process/src/truthfi-core.lua` (Phase 2-2 に追加)

## 参考

- `/docs/ao-ecosystem/ApusAI_Inference.md`
- 非同期処理のベストプラクティス
