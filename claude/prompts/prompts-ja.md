# TruthFi Process 段階的実装プロンプト集

_このプロンプト集は `/claude/prompts/` 配下の個別 md ファイルとして使用_

## Phase 1: 基本構造と USDA 投票システム

### Phase 1-1: 基本 Process 構造

````markdown
# Phase 1-1: TruthFi 基本構造実装

## Context

- プロジェクトルート: `/truthfi-mvp/`
- 参考ドキュメント: `/docs/ao-ecosystem/` 内の AO 実装例
- 設定ファイル: `/Claude.md` の開発ガイドライン参照

## 実装要件

AO 上で動作する Lua Process として TruthFi の基本構造を実装してください。

### 技術仕様

- Process 名: TruthFi Core
- AO Message Passing パターン使用
- `/docs/ao-ecosystem/Dexi_Platform_Architecture.md` の Process 設計パターン参考

### 実装内容

1. **グローバル State 定義** (`/process/src/truthfi-core.lua`)
   ```lua
   State = State or {
       active_news = {},
       voting_stats = {},
       user_votes = {},
       sbt_tokens = {}
   }
   ```
````

2. **基本 Handlers 実装**

   - Info (Process 情報取得)
   - Get-News (アクティブニュース取得)
   - Get-Stats (投票統計取得)

3. **サンプルデータ初期化**
   - 著名人結婚報道（仮名使用）
   - MVP 用固定データ

## 出力ファイル

1. **メインファイル**: `/process/src/truthfi-core.lua`

   - 完全な動作する Lua コード
   - AO Handler パターン準拠
   - 詳細なコメント付き

2. **テストファイル**: `/process/src/tests/test-phase1-1.lua`

   - 各 Handler の動作確認
   - サンプルデータ検証

3. **ドキュメント**: `/process/docs/phase1-1-api.md`
   - Handler 仕様書
   - 使用例とレスポンス形式

## 参考実装パターン

- `/docs/ao-ecosystem/Dexi_Terminal_Autonomous_Finance.md` の Handler 実装
- `/docs/ao-ecosystem/Botega.md` の状態管理パターン

## 動作確認手順

1. ファイル保存: `/process/src/truthfi-core.lua`
2. テスト実行: `cd process && aos --load-file src/truthfi-core.lua`
3. Handler 確認: `Send({Target = ao.id, Action = "Info"})`

```

### Phase 1-2: USDA投票システム

```

Phase 1-1 のベースに、USDA 投票システムを追加実装してください。

要件:

- 1 ユーザー 1 ニュースにつき 1 回のみ投票
- 固定 1 USDA (1000000000 armstrong)のデポジット
- True/Fake の 2 択投票
- デポジット統計の自動更新

実装内容:

1. Vote Handler

   - ユーザー認証
   - 重複投票チェック
   - USDA 受信確認 (Credit-Notice Handler)
   - 投票記録と統計更新

2. バリデーション機能

   - 投票金額チェック (1 USDA 固定)
   - 投票選択肢チェック (true/fake)
   - ユーザー重複チェック

3. 投票結果取得
   - Get-User-Vote Handler
   - Get-Voting-Results Handler

追加考慮事項:

- エラーハンドリング
- 投票成功時のレスポンス
- 投票統計のリアルタイム更新

```

### Phase 1-3: USDA簡易プール管理

```

投票で受け取った USDA の簡易プール管理機能を実装してください。

要件:

- 受け取った USDA を Process 内で管理
- LiquidOps 統合の準備（後の Phase で実装）
- 統計情報の正確な追跡

実装内容:

1. USDA 残高管理

   - Process 内 USDA 残高追跡
   - デポジット履歴記録
   - 統計データ更新

2. Credit-Notice Handler 強化

   - USDA 受信時の残高更新
   - 送信者情報の記録
   - 投票との紐付け

3. プール情報取得
   - Get-Pool-Info Handler
   - 総デポジット額表示
   - ユーザー別デポジット履歴

セキュリティ考慮:

- 不正な送金の拒否
- 投票との整合性チェック
- 残高の正確性担保

```

## Phase 2: SBT発行とRandAO統合

### Phase 2-1: RandAO統合準備

```

RandAO SDK を使用して Lucky Number 生成機能を実装してください。

要件:

- 提供された RandAO Module(@randao/random)の統合
- SBT 発行時の Lucky Number 生成
- 非同期処理の適切な管理

実装内容:

1. RandAO Module 統合

   - randomModule.generateUUID()
   - randomModule.requestRandom()
   - randomModule.processRandomResponse()

2. Lucky Number 管理

   - 乱数リクエスト記録
   - 乱数レスポンス処理
   - SBT メタデータへの組み込み

3. RandomResponse Handler
   - RandAO からの乱数受信
   - callbackId との照合
   - SBT 発行処理への連携

参考実装:

- ドキュメント内の RandAO Module サンプルコード
- 非同期処理のベストプラクティス

