# QMP Ranking Generator - Usage Guide / 使用ガイド

This guide explains how to use the QMP Ranking Generator to collect and analyze OpenStreetMap changesets with the #qmp tag.
このガイドでは、#qmpタグ付きのOpenStreetMapチェンジセットを収集・分析するQMP Ranking Generatorの使用方法を説明します。

## 🚀 Quick Start / クイックスタート

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
make all        # すべて自動実行（ダウンロード・抽出・ランキング生成）
make planet     # planetファイルのみダウンロード
make extract    # #qmpチェンジセット抽出（JSONL生成）
make ranking    # ランキング生成（Markdown出力）
make clean      # 生成物のクリーンアップ
```

---

## 📋 Requirements / 必要条件

- **Unix shell** (bash/zsh)
- **Ruby 2.5+**
- **Nokogiri gem** (`gem install nokogiri`)
- **bzcat/bz2cat/pbzcat**（`config.env`の`BZ2_DECOMPRESS_CMD`で指定）
- **planet/changesets-latest.osm.bz2**

### Installing Dependencies / 依存関係のインストール

**macOS:**
```sh
brew install ruby
brew install nokogiri
brew install bzip2 # for bz2cat
```
**Ubuntu/Debian:**
```sh
sudo apt-get update
sudo apt-get install -y ruby ruby-nokogiri bzip2 # for bzcat
```

---

## 🔧 Detailed Usage / 詳細な使用方法

### 1. Download planet file / planetファイルのダウンロード
```sh
make planet
```
### 2. Extract #qmp changesets / #qmpチェンジセット抽出
```sh
make extract
```
### 3. Generate ranking / ランキング生成
```sh
make ranking
```

---

## 🕒 Raspberry Pi & Cron Job Operation / Raspberry Pi・cronジョブ運用

This project is designed for periodic execution on a Raspberry Pi or Linux server using cron jobs. All scripts are intended for local or server-side manual/periodic execution. GitHub Actions and CI/CD automation are not supported.
このプロジェクトはRaspberry Pi等のLinuxサーバーでcronジョブによる定期実行を前提としています。すべてのスクリプトはローカルまたはサーバー上での手動・定期実行を想定しています。GitHub ActionsやCI/CDによる自動化はサポートされません。

---

## 🔍 Troubleshooting / トラブルシューティング

- If the planet file is too large to process, check your server's free disk space and memory.
  planetファイルが大きすぎて処理できない場合は、サーバーの空き容量やメモリを確認してください。
- If #qmp changesets are not extracted, review the extraction command and filter conditions.
  #qmp changesetが抽出されない場合は、抽出コマンドやフィルタ条件を見直してください。
- If you get Ruby/Nokogiri errors, check gem installation and version.
  Ruby/Nokogiriのエラーが出る場合は、依存gemのインストールやバージョンを確認してください。

---

## 🛠️ Customization / カスタマイズ

- Set `BZ2_DECOMPRESS_CMD` in `config.env` according to your OS.
  `config.env` の `BZ2_DECOMPRESS_CMD` をOSに合わせて設定してください。
- You can flexibly customize extraction conditions and output format by editing the Ruby scripts.
  Rubyスクリプトを編集することで、抽出条件や出力フォーマットを柔軟にカスタマイズできます。

---

## 🧪 Test Data / テストデータ

- `test_real_changeset.xml` および `test_real_changeset.xml.bz2` は、スクリプトやワークフローの動作確認・開発用のサンプルチェンジセットです。
- これらは本番ランキングには使用しませんが、抽出・集計スクリプトのテストやデバッグに利用できます。

- `test_real_changeset.xml` and `test_real_changeset.xml.bz2` are sample changeset files for testing and development.
- They are not used for production ranking, but are useful for testing and debugging extraction/aggregation scripts.

---

### BZ2_DECOMPRESS_CMD の設定例 / Example settings

- Linux: `bzcat`
- macOS: `bz2cat`
- BSD系: `pbzcat`

`config.env` の `BZ2_DECOMPRESS_CMD` をご利用のOSに合わせて設定してください。
Set `BZ2_DECOMPRESS_CMD` in `config.env` according to your OS.
