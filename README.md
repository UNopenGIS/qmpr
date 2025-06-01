# 🌍 QMP Ranking Generator / QMP ランキング生成器

**English:**  
Welcome to the **Quick Mapping Project Ranking (QMP Ranking)**!  
This project collects OpenStreetMap changesets with the `#qmp` tag, calculates the total changeset size for each user, and publishes a user ranking on GitHub Pages.

**日本語:**  
**Quick Mapping Project Ranking（QMP ランキング）**へようこそ！  
このプロジェクトは`#qmp`タグ付きのOpenStreetMapチェンジセットを収集し、ユーザーごとの総チェンジセットサイズを計算して、GitHub Pagesでユーザーランキングを公開します。

> 📝 This project is an implementation of [@UNopenGIS/qmp/issues/14](https://github.com/UNopenGIS/qmp/issues/14).  
> 📝 このプロジェクトは[@UNopenGIS/qmp/issues/14](https://github.com/UNopenGIS/qmp/issues/14)の実装です。
> 
> 🤖 **Generated using Claude Sonnet 4 via GitHub Copilot**

---

## 🚀 Quick Start / クイックスタート

**English:**
```sh
make help       # Show all available commands
make check-deps # Check system dependencies  
make test       # Test with sample data
make all        # Download, extract, and generate ranking
```
**日本語:**
```sh
make help       # 利用可能なコマンド一覧
make check-deps # システム依存関係チェック
make test       # サンプルデータでテスト
make all        # ダウンロード・抽出・ランキング生成（全自動）
```

### Individual Commands / 個別コマンド
**English:**
```sh
make planet     # Download planet file only
make extract    # Extract #qmp changesets (JSONL)
make ranking    # Generate ranking (Markdown)
make clean      # Clean generated files
```
**日本語:**
```sh
make planet     # planetファイルのみダウンロード
make extract    # #qmpチェンジセット抽出（JSONL生成）
make ranking    # ランキング生成（Markdown出力）
make clean      # 生成物のクリーンアップ
```

### Prerequisites / 前提条件

**English:**
- Ruby with `nokogiri` gem (`gem install nokogiri`)
- Decompression tool: `bzcat` (Linux), `bz2cat` (macOS), or `pbzcat` (BSD)
- `wget` or `curl` for downloading planet files
- ~8GB disk space for planet file

**日本語:**
- Ruby + `nokogiri` gem（`gem install nokogiri`）
- 展開ツール：`bzcat`（Linux）、`bz2cat`（macOS）、`pbzcat`（BSD）
- planetファイルダウンロード用の`wget`または`curl`
- planetファイル用に約8GBのディスク容量

---

## 🏗️ Architecture Overview / アーキテクチャ概要

- **Data Source / データソース:** [planet/changesets-latest.osm.bz2](https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2)
- **Decompression / 展開:** bzcat, bz2cat, pbzcat (`config.env` の `BZ2_DECOMPRESS_CMD` で指定)
- **Extraction / 抽出:** Ruby + Nokogiri (`scripts/collect_qmp_data.rb`)
- **Aggregation / 集計:** Ruby (`scripts/qmp_ranking.rb`)
- **Automation / 自動化:** Makefile（クロスプラットフォームCLI）
- **Output / 出力:** Markdown（`docs/index.md`）、JSON、CSV
- **Operation / 運用:** ローカル・サーバー（Raspberry PiやLinuxサーバーのcronジョブ推奨）

---

## 📁 File Structure / ファイル構成

```
/
├── README.md              # This file / このファイル
├── USAGE.md               # Usage guide / 使用ガイド
├── PILOT_COPILOT.md       # Development dialog / 開発対話ログ
├── CONTRIBUTING.md        # Contribution guidelines / コントリビューションガイドライン（英日バイリンガル）
├── .gitignore             # Git exclusions / Git除外設定（大容量ファイル等）
├── config.env             # Configuration / 設定ファイル（BZ2_DECOMPRESS_CMD含む）
├── Makefile               # CLI workflow / CLIワークフロー（バイリンガルコメント）
├── scripts/
│   ├── qmp_ranking.rb         # Ruby ranking generator / ランキング生成（planetタイムスタンプ対応）
│   └── collect_qmp_data.rb    # Ruby planet file extraction / planetファイル抽出（2025-05-01日付フィルタ）
├── docs/
│   └── index.md           # Auto-generated ranking / 自動生成ランキング（編集禁止警告付き）
├── data/                  # Data directory / データディレクトリ
│   ├── .gitkeep               # Directory structure preservation / ディレクトリ構造保持
│   ├── changesets-latest.osm.bz2  # Planet file (~7.6GB, reuse recommended) / planetファイル（再利用推奨）
│   └── changesets.jsonl        # Extracted data (JSONL) / 抽出データ（JSONL）
├── test_real_changeset.xml(.bz2)  # Test data / テストデータ
└── .github/copilot-instructions.md # GitHub Copilot config / GitHub Copilot設定
```

---

## 🕒 Operation & Automation / 運用・自動化

- Designed for periodic execution on a Raspberry Pi or Linux server (cron job recommended)  
  Raspberry PiやLinuxサーバーでのcronジョブ定期実行を推奨
- All processing is local and Ruby-based (no API, Python, or CI/CD required)  
  すべてローカル・Rubyベース（API/Python/CI/CD不要）
- Cross-platform: works on macOS, Linux, BSD (set BZ2_DECOMPRESS_CMD in config.env)  
  クロスプラットフォーム対応：macOS, Linux, BSD（`config.env`でBZ2_DECOMPRESS_CMDを設定）
- **Planet file reuse recommended** - The ~7.6GB planet file should be reused for development to avoid repeated downloads  
  **planetファイル再利用推奨** - 約7.6GBのplanetファイルは開発時に再利用し、重複ダウンロードを避けてください

### 📄 GitHub Pages Publication / GitHub Pages公開

**English:**
The generated ranking (`docs/index.md`) is automatically published via GitHub Pages. After running `make ranking`, commit and push the updated file to see the live ranking.

**日本語:**
生成されたランキング（`docs/index.md`）はGitHub Pagesで自動公開されます。`make ranking`実行後、更新されたファイルをコミット・プッシュすることでライブランキングが表示されます。

---

## ⚠️ Important Notes / 重要な注意事項

**English:**
- **QMP Date Filter**: Only processes changesets from 2025-05-01 onwards (QMP start date)
- **Progress Display**: Shows real-time progress every 1000 changesets during extraction
- The changeset size unit is "edited objects count" (nodes, ways, relations)
- `docs/index.md` is auto-generated - do not edit manually
- Planet file timestamp is automatically included in the ranking output
- All legacy files and CI/CD workflows have been removed

**日本語:**
- **QMP日付フィルタ**: 2025-05-01以降（QMP開始日）のチェンジセットのみ処理します
- **進捗表示**: 抽出中に1000チェンジセット毎にリアルタイム進捗を表示します
- チェンジセットサイズの単位は「編集オブジェクト数」（ノード・ウェイ・リレーション）です
- `docs/index.md` は自動生成ファイルのため手動編集は禁止です
- planetファイルのタイムスタンプがランキング出力に自動表示されます
- レガシーファイルとCI/CDワークフローはすべて削除済みです

---

## 🤝 Contribution / コントリビューション

**English:**
- Please open issues or pull requests for improvements or suggestions.
- If you add new features or change the workflow, kindly update the README as well.
- See `CONTRIBUTING.md` for detailed contribution guidelines (bilingual).

**日本語:**
- 改善提案やバグ報告はIssueまたはPull Requestでお願いします。
- 新機能追加やワークフロー変更時はREADMEも更新してください。
- 詳細なコントリビューションガイドライン（英日バイリンガル）は`CONTRIBUTING.md`をご覧ください。

---

## 📄 License / ライセンス

**CC0 1.0 Universal (Public Domain Dedication)**  
このプロジェクトは [CC0ライセンス](https://creativecommons.org/publicdomain/zero/1.0/) で公開されています。  
商用・非商用問わず、自由にコピー・改変・再配布可能です。

---

## 📚 References / 参考リンク

- [changesets-latest.osm.bz2](https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2)
- [GitHub Pages](https://pages.github.com/)
- [QMP Scoreboard Idea (#14)](https://github.com/UNopenGIS/qmp/issues/14)
- [Ruby Programming Language](https://www.ruby-lang.org/)

---

## BZ2_DECOMPRESS_CMD の設定例 / Example settings

- Linux: `bzcat`
- macOS: `bz2cat`
- BSD系: `pbzcat`

`config.env` の `BZ2_DECOMPRESS_CMD` をご利用のOSに合わせて設定してください。
Set `BZ2_DECOMPRESS_CMD` in `config.env` according to your OS。

---

Thank you for your interest and happy mapping! 🌟  
ご覧いただきありがとうございます。楽しいマッピングを！