```

### Phase 2-2: SBT (Atomic Assets) 発行システム

```

投票完了時に SBT を発行するシステムを実装してください。

要件:

- Atomic Assets としての SBT 発行
- 投票情報と Lucky Number を含むメタデータ
- ユーザーごとの SBT 管理

実装内容:

1. SBT 発行プロセス

   - 投票完了時の自動発行
   - Lucky Number 取得待機
   - メタデータ構築

2. SBT メタデータ構造

   - vote_choice (true/fake)
   - vote_timestamp
   - news_id
   - lucky_number
   - deposit_amount

3. Atomic Asset 統合

   - Process spawn
   - メタデータ設定
   - 所有権管理

4. SBT 管理 Handler
   - Issue-SBT Handler
   - Get-User-SBTs Handler
   - SBT 情報取得

参考:

- ドキュメント内の Atomic Assets 実装例
- SBT の非代替性確保

```

## Phase 3: Apus AI統合

### Phase 3-1: Apus AI判定システム

```

Apus AI SDK を使用してニュースの真偽判定機能を実装してください。

要件:

- ニュース内容の AI 分析
- 信頼度パーセンテージ算出
- 人間投票との対比表示

実装内容:

1. Apus AI Module 統合

   - ApusAI.infer() 関数の使用
   - プロンプトエンジニアリング
   - 非同期レスポンス処理

2. AI 判定プロンプト

   - ニュース真偽性分析指示
   - 数値スコア(0-1)での回答要求
   - 一貫性のあるプロンプト設計

3. AI 判定結果管理

   - AI-Evaluate Handler
   - 判定結果の保存
   - 統計データとの統合

4. 判定結果表示
   - Get-AI-Analysis Handler
   - 信頼度パーセンテージ変換
   - 人間投票との比較データ

AI 判定プロンプト例:
"以下のニュースの真偽性を 0 から 1 のスコアで判定してください。1 が完全に真実、0 が完全に虚偽です。スコアのみ数値で回答してください: [ニュース内容]"

```

## Phase 4: 統合とテスト

### Phase 4-1: システム統合

```

これまでの Phase で実装した機能を統合し、完全な TruthFi Process を完成させてください。

統合要件:

- 全機能の連携動作
- エラーハンドリングの統一
- パフォーマンス最適化

実装内容:

1. フロー統合

   - 投票 →SBT 発行 →AI 判定の連携
   - 非同期処理の同期化
   - 状態管理の一貫性

2. 総合 Handler 追加

   - Complete-Vote Handler (全機能統合)
   - Dashboard-Data Handler (UI 用データ)

3. エラーハンドリング統一

   - 共通エラー形式
   - 適切なエラーメッセージ
   - 失敗時のロールバック

4. テスト支援機能
   - Reset-State Handler (開発用)
   - Debug-Info Handler (デバッグ用)

```

### Phase 4-2: 最終テストとドキュメント

```

完成した TruthFi Process の動作テストとドキュメントを作成してください。

テスト要件:

- 全 Handler の動作確認
- エッジケースのテスト
- パフォーマンス検証

実装内容:

1. テストスクリプト

   - 各 Handler の呼び出しテスト
   - 異常系テスト
   - 統合テスト手順

2. ドキュメント作成

   - API 仕様書
   - Handler 一覧
   - 使用例

3. デプロイメント準備
   - 初期化手順
   - 設定項目の整理
   - トラブルシューティング

最終成果物:

- 完全動作する TruthFi Process
- テスト済みの全機能
- フロントエンド連携準備完了

```

## 各Phase完了時の確認事項

### Phase 1完了時チェック
- [ ] 基本投票機能が動作する
- [ ] USDA受信と統計更新が正常
- [ ] 重複投票が適切に防止されている

### Phase 2完了時チェック
- [ ] RandAOからLucky Numberを取得できる
- [ ] SBTが適切に発行される
- [ ] メタデータが正しく設定されている

### Phase 3完了時チェック
- [ ] Apus AIから判定結果を取得できる
- [ ] 信頼度が適切に表示される
- [ ] 人間投票との比較ができる

### Phase 4完了時チェック
- [ ] 全機能が統合されている
- [ ] エラーハンドリングが適切
- [ ] フロントエンド連携準備完了

---

## 使用方法

1. Phase 1-1から順番に実装依頼
2. 各Phase完了後、動作確認を実施
3. 問題があれば該当Phaseの修正を依頼
4. 次Phase進行前に必ずテスト完了

この段階的アプローチにより、確実に動作するTruthFi Processが完成します。
```

## Phase 4: 統合とテスト

### Phase 4-1: システム統合

````markdown
# Phase 4-1: TruthFi システム統合

## Context

- 前提: Phase 3 完了済み (全コア機能実装完了)
- 目標: 完全統合された TruthFi Process の完成
- 参考: `/Claude.md` の品質基準

## 実装要件

これまでの Phase で実装した機能を統合し、完全な TruthFi Process を完成させてください。

### 統合スコープ

