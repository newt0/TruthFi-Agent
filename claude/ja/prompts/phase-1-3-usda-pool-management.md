# Phase 1-3: USDA プール管理

## 実装対象

投票で受け取った USDA の簡易プール管理機能を実装してください。

## 要件

- 受け取った USDA を Process 内で管理
- LiquidOps 統合の準備（後の Phase で実装）
- 統計情報の正確な追跡

## 実装内容

### 1. USDA 残高管理

```lua
-- Process内USDA残高追跡
-- デポジット履歴記録
-- 統計データ更新
```

### 2. Credit-Notice Handler 強化

- USDA 受信時の残高更新
- 送信者情報の記録
- 投票との紐付け

### 3. プール情報取得 Handler

- **Get-Pool-Info**: プール統計情報
- **Get-Deposit-History**: デポジット履歴

## セキュリティ考慮

- 不正な送金の拒否
- 投票との整合性チェック
- 残高の正確性担保

## 出力ファイル

`process/src/truthfi-core.lua` (Phase 1-2 に追加)

## 参考

- `/docs/ao-ecosystem/` の Token 管理パターン
- Process 内残高追跡の実装例
