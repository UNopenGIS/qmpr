# 🤖 Pilot ↔ Copilot Development Dialog / パイロット↔コパイロット開発対話

## 📋 Project Summary / プロジェクト概要
**English:**
QMP Ranking Generator - A Ruby-based system to collect OpenStreetMap changesets with `#qmp` hashtags and generate contributor rankings.
**日本語:**
QMP Ranking Generator - RubyでOpenStreetMapの`#qmp`タグ付きチェンジセットを収集し、貢献者ランキングを生成するシステムです。

## ✅ COMPLETED TASKS / 完了タスク

- Migrated to planet/changesets-latest.osm.bz2 streaming and local extraction (no API required)
- Implemented robust hashtag detection (comment/hashtags dual detection)
- Ruby/Nokogiriによる高速ストリーム抽出・JSONL出力
- MakefileによるクロスプラットフォームCLI自動化
- ドキュメント・コマンド例・運用手順を現行モデルに統一
- 不要なAPI/Python/CI/CD/Overpass/旧スクリプト・ディレクトリをすべて削除
- BZ2_DECOMPRESS_CMDでbzcat/bz2cat/pbzcat等に柔軟対応
- 全Markdown/技術ノート/運用ガイドを現行仕様に刷新
- **新規追加 (2025-06-01):**
  - 全ドキュメント（README/USAGE/docs/index.md/PILOT_COPILOT）の英日バイリンガル化完了
  - docs/index.mdの自動生成警告コメント追加
  - チェンジセットサイズの単位（編集オブジェクト数）明記
  - planetファイルタイムスタンプの表示機能追加
  - 不要ファイル・レガシーファイル・CI/CDワークフローの完全削除
  - Makefileコメントのバイリンガル化
  - テストデータの用途説明追加
  - ドキュメント方針の明文化（今後も英日併記統一）
  - **2025-05-01日付フィルタ実装**: QMP開始日以降のチェンジセットのみ処理（効率化）
  - **リアルタイム進捗表示**: 1000チェンジセット毎の処理状況・#qmp発見数表示
  - **Makefile機能拡張**: help, check-deps, test ターゲット追加（エラーハンドリング・依存関係検証）
  - **GitHubリポジトリ準備完了**: .gitignore, CONTRIBUTING.md, data/.gitkeep作成

---

## 🏗️ Architecture (2025-06-01 現在) / アーキテクチャ

- **Data Source / データソース:** planet/changesets-latest.osm.bz2
- **Decompression / 展開:** bzcat, bz2cat, pbzcat (config.envで指定)
- **Extraction / 抽出:** Ruby + Nokogiri (scripts/collect_qmp_data.rb)
- **Aggregation / 集計:** Ruby (scripts/qmp_ranking.rb)
- **Automation / 自動化:** Makefile (planet, extract, ranking, clean)
- **Output / 出力:** Markdown, JSON, CSV
- **Operation / 運用:** Local/server-side (cron job on Raspberry Pi/Linux server)

---

## 🚀 CLI Usage Example / CLI使用例

**English:**
```sh
make all        # Download, extract, and generate ranking
make planet     # Download planet file only
make extract    # Extract #qmp changesets (JSONL)
make ranking    # Generate ranking (Markdown)
make clean      # Clean generated files
```
**日本語:**
```sh
make all        # ダウンロード・抽出・ランキング生成（全自動）
make planet     # planetファイルのみダウンロード
make extract    # #qmpチェンジセット抽出（JSONL生成）
make ranking    # ランキング生成（Markdown出力）
make clean      # 生成物のクリーンアップ
```

---

## 🕒 Operation & Automation / 運用・自動化

- Designed for periodic execution on a Raspberry Pi or Linux server (cron job recommended)  
  Raspberry PiやLinuxサーバーでのcronジョブ定期実行を推奨
- All processing is local and Ruby-based (no API, Python, or CI/CD required)  
  すべてローカル・Rubyベース（API/Python/CI/CD不要）
- Cross-platform: works on macOS, Linux, BSD (set BZ2_DECOMPRESS_CMD in config.env)  
  クロスプラットフォーム対応：macOS, Linux, BSD（`config.env`でBZ2_DECOMPRESS_CMDを設定）

---

## 🤝 Contribution & Development / コントリビューション・開発方針

**English:**
- Always update code and documentation to match the current architecture.
- When adding new features or output formats, update README/USAGE/Makefile as well.
- Prefer explicit nil checks, safe navigation, and meaningful variable names in Ruby.
- All documentation should be bilingual (English/Japanese).

**日本語:**
- コード・ドキュメントは常に現行アーキテクチャに合わせて更新
- 新機能・出力形式追加時はREADME/USAGE/Makefileも必ず更新
- Rubyの明示的なnilチェック・安全なナビゲーション・意味のある変数名を推奨
- すべてのドキュメントは英日バイリンガルで統一