- 投票システム + USDA プール管理
- SBT 発行 + RandAO Lucky Number
- Apus AI 判定 + 比較分析
- 全 Handler の連携動作

### 実装内容

1. **完全統合フロー**
   ```lua
   -- 統合Handler: Complete-Vote
   function completeVoteFlow(user_id, vote_choice, deposit_amount)
       -- 1. 投票処理 + USDA受信
       -- 2. Lucky Number生成開始
       -- 3. AI判定実行
       -- 4. SBT発行
       -- 5. 統計更新
   end
   ```
````

2. **Dashboard Data Handler**

   ```lua
   -- UI用統合データ提供
   Handlers.add("Dashboard-Data", ...)
   -- 投票統計、AI比較、プール情報、SBT情報を一括取得
   ```

3. **エラーハンドリング統一**

   ```lua
   -- 共通エラー形式
   error_response = {
       success = false,
       error_code = "DUPLICATE_VOTE",
       message = "User has already voted on this news",
       timestamp = os.time()
   }
   ```

4. **状態管理最適化**
   - 非同期処理の同期化
   - データ整合性チェック
   - 状態復旧機能

## 出力ファイル

1. **統合メインファイル**: `/process/src/truthfi-core.lua`

   - 全 Phase 機能統合版
   - 完全動作フロー実装
   - 統一エラーハンドリング

2. **統合 Handler**: `/process/src/handlers/integration.lua`

   - Complete-Vote Handler
   - Dashboard-Data Handler
   - System-Status Handler

3. **設定統合**: `/process/deploy/production-config.json`

   - 全外部サービス設定統合
   - 本番環境用パラメータ
   - フェールセーフ設定

4. **統合テスト**: `/process/src/tests/integration-test.lua`

   - 完全フローテスト
   - エラーケース網羅テスト
   - パフォーマンステスト

5. **運用ドキュメント**: `/process/docs/operation-guide.md`
   - デプロイ手順
   - 監視ポイント
   - トラブルシューティング

## 統合フロー設計

```lua
-- 完全投票フロー例
function executeCompleteVote(msg)
    local user_id = msg.From
    local vote_choice = msg.Tags.Choice

    -- Step 1: 投票バリデーション
    -- Step 2: USDA受信確認
    -- Step 3: 投票記録
    -- Step 4: Lucky Number生成
    -- Step 5: SBT発行準備
    -- Step 6: 統計更新
    -- Step 7: 成功レスポンス
end
```

## テスト手順

1. 統合ファイル配置
2. 設定ファイル更新
3. 完全フローテスト実行
4. 全 Handler 動作確認
5. エラーケース検証

## 品質チェックリスト

- [ ] 投票 →SBT 発行フロー完全動作
- [ ] AI 判定と人間投票の正確な比較
- [ ] USDA 残高の正確な管理
- [ ] Lucky Number の正しい生成と埋め込み
- [ ] エラー時の適切なロールバック

````# TruthFi Process 段階的実装プロンプト集

*このプロンプト集は `/claude/prompts/` 配下の個別mdファイルとして使用*

## Phase 1: 基本構造とUSDA投票システム

### Phase 1-1: 基本Process構造

```markdown
# Phase 1-1: TruthFi基本構造実装

## Context
- プロジェクトルート: `/truthfi-mvp/`
- 参考ドキュメント: `/docs/ao-ecosystem/` 内のAO実装例
- 設定ファイル: `/Claude.md` の開発ガイドライン参照

## 実装要件
AO上で動作するLua ProcessとしてTruthFiの基本構造を実装してください。

### 技術仕様
- Process名: TruthFi Core
- AO Message Passing パターン使用
- `/docs/ao-ecosystem/Dexi_Platform_Architecture.md` のProcess設計パターン参考

### 実装内容
1. **グローバルState定義** (`/process/src/truthfi-core.lua`)
   ```lua
   State = State or {
       active_news = {},
       voting_stats = {},
       user_votes = {},
       sbt_tokens = {}
   }
````

2. **基本 Handlers 実装**

   - Info (Process 情報取得)
   - Get-News (アクティブニュース取得)
   - Get-Stats (投票統計取得)

3. **サンプルデータ初期化**
   - 著名人結婚報道（仮名使用）
   - MVP 用固定データ

## 出力ファイル

1. **メインファイル**: `/process/src/truthfi-core.lua`

   - 完全な動作する Lua コード
   - AO Handler パターン準拠
   - 詳細なコメント付き

2. **テストファイル**: `/process/src/tests/test-phase1-1.lua`

   - 各 Handler の動作確認
   - サンプルデータ検証

3. **ドキュメント**: `/process/docs/phase1-1-api.md`
   - Handler 仕様書
   - 使用例とレスポンス形式

## 参考実装パターン

- `/docs/ao-ecosystem/Dexi_Terminal_Autonomous_Finance.md` の Handler 実装
- `/docs/ao-ecosystem/Botega.md` の状態管理パターン

