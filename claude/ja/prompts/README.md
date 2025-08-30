# TruthFi Process 実装ガイド

## 実行順序

### Phase 0: 前提 Process

0. `phase-0-1-qf-calculator.md` - Quadratic Funding 計算 Process

### Phase 1: 基本システム

1. `phase-1-1-basic-structure.md` - Process 基本構造とニュース管理
2. `phase-1-2-voting-system.md` - USDA 投票システム実装
3. `phase-1-3-usda-pool-management.md` - USDA プール管理機能

### Phase 2: SBT・RandAO

4. `phase-2-1-randao-integration.md` - RandAO 統合と Lucky Number
5. `phase-2-2-sbt-issuance-system.md` - SBT 発行システム

### Phase 3: AI 統合

6. `phase-3-1-apus-ai-integration.md` - Apus AI 判定機能

### Phase 4: 統合・テスト

7. `phase-4-1-system-integration.md` - 全機能統合
8. `phase-4-2-final-testing.md` - 最終テスト

## 出力ファイル

- QF Calculator: `process/src/qf-calculator.lua`
- メイン Process: `process/src/truthfi-core.lua`
- テストファイル: `process/src/tests/`
- ドキュメント: `process/docs/`

## 前提条件

- `/docs/ao-ecosystem/` の参照ドキュメント確認
- AOS 環境セットアップ完了
- テスト用 USDA・AO トークン準備

## Phase 完了チェック

### Phase 0 完了 ✅

- [ ] QF Calculator Process 動作
- [ ] クジラ対策機能
- [ ] 他 Process 連携準備

### Phase 1 完了 ✅

- [ ] 基本投票機能動作
- [ ] USDA 受信・統計更新
- [ ] QF Calculator Process 連携
- [ ] 重複投票防止

### Phase 2 完了 ✅

- [ ] RandAO Lucky Number 取得
- [ ] SBT 発行機能
- [ ] メタデータ設定

### Phase 3 完了 ✅

- [ ] Apus AI 判定結果取得
- [ ] 信頼度パーセンテージ表示

### Phase 4 完了 ✅

- [ ] 全機能統合
- [ ] エラーハンドリング
- [ ] フロントエンド連携準備

## エラー対応

- **Phase 途中でエラー**: 該当 Phase を再実行
- **統合時エラー**: `debug-troubleshooting.md`使用
- **パフォーマンス問題**: `performance-optimization.md`参照

## 補助プロンプト

- `debug-troubleshooting.md` - デバッグ支援
- `performance-optimization.md` - 最適化
- `deployment-preparation.md` - デプロイ準備
