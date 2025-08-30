# Phase 2-2: SBT 発行システム

## 実装対象

投票完了時に SBT (Soul Bound Token)を発行するシステムを実装してください。

## 要件

- Atomic Assets としての SBT 発行
- 投票情報と Lucky Number を含むメタデータ
- ユーザーごとの SBT 管理

## 実装内容

### 1. SBT 発行プロセス

- 投票完了時の自動発行
- Lucky Number 取得待機
- メタデータ構築

### 2. SBT メタデータ構造

```json
{
  "vote_choice": "true/fake",
  "vote_timestamp": 1703123456789,
  "news_id": "celebrity_marriage_001",
  "lucky_number": 777,
  "deposit_amount": "1000000000"
}
```

### 3. SBT 管理 Handler

- **Issue-SBT**: SBT 発行処理
- **Get-User-SBTs**: ユーザー SBT 一覧
- **Get-SBT-Info**: SBT 詳細情報

## Atomic Asset 統合

- Process spawn
- メタデータ設定
- 所有権管理

## 出力ファイル

`process/src/truthfi-core.lua` (Phase 2-1 に追加)

## 参考

- `/docs/ao-ecosystem/AtomicAssets.md`
- `/docs/ao-ecosystem/AO_Collections.md`