## 動作確認手順

1. ファイル保存: `/process/src/truthfi-core.lua`
2. テスト実行: `cd process && aos --load-file src/truthfi-core.lua`
3. Handler 確認: `Send({Target = ao.id, Action = "Info"})`

````

### Phase 1-2: USDA投票システム

```markdown
# Phase 1-2: USDA投票システム実装

## Context
- 前提: Phase 1-1完了済み (`/process/src/truthfi-core.lua` 基本構造)
- 参考: `/docs/ao-ecosystem/Astro_Bridge.md` のUSDA仕様
- 参考: `/docs/ao-ecosystem/UniversalContentMarketplace.md` のトークン転送パターン

## 実装要件
Phase 1-1のベースに、USDA投票システムを追加実装してください。

### 技術仕様
- 固定デポジット: 1 USDA (1000000000 armstrong)
- 投票制限: 1ユーザー1ニュースにつき1回のみ
- 投票選択肢: True/Fake の2択

### 実装内容
1. **Vote Handler追加** (`/process/src/truthfi-core.lua`に統合)
   ```lua
   Handlers.add("Vote",
     Handlers.utils.hasMatchingTag("Action", "Vote"),
     function(msg) -- 実装 end
   )
````

2. **Credit-Notice Handler** (USDA 受信処理)

   - `/docs/ao-ecosystem/UniversalContentMarketplace.md` の Credit-Notice パターン参考
   - 投票との紐付け検証
   - 金額バリデーション (1 USDA 固定)

3. **バリデーション機能**

   - 重複投票防止
   - 投票選択肢検証 (true/fake)
   - USDA 数量確認

4. **統計管理 Handler**
   - Get-User-Vote: ユーザー個人投票確認
   - Get-Voting-Results: 全体投票結果

## 出力ファイル

1. **更新ファイル**: `/process/src/truthfi-core.lua`

   - 既存コードに投票機能追加
   - Credit-Notice Handler 統合
   - バリデーション関数追加

2. **テストファイル**: `/process/src/tests/test-voting.lua`

   - 投票フロー全体テスト
   - エラーケーステスト
   - USDA 転送シミュレーション

3. **API 更新**: `/process/docs/voting-api.md`
   - 投票 Handler 仕様
   - エラーレスポンス一覧
   - 使用例

## USDA 統合パターン

```lua
-- Credit-Notice Handler例
Handlers.add("Credit-Notice",
  Handlers.utils.hasMatchingTag("Action", "Credit-Notice"),
  function(msg)
    -- USDA受信時の処理
    -- 投票情報との照合
    -- 統計更新
  end
)
```

## テスト手順

1. 更新ファイル配置: `/process/src/truthfi-core.lua`
2. AOS 起動: `cd process && aos --load-file src/truthfi-core.lua`
3. 投票テスト: `Send({Target = ao.id, Action = "Vote", Choice = "true"})`
4. 統計確認: `Send({Target = ao.id, Action = "Get-Stats"})`

## エラーハンドリング要件

- 重複投票: "Already voted" エラー
- 不正金額: "Invalid deposit amount" エラー
- 無効選択: "Invalid vote choice" エラー

````

### Phase 1-3: USDA簡易プール管理

```markdown
# Phase 1-3: USDA簡易プール管理実装

## Context
- 前提: Phase 1-2完了済み (投票システム動作確認済み)
- 参考: `/docs/ao-ecosystem/Dexi_Platform_Architecture.md` の資産管理パターン
- 将来準備: LiquidOps統合のための基盤構築

## 実装要件
投票で受け取ったUSDAの簡易プール管理機能を実装してください。

### 技術仕様
- Process内USDA残高管理
- デポジット履歴追跡
- 統計情報の正確な集計

### 実装内容
1. **USDA残高管理機能**
   ```lua
   State.pool_info = State.pool_info or {
       total_balance = "0",
       deposit_history = {},
       last_updated = 0
   }
````

2. **Credit-Notice Handler 強化**

   - 既存 Handler に残高更新機能追加
   - デポジット履歴記録
   - タイムスタンプ管理

3. **プール情報 Handler 群**

   - Get-Pool-Info: プール全体情報
   - Get-Deposit-History: デポジット履歴
   - Get-User-Deposits: ユーザー別デポジット

4. **統計集計強化**
   - リアルタイム残高計算
   - ユーザー別デポジット合計
   - 時系列データ管理

## 出力ファイル

1. **更新ファイル**: `/process/src/truthfi-core.lua`

   - プール管理機能統合
   - 強化された Credit-Notice Handler
   - 新規 Handler 群追加

2. **ユーティリティ**: `/process/src/modules/pool-manager.lua`

   - 残高計算関数
   - 履歴管理関数
   - バリデーション関数

3. **テストファイル**: `/process/src/tests/test-pool.lua`

   - 残高計算テスト
   - 履歴記録テスト
   - 統計整合性テスト

