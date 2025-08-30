# Phase 3-1: Apus AI 統合

## 実装対象

Apus AI SDK を使用してニュースの真偽判定機能を実装してください。

## 要件

- ニュース内容の AI 分析
- 信頼度パーセンテージ算出
- 人間投票との対比表示

## 実装内容

### 1. Apus AI Module 統合

```lua
local ApusAI = require("@apus/ai-lib")
```

### 2. AI 判定プロンプト

```
以下のニュースの真偽性を0から1のスコアで判定してください。
1が完全に真実、0が完全に虚偽です。
スコアのみ数値で回答してください: [ニュース内容]
```

### 3. AI 判定 Handler

- **AI-Evaluate**: AI 判定実行
- **Get-AI-Analysis**: 判定結果取得
- **Compare-Results**: 人間投票との比較

### 4. 判定結果管理

- AI 判定結果の保存
- 信頼度パーセンテージ変換 (0-1 → 0%-100%)
- 統計データとの統合

## 表示形式

```
AI判定: 75% True
人間投票: True 45% | Fake 55%
```

## 出力ファイル

`process/src/truthfi-core.lua` (Phase 2-2 に追加)

## 参考

- `/docs/ao-ecosystem/ApusAI_Inference.md`
- 非同期処理のベストプラクティス
