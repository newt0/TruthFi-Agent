# Phase 2-1: RandAO 統合

## 実装対象

RandAO SDK を使用して Lucky Number 生成機能を実装してください。

## 要件

- 提供された RandAO Module(@randao/random)の統合
- SBT 発行時の Lucky Number 生成
- 非同期処理の適切な管理

## 実装内容

### 1. RandAO Module 統合

```lua
local randomModule = require('@randao/random')(json)
```

### 2. Lucky Number 管理

- 乱数リクエスト記録
- 乱数レスポンス処理
- SBT メタデータへの組み込み

### 3. RandomResponse Handler

```lua
Handlers.add(
    "RandomResponse",
    Handlers.utils.hasMatchingTag("Action", "RandomResponse"),
    function(msg)
        -- RandAOからの乱数受信処理
    end
)
```

## 機能

- `randomModule.generateUUID()`: CallbackID 生成
- `randomModule.requestRandom()`: 乱数リクエスト
- `randomModule.processRandomResponse()`: レスポンス処理

## 出力ファイル

`process/src/truthfi-core.lua` (Phase 1-3 に追加)

## 参考

- `/docs/ao-ecosystem/RandAO_Module_README.md`
- `/docs/ao-ecosystem/RandAO_source.lua`