4. **仕様書**: `/process/docs/pool-api.md`
   - プール管理 API 仕様
   - データ構造説明
   - 使用例

## プール管理パターン

```lua
-- プール情報更新例
function updatePoolBalance(amount, user_id)
    -- 残高更新
    -- 履歴記録
    -- 統計更新
end
```

## LiquidOps 準備設計

- 将来的な外部 Process 連携を考慮した設計
- プール残高の外部送金準備
- 運用履歴の透明性確保

## テスト手順

1. ファイル更新: `/process/src/truthfi-core.lua`
2. モジュール配置: `/process/src/modules/pool-manager.lua`
3. AOS 再起動: `cd process && aos --load-file src/truthfi-core.lua`
4. プール確認: `Send({Target = ao.id, Action = "Get-Pool-Info"})`
5. 複数投票テストで残高追跡確認

## セキュリティ考慮事項

- 残高計算の整合性チェック
- 不正送金の検出と拒否
- 履歴データの改ざん防止

````

## Phase 2: SBT発行とRandAO統合

### Phase 2-1: RandAO統合準備

```markdown
# Phase 2-1: RandAO統合実装

## Context
- 前提: Phase 1完了済み (投票システム+プール管理)
- 参考: `/docs/ao-ecosystem/RandAO_Module_README.md`
- ソース: `/docs/ao-ecosystem/RandAO_source.lua`

## 実装要件
RandAO SDKを使用してLucky Number生成機能を実装してください。

### 技術仕様
- RandAO Module (@randao/random) 統合
- SBT発行時のLucky Number生成
- 非同期処理の適切な管理

### 実装内容
1. **RandAO Module統合**
   ```lua
   -- /process/src/modules/randao-integration.lua
   local randomModule = require('@randao/random')(json)
````

2. **Lucky Number 管理**

   ```lua
   State.pending_randoms = State.pending_randoms or {}
   State.completed_randoms = State.completed_randoms or {}
   ```

3. **RandomResponse Handler**

   - RandAO からの乱数受信処理
   - callbackId との照合
   - SBT 発行プロセスへの連携

4. **乱数リクエスト管理**
   - UUID 生成と callback 管理
   - 非同期処理状態追跡
   - タイムアウト処理

## 出力ファイル

1. **モジュールファイル**: `/process/src/modules/randao-integration.lua`

   - RandAO Module ラッパー
   - Lucky Number 生成関数
   - 状態管理機能

2. **メイン更新**: `/process/src/truthfi-core.lua`

   - RandomResponse Handler 追加
   - 乱数リクエスト機能統合
   - 既存投票フローとの連携

3. **テストファイル**: `/process/src/tests/test-randao.lua`

   - 乱数生成テスト
   - 非同期処理テスト
   - エラーケーステスト

4. **設定ファイル**: `/process/deploy/randao-config.json`
   - RandAO 接続設定
   - テスト用パラメータ
   - 本番用設定

## RandAO 統合パターン

```lua
-- 乱数リクエスト例
function requestLuckyNumber(user_id, vote_id)
    local callback_id = randomModule.generateUUID()
    randomModule.requestRandom(callback_id)

    State.pending_randoms[callback_id] = {
        user_id = user_id,
        vote_id = vote_id,
        timestamp = os.time()
    }
end
```

## 非同期処理フロー

1. 投票完了時 → Lucky Number リクエスト
2. RandAO → 乱数生成 → レスポンス
3. RandomResponse Handler → 乱数受信
4. SBT 発行プロセス開始

## テスト手順

1. モジュール配置: `/process/src/modules/randao-integration.lua`
2. 設定配置: `/process/deploy/randao-config.json`
3. メイン更新: `/process/src/truthfi-core.lua`
4. AOS 再起動: `cd process && aos --load-file src/truthfi-core.lua`
5. 乱数テスト: `Send({Target = ao.id, Action = "Test-Random"})`

## エラーハンドリング

- RandAO 接続エラー処理
- タイムアウト時の再試行
- 乱数検証とフォールバック

````

### Phase 2-2: SBT (Atomic Assets) 発行システム

```markdown
# Phase 2-2: SBT発行システム実装

## Context
- 前提: Phase 2-1完了済み (RandAO統合)
- 参考: `/docs/ao-ecosystem/AtomicAssets.md`
- 参考: `/docs/ao-ecosystem/AO_Collections.md`

## 実装要件
投票完了時にSBT (Soul Bound Token) を発行するシステムを実装してください。

### 技術仕様
- Atomic Assets としてのSBT発行
- 投票情報 + Lucky Number をメタデータに記録
- 非代替性 (Soul Bound) の実装

### 実装内容
1. **SBT発行プロセス**
   ```lua
   -- /process/src/handlers/sbt-issuer.lua
   function issueSBT(user_id, vote_data, lucky_number)
       -- SBTメタデータ構築
       -- Atomic Asset Process spawn
       -- 所有権設定
   end
````

