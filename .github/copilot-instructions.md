# 🤖 GitHub Copilot Instructions for QMP Ranking Generator

## 📋 Project Overview
**QMP Ranking Generator** is a Ruby-based system for collecting OpenStreetMap changesets tagged with `#qmp` hashtags and generating contributor rankings.

## 🏗️ Architecture & Technologies

- **Language**: Ruby (core logic, XML streaming, and data extraction)
- **Data Source**: [planet/changesets-latest.osm.bz2](https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2)
- **Decompression**: bzcat, bz2cat, pbzcat (set via `BZ2_DECOMPRESS_CMD` in config.env)
- **Extraction**: Ruby + Nokogiri (scripts/collect_qmp_data.rb)
- **Aggregation**: Ruby (scripts/qmp_ranking.rb)
- **Automation**: Makefile (cross-platform CLI)
- **Output**: Markdown, JSON, CSV
- **Operation**: Local/server-side (cron job on Raspberry Pi/Linux server)

## 🚀 CLI Usage Example

```sh
make all        # Download, extract, and generate ranking
make planet     # Download planet file only
make extract    # Extract #qmp changesets (JSONL)
make ranking    # Generate ranking (Markdown)
make clean      # Clean generated files
```

## 🎯 Development Guidelines

- Prefer explicit nil checks and safe navigation in Ruby
- Use meaningful variable names (e.g., has_qmp_hashtag)
- All code and docs should be bilingual (English/Japanese)
- Document any new workflow or output format in README/USAGE
- No API/Python/CI/CD/Overpass/old scripts: all logic is Ruby+Makefile+planetファイル

---
