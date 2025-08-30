# Phase 1-2: USDA 投票システム

## 実装対象

Phase 1-1 のベースに、USDA 投票システムを追加実装してください。

## 要件

- 1 ユーザー 1 ニュースにつき 1 回のみ投票
- 固定 1 USDA (1000000000 armstrong)のデポジット
- True/Fake の 2 択投票
- デポジット統計の自動更新

## 実装内容

### 1. Vote Handler

- ユーザー認証・重複投票チェック
- USDA 受信確認 (Credit-Notice Handler)
- 投票記録と統計更新

### 2. バリデーション機能

```lua
-- 投票金額チェック (1 USDA固定)
-- 投票選択肢チェック (true/fake)
-- ユーザー重複チェック
```

### 3. 投票結果取得 Handler

- **Get-User-Vote**: ユーザーの投票状況
- **Get-Voting-Results**: 全体投票結果

## 追加要素

- エラーハンドリング
- 投票成功時のレスポンス
- 投票統計のリアルタイム更新

## 出力ファイル

`process/src/truthfi-core.lua` (Phase 1-1 に追加)

## 参考

- `/docs/ao-ecosystem/` の Token Transfer 処理
- Credit-Notice Handler パターン