2. **SBT メタデータ構造**

   ```lua
   sbt_metadata = {
       vote_choice = "true/fake",
       vote_timestamp = os.time(),
       news_id = "celebrity_marriage_001",
       lucky_number = 12345,
       deposit_amount = "1000000000",
       is_soulbound = true
   }
   ```

3. **Atomic Asset 統合**

   - `/docs/ao-ecosystem/AtomicAssets.md` パターン使用
   - Process spawn with SBT tags
   - メタデータの Arweave 永続化

4. **SBT 管理 Handler 群**
   - Issue-SBT: SBT 発行処理
   - Get-User-SBTs: ユーザー SBT 一覧
   - Get-SBT-Info: 個別 SBT 情報

## 出力ファイル

1. **SBT ハンドラ**: `/process/src/handlers/sbt-issuer.lua`

   - SBT 発行ロジック
   - メタデータ管理
   - Atomic Asset 統合

2. **メイン更新**: `/process/src/truthfi-core.lua`

   - SBT Handler 群統合
   - 投票完了フローに SBT 発行追加
   - Lucky Number + SBT 発行の連携

3. **SBT テンプレート**: `/process/src/templates/sbt-template.lua`

   - SBT Process 用 Lua コード
   - Soul Bound 制約実装
   - メタデータアクセサ

4. **テストファイル**: `/process/src/tests/test-sbt.lua`

   - SBT 発行フローテスト
   - メタデータ検証テスト
   - 非代替性確認テスト

5. **API 仕様**: `/process/docs/sbt-api.md`
   - SBT 発行 API 詳細
   - メタデータスキーマ
   - 使用例

## SBT 発行フロー

1. 投票完了 → Lucky Number 生成完了
2. SBT メタデータ構築
3. Atomic Asset Process spawn
4. SBT Process 初期化
5. ユーザーへの SBT 送付
6. SBT 記録の永続化

## Soul Bound 制約実装

```lua
-- SBT Transferプロテクション
Handlers.add("Transfer",
  Handlers.utils.hasMatchingTag("Action", "Transfer"),
  function(msg)
    ao.send({Target = msg.From, Data = "Error: Soul Bound Token - Transfer not allowed"})
  end
)
```

## テスト手順

1. ハンドラ配置: `/process/src/handlers/sbt-issuer.lua`
2. テンプレート配置: `/process/src/templates/sbt-template.lua`
3. メイン更新: `/process/src/truthfi-core.lua`
4. 完全投票フローテスト: 投票 → Lucky Number → SBT 発行
5. SBT 照会テスト: `Send({Target = ao.id, Action = "Get-User-SBTs"})`

## 品質保証

- SBT メタデータの完全性確認
- Lucky Number の正しい埋め込み
- Soul Bound 制約の動作確認
- ガス効率性の検証

````

## Phase 3: Apus AI統合

### Phase 3-1: Apus AI判定システム

```markdown
# Phase 3-1: Apus AI判定システム実装

## Context
- 前提: Phase 2完了済み (SBT発行システム動作確認済み)
- 参考: `/docs/ao-ecosystem/ApusAI_Inference.md`
- 要件: ニュース真偽性の AI 信頼度判定

## 実装要件
Apus AI SDKを使用してニュースの真偽判定機能を実装してください。

### 技術仕様
- ApusAI.infer() による真偽性分析
- 0-1スケールの信頼度スコア算出
- 人間投票結果との対比表示

### 実装内容
1. **Apus AI Module統合**
   ```lua
   -- /process/src/modules/apus-integration.lua
   local ApusAI = require("@apus/ai-lib")
````

2. **AI 判定プロンプト設計**

   ```lua
   local analysis_prompt = "以下のニュースの真偽性を0から1のスコアで判定してください。1が完全に真実、0が完全に虚偽です。スコアのみ数値で回答してください: " .. news_content
   ```

3. **AI 判定結果管理**

   ```lua
   State.ai_evaluations = State.ai_evaluations or {
       news_001 = {
           confidence_score = 0.0,
           last_updated = 0,
           status = "pending" -- pending/completed/failed
       }
   }
   ```

4. **AI 判定 Handler 群**
   - AI-Evaluate: AI 判定実行
   - Get-AI-Analysis: 判定結果取得
   - Compare-Results: 人間 vs AI 比較

## 出力ファイル

1. **AI モジュール**: `/process/src/modules/apus-integration.lua`

   - Apus AI SDK ラッパー
   - 判定プロンプト管理
   - 非同期レスポンス処理

2. **メイン更新**: `/process/src/truthfi-core.lua`

   - AI Handler 群追加
   - ニュース初期化時の AI 判定実行
   - 統計表示に AI 結果統合

3. **AI Handler**: `/process/src/handlers/ai-analyzer.lua`

   - AI 判定ロジック
   - スコア正規化処理
   - エラーハンドリング

4. **テストファイル**: `/process/src/tests/test-ai.lua`

   - AI 判定テスト
   - スコア検証テスト
   - 比較機能テスト

