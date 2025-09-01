# TruthFi AO Process 要件定義書

## 1. プロジェクト概要

### 1.1 システム名

TruthFi - 分散型フェイクニュース投票プラットフォーム

### 1.2 目的

AO エコシステム上で動作する、ユーザーがニュースの真偽を投票し、AI の判断と比較できる分散型プラットフォームの構築

### 1.3 スコープ

MVP（最小実行可能製品）として、単一のニュースアイテムに対する投票機能を実装

## 2. 機能要件

### 2.1 投票システム

#### 2.1.1 基本投票機能

- **投票受付**: ユーザーからの True/False 投票を受け付ける
- **デポジット処理**: 1 投票につき 1 USDA の固定デポジット
- **投票記録**: ユーザーの投票履歴を永続的に保存
- **重複投票防止**: 同一ユーザーによる同一ニュースへの重複投票を制限

#### 2.1.2 投票統計

- **リアルタイム集計**: True/False 投票数のリアルタイム更新
- **投票率計算**: 全体の投票傾向をパーセンテージで表示
- **ユーザー統計**: 個人の投票履歴と成績を管理

### 2.2 SBT（Soul Bound Token）発行

#### 2.2.1 トークン生成

- **自動発行**: 投票完了時に自動的に SBT を発行
- **メタデータ**: 投票内容、日時、ラッキーナンバーを含む
- **譲渡不可**: SBT の譲渡を技術的に制限

#### 2.2.2 ラッキーナンバー

- **RandAO 統合**: 分散型乱数生成によるラッキーナンバー付与
- **範囲設定**: 1-10000 の範囲内でランダム生成
- **一意性保証**: 各 SBT に固有のナンバーを付与

### 2.3 AI 分析統合

#### 2.3.1 Apus AI 連携

- **信頼度スコア**: 0-1 のスケールでニュース真偽の信頼度を算出
- **非同期処理**: AI 分析結果の非同期取得と表示
- **キャッシュ機能**: 同一ニュースの分析結果をキャッシュ

#### 2.3.2 結果比較

- **ユーザー vs AI**: ユーザー投票と AI 判断の比較表示
- **精度計算**: ユーザーの判断精度を計算・記録

### 2.4 USDA トークン管理

#### 2.4.1 デポジット処理

- **残高確認**: 投票前の USDA 残高チェック
- **送金処理**: プロセスへの 1 USDA 送金
- **エラーハンドリング**: 残高不足時の適切なエラー処理

#### 2.4.2 報酬システム（将来拡張）

- **正解報酬**: 正しい判断をしたユーザーへの報酬配分
- **プール管理**: デポジットプールの管理

## 3. 非機能要件

### 3.1 パフォーマンス

- **レスポンス時間**: 投票処理は 3 秒以内に完了
- **同時接続**: 最低 100 ユーザーの同時投票に対応
- **スケーラビリティ**: 将来的な拡張に対応可能な設計

### 3.2 セキュリティ

- **入力検証**: すべての入力データの厳格な検証
- **状態管理**: 不正な状態遷移の防止
- **権限管理**: 管理者機能への適切なアクセス制御

### 3.3 可用性

- **エラー処理**: グレースフルデグラデーション
- **状態復旧**: 異常終了時の状態復旧機能
- **ログ記録**: 詳細なエラーログの記録

### 3.4 保守性

- **コード品質**: Lua ベストプラクティスの遵守
- **モジュール化**: 機能ごとのモジュール分割
- **テスト容易性**: ユニットテストの実装

## 4. 技術要件

### 4.1 開発環境

- **言語**: Lua 5.3+
- **プラットフォーム**: AO Network
- **開発ツール**: AOS CLI

### 4.2 外部依存関係

- **USDA Contract**: AO ブリッジ経由の USDA トークン
- **RandAO Module**: `@randao/random`パッケージ
- **Apus AI SDK**: Apus 推論サービス API
- **Atomic Assets**: SBT 実装用フレームワーク

### 4.3 データ構造

```lua
State = {
    -- アクティブなニュース
    active_news = {
        id = "news_001",
        title = "Celebrity Marriage News",
        content = "...",
        created_at = timestamp,
        voting_deadline = timestamp
    },

    -- 投票統計
    voting_stats = {
        news_001 = {
            true_votes = 0,
            false_votes = 0,
            total_deposits = 0
        }
    },

    -- ユーザー投票記録
    user_votes = {
        [user_address] = {
            news_001 = {
                vote = "true",
                timestamp = timestamp,
                deposit = 1,
                sbt_id = "sbt_001"
            }
        }
    },

    -- SBTトークン
    sbt_tokens = {
        sbt_001 = {
            owner = user_address,
            news_id = "news_001",
            vote = "true",
            lucky_number = 7777,
            created_at = timestamp
        }
    },

    -- AI分析結果
    ai_analysis = {
        news_001 = {
            confidence = 0.85,
            verdict = "fake",
            analyzed_at = timestamp
        }
    }
}
```

## 5. インターフェース仕様

### 5.1 メッセージハンドラー

#### 投票ハンドラー

```lua
-- Input
{
    Action = "Vote",
    NewsId = "news_001",
    Vote = "true" | "false",
    From = user_address
}

-- Output
{
    Status = "success" | "error",
    Message = "Vote recorded",
    SbtId = "sbt_001",
    LuckyNumber = 7777
}
```

#### 統計取得ハンドラー

```lua
-- Input
{
    Action = "GetStats",
    NewsId = "news_001"
}

-- Output
{
    TrueVotes = 150,
    FalseVotes = 50,
    TruePercentage = 75,
    AIConfidence = 0.85,
    AIVerdict = "fake"
}
```

#### SBT 照会ハンドラー

```lua
-- Input
{
    Action = "GetUserSBT",
    User = user_address
}

-- Output
{
    Sbts = [
        {
            Id = "sbt_001",
            NewsId = "news_001",
            Vote = "true",
            LuckyNumber = 7777,
            CreatedAt = timestamp
        }
    ]
}
```

## 6. テスト要件

### 6.1 単体テスト

- 各ハンドラーの正常系テスト
- エラーケースのテスト
- 境界値テスト

### 6.2 統合テスト

- 完全な投票フロー
- 外部サービス連携
- 並行処理テスト

## 7. 実装フェーズ

### Phase 1: 基本構造と USDA 投票

- プロセス基本構造の実装
- USDA 投票機能の実装
- 基本的な状態管理

### Phase 2: RandAO と SBT

- RandAO 統合
- SBT 発行機能
- メタデータ管理

### Phase 3: Apus AI 統合

- AI 分析連携
- 結果比較機能
- キャッシュ実装

### Phase 4: システム統合とテスト

- 全機能の統合
- 包括的なテスト
- デプロイメント準備

## 8. 制約事項

### 8.1 技術的制約

- AO Network の制限事項に準拠
- Lua 言語の制約内での実装
- 非同期処理の制限

### 8.2 ビジネス制約

- MVP 段階では単一ニュースのみ
- 固定デポジット額（1 USDA）
- バイナリ投票（True/False）のみ