---

## 📁 Current File Structure / 現在のファイル構成

```
/
├── README.md, USAGE.md, PILOT_COPILOT.md  # ドキュメント（完全バイリンガル）
├── config.env                            # 設定ファイル（BZ2_DECOMPRESS_CMD含む）
├── Makefile                              # CLIワークフロー（バイリンガルコメント）
├── scripts/
│   ├── collect_qmp_data.rb               # Ruby抽出スクリプト
│   └── qmp_ranking.rb                    # Rubyランキング生成（planetタイムスタンプ対応）
├── docs/index.md                         # 自動生成ランキング（自動生成警告付き）
├── data/
│   ├── .gitkeep                          # ディレクトリ構造保持ファイル
│   ├── changesets-latest.osm.bz2         # planetファイル（~7.6GB、再利用推奨）
│   └── changesets.jsonl                  # 抽出データ（JSONL）
├── test_real_changeset.xml(.bz2)         # テストデータ（用途明記済み）
├── CONTRIBUTING.md                       # コントリビューションガイド（英日バイリンガル）
├── .gitignore                            # Git管理除外設定（大容量ファイル等）
└── .github/copilot-instructions.md       # GitHub Copilot設定
```

**削除済み不要ファイル:**
- レガシーファイル: `demo_ranking.*`, `qmp_ranking.*`, `test_single_changeset.py`
- 旧シェルスクリプト: `scripts/collect_qmp_data.sh`, `scripts/run_qmp_ranking.sh`
- 未使用データ: `data/changesets.json`, `data/filtered.jsonl`, `data/sample_qmp_data.jsonl`
- CI/CD: `.github/workflows/` ディレクトリ

---

## 🎯 Current Status (2025-06-01) / 現在の状況

### ✅ 完了済み / Completed
- **プラネットファイル取得**: changesets-latest.osm.bz2 (7.6GB) ダウンロード完了
- **抽出スクリプト実行中**: 現在約2500万チェンジセットを処理中（進行中）
- **GitHubリポジトリ準備**: 公開準備完了（.gitignore, CONTRIBUTING.md等）
- **ドキュメント整備**: 全文書の英日バイリンガル化完了

### 🔄 進行中 / In Progress
- **#qmpチェンジセット抽出**: scripts/collect_qmp_data.rb による大規模処理中
- **進捗状況**: 2500万チェンジセット処理済み、まだ実行中

### 📋 次のステップ / Next Steps
1. **抽出完了待ち**: changesets.jsonl の生成完了を待機
2. **ランキング生成**: `make ranking` でMarkdown出力作成
3. **GitHubプッシュ**: リポジトリを GitHub に公開
4. **GitHub Pages設定**: docs/index.md の自動公開設定

---

## 🎯 Recent Improvements (2025-06-01) / 最新改善点

### ドキュメント品質向上
- 全主要Markdownファイルの英日併記徹底（見出し・コマンド例・注意書き・設定例）
- docs/index.mdに「自動生成ファイル・編集禁止」警告追加
- チェンジセットサイズの単位（編集オブジェクト数）明記
- macOS用BZ2_DECOMPRESS_CMD設定例（bz2cat）の強調

### 機能追加・性能向上
- planetファイルタイムスタンプ表示機能（qmp_ranking.rb）
- テストデータの用途・使い方説明追加
- **2025-05-01日付フィルタ**: QMP開始日以降のチェンジセットのみ処理（大幅効率化）
- **リアルタイム進捗表示**: 1000チェンジセット毎の処理状況・#qmp発見数表示
- **Makefile機能拡張**: help, check-deps, test ターゲット追加（エラーハンドリング・依存関係検証）
- **クロスプラットフォーム対応**: wget/curl フォールバック、OS別BZ2_DECOMPRESS_CMD設定

### ファイル構成整理・リポジトリ準備
- 不要ファイル・レガシーファイルの完全削除
- CI/CDワークフローの削除（現行ワークフローに不適合）
- Makefileコメントのバイリンガル化
- **GitHubリポジトリ準備完了**: 
  - .gitignore作成（大容量ファイル除外、docs/index.md保持）
  - CONTRIBUTING.md作成（英日バイリンガル貢献ガイド）
  - data/.gitkeep作成（ディレクトリ構造保持）

---

**Documentation Policy / ドキュメント方針:**
All new documentation and outputs must be bilingual (English/Japanese).
今後もすべての新規ドキュメント・出力は英日併記で統一してください。

**Repository Status / リポジトリ状況:**
Ready for GitHub publication with comprehensive .gitignore, bilingual documentation, and contribution guidelines.
包括的な.gitignore、バイリンガル文書、コントリビューションガイドラインを含む GitHub 公開準備完了。

---

**Generated by / 生成:** 🤖 Claude Sonnet 4 via GitHub Copilot