5. **設定ファイル**: `/process/deploy/apus-config.json`
   - Apus AI 接続設定
   - プロンプトテンプレート
   - 判定閾値設定

## AI 判定プロンプト戦略

```lua
-- 構造化プロンプト例
function buildAnalysisPrompt(news_data)
    return string.format([[
分析対象: %s
内容: %s
情報源: %s

この情報の真偽性を0.0-1.0の数値スコアで判定してください。
1.0 = 完全に真実
0.5 = 判定困難/情報不足
0.0 = 完全に虚偽

スコアのみを数値で回答してください。
]], news_data.title, news_data.content, news_data.source)
end
```

## 人間 vsAI 比較機能

```lua
-- 比較データ構造
comparison_result = {
    human_votes = {true_percent = 45, fake_percent = 55},
    ai_confidence = 0.72,
    divergence = 0.27, -- |human_true_percent - ai_confidence|
    consensus_level = "low" -- low/medium/high
}
```

## テスト手順

1. モジュール配置: `/process/src/modules/apus-integration.lua`
2. 設定配置: `/process/deploy/apus-config.json`
3. メイン更新: `/process/src/truthfi-core.lua`
4. AI 判定テスト: `Send({Target = ao.id, Action = "AI-Evaluate"})`
5. 比較表示テスト: `Send({Target = ao.id, Action = "Compare-Results"})`

## UI 表示フォーマット

- AI 判定: 72% True (信頼度 0.72 → 72%変換)
- 人間投票: True 45% | Fake 55%
- 判定差異: 27 ポイント

## エラーハンドリング

- Apus AI 接続エラー時のフォールバック
- 判定スコア異常値の処理
- タイムアウト時の再試行メカニズム

```

## Phase 4: 統合とテスト

### Phase 4-1: システム統合

```

これまでの Phase で実装した機能を統合し、完全な TruthFi Process を完成させてください。

統合要件:

- 全機能の連携動作
- エラーハンドリングの統一
- パフォーマンス最適化

実装内容:

1. フロー統合

   - 投票 →SBT 発行 →AI 判定の連携
   - 非同期処理の同期化
   - 状態管理の一貫性

2. 総合 Handler 追加

   - Complete-Vote Handler (全機能統合)
   - Dashboard-Data Handler (UI 用データ)

3. エラーハンドリング統一

   - 共通エラー形式
   - 適切なエラーメッセージ
   - 失敗時のロールバック

4. テスト支援機能
   - Reset-State Handler (開発用)
   - Debug-Info Handler (デバッグ用)

````

### Phase 4-2: 最終テストとドキュメント

```markdown
# Phase 4-2: 最終テストとドキュメント作成

## Context
- 前提: Phase 4-1完了済み (統合システム動作確認済み)
- 目標: 本番レディなTruthFi Process完成
- デプロイ準備: フロントエンド連携準備完了

## 実装要件
完成したTruthFi Processの動作テストとドキュメントを作成してください。

### テスト要件
- 全Handler の動作確認
- エッジケースの検証
- パフォーマンス検証
- フロントエンド連携テスト

### 実装内容
1. **包括的テストスイート**
   ```lua
   -- /process/src/tests/final-test-suite.lua
   function runFullTestSuite()
       -- 基本機能テスト
       -- 統合フローテスト
       -- エラーケーステスト
       -- パフォーマンステスト
   end
````

2. **API 仕様書完成版**

   - 全 Handler 仕様統合
   - リクエスト/レスポンス例
   - エラーコード一覧
   - 使用制限事項

3. **フロントエンド連携準備**

   - CORS 設定（必要に応じて）
   - データ形式標準化
   - WebSocket 対応（リアルタイム更新用）

4. **デプロイメントスクリプト**
   - 自動デプロイ手順
   - 初期化データ投入
   - ヘルスチェック機能

## 出力ファイル

1. **最終テストスイート**: `/process/src/tests/final-test-suite.lua`

   - 全機能統合テスト
   - ストレステスト
   - エッジケーステスト
   - レポート生成機能

2. **完全 API 仕様書**: `/process/docs/api-specification.md`

   - 全 Handler 詳細仕様
   - 統合フロー API
   - エラーハンドリング仕様
   - 使用例集

3. **デプロイスクリプト**: `/scripts/deploy-production.js`

   - AO Process デプロイ自動化
   - 初期設定投入
   - 動作確認自動実行

4. **運用マニュアル**: `/process/docs/operations-manual.md`

   - 日常運用手順
   - 監視項目設定
   - 障害対応手順
   - スケーリング指針

5. **フロントエンド連携仕様**: `/docs/frontend-integration.md`
   - API 呼び出し方法
   - データ形式仕様
   - リアルタイム更新方法
   - 認証・認可フロー

## 最終テスト項目

### 基本機能テスト

- [ ] 投票機能（True/Fake 両方）
- [ ] USDA 受信とプール管理
- [ ] 重複投票防止
- [ ] 統計情報更新

### 統合機能テスト

