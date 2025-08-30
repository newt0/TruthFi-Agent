# Phase 0-1: QF Calculator Process

## 実装対象

Quadratic Funding 計算を行う独立した AO Process を実装してください。

## 要件

- Gitcoin Quadratic Funding アルゴリズム実装
- 大口投票者（クジラ）の影響制限
- 投票者数重視の民主的スコア算出
- 他の Process からの呼び出し対応

## 実装内容

### 1. グローバル State 定義

```lua
State = State or {
    version = "1.0.0",
    algorithm = "quadratic_funding",
    calculations = {}  -- 計算履歴
}
```

### 2. QF 計算アルゴリズム

```lua
-- Quadratic Funding計算関数
function calculateQuadraticFunding(votes_data)
    -- votes_data = {
    --     true_votes: { amounts: [], voters: [] },
    --     fake_votes: { amounts: [], voters: [] }
    -- }

    -- √(投票額)の合計を使用してクジラ対策
    -- true_score = (√amount1 + √amount2 + ...)^2
    -- fake_score = (√amount1 + √amount2 + ...)^2
    -- true_percentage = true_score / (true_score + fake_score) * 100
end
```

### 3. 基本 Handlers

- **Calculate-QF-Score**: QF スコア計算実行
- **Get-QF-Info**: Process 情報とアルゴリズム詳細
- **Set-Algorithm**: QF 計算方法変更（管理者用）

### 4. 入力・出力形式

```lua
-- 入力
{
    "true_votes": {
        "amounts": ["1000000000", "2000000000", "500000000"],
        "voters": 3
    },
    "fake_votes": {
        "amounts": ["3000000000", "1000000000"],
        "voters": 2
    }
}　

-- 出力
{
    "true_percentage": 45.2,
    "fake_percentage": 54.8,
    "true_qf_score": "1234567890",
    "fake_qf_score": "1500000000",
    "total_participants": 5
}
```

## Quadratic Funding の特徴

- **平方根計算**: √(投票額)で大口の影響を制限
- **民主性重視**: 投票者数が多いほど有利
- **透明性**: 計算過程を記録・公開

## 出力ファイル

`process/src/qf-calculator.lua`

## 参考

- Gitcoin Quadratic Funding 文書
- `/docs/ao-ecosystem/` の Process 間通信パターン

## テスト項目

- 通常ケース（複数投票者）
- クジラ対策（大口 1 名 vs 小口多数）
- エッジケース（投票 0 件、同額投票）
