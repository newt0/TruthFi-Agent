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

```lua
State = State or {
    active_news = {
        id = "celebrity_marriage_001",
        title = "著名人AとBの結婚報道",
        content = "2024年12月、メディアXが報じた結婚ニュース",
        ai_confidence = 0.0
    },
    voting_stats = {
        true_votes = 0,
        fake_votes = 0,
        total_deposits = "0",
        unique_voters = 0
    },
    user_votes = {},
    sbt_tokens = {}
}
```

### 2. 基本 Handlers

- **Info**: Process 情報取得
- **Get-News**: アクティブニュース取得
- **Get-Stats**: 投票統計取得

### 3. サンプルニュースデータ

- 著名人の結婚報道（仮名使用）
- 真偽判定可能な内容

## 出力ファイル

`process/src/truthfi-core.lua`

## 参考

- `/docs/ao-ecosystem/` の AO Process 実装パターン
- Handler 構造のベストプラクティス

## 期待する成果物

- 完全な Lua コード
- 各関数の説明コメント
- テスト用サンプルデータ