- [ ] RandAO Lucky Number 生成
- [ ] SBT 発行と受け取り
- [ ] Apus AI 判定実行
- [ ] 人間 vsAI 比較表示

### エラーケーステスト

- [ ] 不正金額での投票試行
- [ ] 重複投票試行
- [ ] 外部サービス障害時の動作
- [ ] 不正データ送信時の処理

### パフォーマンステスト

- [ ] 同時投票処理能力
- [ ] 大量データ時の応答時間
- [ ] メモリ使用量監視
- [ ] 外部 API 呼び出し効率

## デプロイ検証手順

1. **ローカル統合テスト**

   ```bash
   cd process && node ../scripts/run-test-suite.js
   ```

2. **テストネット本格デプロイ**

   ```bash
   npm run deploy:testnet
   ```

3. **機能動作確認**

   ```bash
   npm run verify:deployment
   ```

4. **フロントエンド接続テスト**
   ```bash
   npm run test:frontend-integration
   ```

## 成功基準

- [ ] 全テストケース Pass
- [ ] API 応答時間 < 2 秒
- [ ] エラー率 < 1%
- [ ] ドキュメント完全性 100%
- [ ] フロントエンド連携準備完了

## 最終成果物チェックリスト

- [ ] 動作確認済み TruthFi Process
- [ ] 完全な API 仕様書
- [ ] 自動テストスイート
- [ ] デプロイメント自動化
- [ ] 運用マニュアル
- [ ] フロントエンド連携仕様
- [ ] トラブルシューティングガイド

## 次段階への引き継ぎ事項

- プロセス ID 情報
- 設定ファイル一式
- テストアカウント情報
- API エンドポイント一覧
- 外部サービス認証情報

```

## 各Phase完了時の確認事項

### Phase 1完了時チェック
- [ ] 基本投票機能が動作する
- [ ] USDA受信と統計更新が正常
- [ ] 重複投票が適切に防止されている
- [ ] プール残高が正確に管理されている
- [ ] ファイル配置: `/process/src/truthfi-core.lua` 基本版完成

### Phase 2完了時チェック
- [ ] RandAOからLucky Numberを取得できる
- [ ] SBTが適切に発行される
- [ ] メタデータが正しく設定されている
- [ ] 非同期処理が正常に動作している
- [ ] ファイル配置:
  - `/process/src/modules/randao-integration.lua`
  - `/process/src/handlers/sbt-issuer.lua`
  - `/process/src/templates/sbt-template.lua`

### Phase 3完了時チェック
- [ ] Apus AIから判定結果を取得できる
- [ ] 信頼度が適切に表示される（0-1 → パーセンテージ）
- [ ] 人間投票との比較ができる
- [ ] AI判定エラーハンドリングが動作する
- [ ] ファイル配置:
  - `/process/src/modules/apus-integration.lua`
  - `/process/src/handlers/ai-analyzer.lua`

### Phase 4完了時チェック
- [ ] 全機能が統合されている
- [ ] 完全投票フローが動作する
- [ ] エラーハンドリングが適切
- [ ] フロントエンド連携準備完了
- [ ] テストスイートが Pass する
- [ ] 最終成果物:
  - `/process/src/truthfi-core.lua` 統合完成版
  - `/process/docs/api-specification.md`
  - `/process/src/tests/final-test-suite.lua`
  - `/scripts/deploy-production.js`

---

## プロンプトファイル分割指針

各プロンプトを以下のファイル名で `/claude/prompts/` に保存：

```

claude/prompts/
├── phase-1-1-basic-structure.md # Phase 1-1 の内容
├── phase-1-2-voting-system.md # Phase 1-2 の内容  
├── phase-1-3-pool-management.md # Phase 1-3 の内容
├── phase-2-1-randao-integration.md # Phase 2-1 の内容
├── phase-2-2-sbt-issuance.md # Phase 2-2 の内容
├── phase-3-1-ai-integration.md # Phase 3-1 の内容
├── phase-4-1-system-integration.md # Phase 4-1 の内容
└── phase-4-2-testing-docs.md # Phase 4-2 の内容

```

## 使用方法

1. **段階的実装**: Phase 1-1から順番に実装依頼
2. **動作確認**: 各Phase完了後、必ずテスト実行
3. **問題対応**: エラー発生時は該当Phaseの修正を依頼
4. **進捗管理**: チェックリストで品質確認
5. **最終統合**: Phase 4で全機能統合とテスト

## Claude Code実行時の注意事項

- **ローカルドキュメント参照**: `/docs/ao-ecosystem/` の内容を活用
- **ファイル配置の正確性**: 指定されたパスに正確に配置
- **段階的テスト**: 各Phase完了時の動作確認必須
- **設定ファイル管理**: 外部サービス設定の適切な管理
- **エラーハンドリング**: AO環境特有のエラー処理パターン適用

この段階的アプローチにより、確実に動作するTruthFi Processが完成し、AO Hackathonでの成功につながります。
```
