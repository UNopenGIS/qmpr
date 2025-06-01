# QMP Ranking Generator Makefile / QMPランキング生成用Makefile
#
# All targets are documented in both English and Japanese.
# すべてのターゲットは英語・日本語で説明されています。

# 設定ファイルから BZ2_DECOMPRESS_CMD を取得
include config.env

PLANET=data/changesets-latest.osm.bz2
JSONL=data/changesets.jsonl
RANKING_MD=docs/index.md

.PHONY: all planet extract ranking clean help test check-deps stream

# Show help / ヘルプ表示
help:
	@echo "🏅 QMP Ranking Generator / QMPランキング生成器"
	@echo ""
	@echo "Available targets / 利用可能なターゲット:"
	@echo "  help       - Show this help message / このヘルプを表示"
	@echo "  check-deps - Check dependencies / 依存関係チェック"
	@echo "  test       - Test with sample data / サンプルデータでテスト"
	@echo "  all        - Download, extract, and generate ranking / 全自動実行"
	@echo "  planet     - Download planet file / planetファイルダウンロード"
	@echo "  extract    - Extract #qmp changesets / #qmpチェンジセット抽出"
	@echo "  ranking    - Generate ranking / ランキング生成"
	@echo "  stream     - Direct download→extract pipeline / 直接ダウンロード→抽出パイプライン"
	@echo "  clean      - Clean generated files / 生成物削除"
	@echo ""
	@echo "Configuration / 設定:"
	@echo "  BZ2_DECOMPRESS_CMD = $(BZ2_DECOMPRESS_CMD)"
	@echo ""

# Download the latest planet file (if not present)
# 最新のplanetファイルをダウンロード（存在しない場合のみ）
planet:
	@echo "🌍 Downloading planet/changesets-latest.osm.bz2 ..."
	@if [ ! -f $(PLANET) ]; then \
		if command -v wget >/dev/null 2>&1; then \
			wget -O $(PLANET) https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2; \
		elif command -v curl >/dev/null 2>&1; then \
			curl -L -o $(PLANET) https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2; \
		else \
			echo "❌ Error: Neither wget nor curl found. Please install one of them."; \
			exit 1; \
		fi \
	else \
		echo "✅ Planet file already exists: $(PLANET)"; \
	fi

# Extract #qmp changesets (JSONL)
# #qmpチェンジセット抽出（JSONL生成）
extract: $(PLANET)
	@echo "🔍 Extracting #qmp changesets ..."
	@if [ ! -f $(PLANET) ]; then \
		echo "❌ Error: Planet file not found. Run 'make planet' first."; \
		exit 1; \
	fi
	bash -c '$(BZ2_DECOMPRESS_CMD) $(PLANET) | ruby scripts/collect_qmp_data.rb > $(JSONL)'
	@echo "✅ Extraction completed. Results saved to $(JSONL)"

# Generate ranking (Markdown for GitHub Pages)
# ランキング生成（GitHub Pages用Markdown）
ranking: $(JSONL)
	@echo "📊 Generating ranking ..."
	@if [ ! -f $(JSONL) ]; then \
		echo "❌ Error: No changeset data found. Run 'make extract' first."; \
		exit 1; \
	fi
	@if [ ! -s $(JSONL) ]; then \
		echo "⚠️  Warning: Changeset data file is empty. No #qmp changesets found."; \
	fi
	ruby scripts/qmp_ranking.rb $(JSONL)
	@echo "✅ Ranking generated: $(RANKING_MD)"

# Clean generated files
# 生成物のクリーンアップ
clean:
	@echo "🧹 Cleaning generated files ..."
	rm -f $(JSONL) $(RANKING_MD)

# Stream processing: download, decompress, and extract in one pipeline
# ストリーム処理：ダウンロード・解凍・抽出を一つのパイプラインで実行
stream:
	@echo "🚀 Starting stream processing: download → decompress → extract ..."
	@echo "⚠️  This will download ~7.6GB and process directly without saving planet file"
	@echo "⚠️  これにより約7.6GBをダウンロードし、planetファイルを保存せずに直接処理します"
	@echo "💡 This is faster and saves disk space compared to 'make all'"
	@echo "💡 'make all'より高速で、ディスク容量を節約できます"
	@echo ""
	@if command -v curl >/dev/null 2>&1; then \
		echo "🌍 Downloading and processing changesets-latest.osm.bz2 via curl..."; \
		curl -L -# https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2 | bunzip2 | ruby scripts/collect_qmp_data.rb > $(JSONL); \
	elif command -v wget >/dev/null 2>&1; then \
		echo "🌍 Downloading and processing changesets-latest.osm.bz2 via wget..."; \
		wget --progress=bar -O - https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2 | bunzip2 | ruby scripts/collect_qmp_data.rb > $(JSONL); \
	else \
		echo "❌ Error: Neither curl nor wget found. Please install one of them."; \
		exit 1; \
	fi
	@echo "✅ Stream processing completed. Results saved to $(JSONL)"
	@echo "📊 Generated JSONL contains $$(wc -l < $(JSONL)) QMP changesets"

# All-in-one: download, extract, and generate ranking
# 一括実行：ダウンロード・抽出・ランキング生成
all: planet extract ranking

# Test with sample data / サンプルデータでテスト
test:
	@echo "🧪 Testing with sample data ..."
	@echo "Testing extraction script:"
	@cat test_real_changeset.xml | ruby scripts/collect_qmp_data.rb > test_output.jsonl
	@echo "✅ Test extraction completed. Found $$(wc -l < test_output.jsonl) changesets."
	@echo "Testing ranking generation:"
	@ruby scripts/qmp_ranking.rb test_output.jsonl
	@echo "✅ Test completed. Cleaning up test files ..."
	@rm -f test_output.jsonl docs/index.md
	@echo "✅ Test cleanup completed."

# Check dependencies / 依存関係チェック
check-deps:
	@echo "🔍 Checking dependencies ..."
	@command -v ruby >/dev/null 2>&1 || { echo "❌ Ruby not found"; exit 1; }
	@ruby -e "require 'nokogiri'" 2>/dev/null || { echo "❌ Nokogiri gem not found. Run: gem install nokogiri"; exit 1; }
	@ruby -e "require 'json'" 2>/dev/null || { echo "❌ JSON gem not found"; exit 1; }
	@command -v $(BZ2_DECOMPRESS_CMD) >/dev/null 2>&1 || { echo "❌ $(BZ2_DECOMPRESS_CMD) not found"; exit 1; }
	@echo "✅ All dependencies are installed"
