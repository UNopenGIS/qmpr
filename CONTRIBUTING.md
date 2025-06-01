# Contributing to QMP Ranking Generator / QMP ランキング生成器への貢献

**English** | [日本語](#日本語-japanese)

## English

### Getting Started / はじめに

Thank you for your interest in contributing to the QMP Ranking Generator! This project generates rankings of OpenStreetMap contributors participating in the Quality Mapper Project (QMP).

### Prerequisites / 前提条件

- Ruby 3.0+ with Nokogiri gem
- Makefile-compatible environment
- Decompression utility: `bzcat`, `bz2cat`, or `pbzcat`

### Development Workflow / 開発ワークフロー

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/your-username/qmpr.git
   cd qmpr
   ```

2. **Install dependencies**
   ```bash
   gem install nokogiri
   ```

3. **Configure environment**
   ```bash
   cp config.env.example config.env
   # Edit config.env for your OS (set BZ2_DECOMPRESS_CMD)
   ```

4. **Test with sample data**
   ```bash
   make check-deps  # Verify dependencies
   make test        # Run test extraction
   ```

5. **Full workflow (optional - downloads ~7.6GB file)**
   ```bash
   make all         # Download planet, extract, generate ranking
   ```

### Code Guidelines / コードガイドライン

- **Language**: Ruby only (no Python, API calls, or external services)
- **Architecture**: Local processing of OSM planet files
- **Style**: Explicit nil checks, meaningful variable names
- **Documentation**: Bilingual (English/Japanese) comments and docs
- **Testing**: Use test files in the repository for validation

### File Structure / ファイル構造

```
qmpr/
├── scripts/           # Ruby extraction and ranking scripts
├── data/             # Planet files and generated data (git-ignored)
├── docs/             # Generated ranking output (GitHub Pages)
├── Makefile          # CLI workflow automation
├── config.env        # Configuration variables
└── README.md         # Project documentation
```

### Submitting Changes / 変更の提出

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes and test thoroughly
3. Update documentation if needed (both English and Japanese)
4. Submit a pull request with clear description

### Reporting Issues / 課題の報告

- Use GitHub Issues for bug reports and feature requests
- Include your OS, Ruby version, and relevant error messages
- Provide steps to reproduce the issue

---

## 日本語 (Japanese)

[English](#english) | **日本語**

### はじめに / Getting Started

QMP ランキング生成器への貢献にご興味をお持ちいただき、ありがとうございます！このプロジェクトは、Quality Mapper Project (QMP) に参加する OpenStreetMap 貢献者のランキングを生成します。

### 前提条件 / Prerequisites

- Ruby 3.0+ と Nokogiri gem
- Makefile 対応環境
- 解凍ユーティリティ: `bzcat`、`bz2cat`、または `pbzcat`

### 開発ワークフロー / Development Workflow

1. **リポジトリをフォークしてクローン**
   ```bash
   git clone https://github.com/your-username/qmpr.git
   cd qmpr
   ```

2. **依存関係のインストール**
   ```bash
   gem install nokogiri
   ```

3. **環境設定**
   ```bash
   cp config.env.example config.env
   # config.env を編集（OS に応じて BZ2_DECOMPRESS_CMD を設定）
   ```

4. **サンプルデータでテスト**
   ```bash
   make check-deps  # 依存関係の確認
   make test        # テスト抽出の実行
   ```

5. **完全なワークフロー（オプション - 約7.6GBファイルをダウンロード）**
   ```bash
   make all         # プラネット取得、抽出、ランキング生成
   ```

### コードガイドライン / Code Guidelines

- **言語**: Ruby のみ（Python、API 呼び出し、外部サービスは使用しない）
- **アーキテクチャ**: OSM プラネットファイルのローカル処理
- **スタイル**: 明示的な nil チェック、意味のある変数名
- **ドキュメント**: バイリンガル（英語・日本語）コメントと文書
- **テスト**: リポジトリ内のテストファイルを検証に使用

### ファイル構造 / File Structure

```
qmpr/
├── scripts/           # Ruby 抽出・ランキングスクリプト
├── data/             # プラネットファイルと生成データ（git-ignored）
├── docs/             # 生成されたランキング出力（GitHub Pages）
├── Makefile          # CLI ワークフロー自動化
├── config.env        # 設定変数
└── README.md         # プロジェクト文書
```

### 変更の提出 / Submitting Changes

1. フィーチャーブランチを作成: `git checkout -b feature/your-feature`
2. 変更を行い、十分にテスト
3. 必要に応じて文書を更新（英語と日本語の両方）
4. 明確な説明を含むプルリクエストを提出

### 課題の報告 / Reporting Issues

- バグ報告と機能リクエストには GitHub Issues を使用
- OS、Ruby バージョン、関連するエラーメッセージを含める
- 問題を再現する手順を提供

---

### Development Notes / 開発ノート

- The project uses only Ruby and Makefile for cross-platform compatibility
- Planet file processing may take considerable time (millions of changesets)
- Generated rankings are published via GitHub Pages at `/docs/index.md`
- All configuration is done via `config.env` file

このプロジェクトはクロスプラットフォーム互換性のため Ruby と Makefile のみを使用します。プラネットファイル処理には相当な時間がかかる場合があります（数百万の変更セット）。生成されたランキングは `/docs/index.md` の GitHub Pages で公開されます。すべての設定は `config.env` ファイルで行います。
