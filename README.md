# 🌍 QMP Ranking Generator

Welcome to the **Quick Mapping Project Ranking (QMP Ranking)**!  
This project collects OpenStreetMap changesets with the `#qmp` tag, calculates the total changeset size for each user, and publishes a user ranking on GitHub Pages.

> 📝 This project is an implementation of [@UNopenGIS/qmp/issues/14](https://github.com/UNopenGIS/qmp/issues/14).

---

## 🎯 Purpose

- Visualize contributions to the Quick Mapping Project (#qmp) within the OSM community
- Encourage active participation and momentum through a friendly scoreboard
- Keep the data collection and publication workflow simple, transparent, and open

---

## 🏗️ Architecture Overview

### 1. Data Collection

- Use **Overpass API** to download changesets tagged with `#qmp`.
- Fetch data using Unix CLI tools such as `curl`.
- Example command:
    ```sh
    curl -G 'https://overpass-api.de/api/interpreter' \
      --data-urlencode 'data=[out:json];changesets[comment~"#qmp"];out;' \
      -o changesets.json
    ```
- **Tip:** You can also use the OSM [changesets-dump](https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2) for advanced local filtering.

### 2. Data Extraction & Preprocessing

- Use **jq** to extract only the necessary fields (`user`, `num_changes`, `comment`) from the JSON.
- Example command:
    ```sh
    jq -c '.elements[] | {user, num_changes, comment}' changesets.json > filtered.jsonl
    ```

### 3. Data Aggregation & Ranking

- Use a **Ruby script** for:
  - Reading `filtered.jsonl`
  - Filtering to keep only changesets with `#qmp` in the comment
  - Summing up `num_changes` for each user
  - Generating a ranking, and outputting it as a Markdown table

- Output file: `docs/index.md` (for GitHub Pages)

### 4. Publishing

- Publish the ranking by placing `docs/index.md` in the main branch.
- GitHub Pages will automatically serve this as a website.
- Regular updates can be automated with GitHub Actions (for example, nightly or every 12 hours).

---

## 📁 Example File Structure

```
/
├── README.md         # This file
├── scripts/
│   └── qmp_ranking.rb   # Ruby aggregation script
├── docs/
│   └── index.md     # Output ranking (for GitHub Pages)
└── .github/
    └── workflows/
        └── update.yml # (Optional) GitHub Actions for periodic updates
```

---

## 🚀 How to Run

### 1. Requirements

- Unix shell (Bash, Zsh, etc.)
- curl
- jq
- Ruby (2.5 or newer is recommended)

### 2. Download QMP Changesets

```sh
curl -G 'https://overpass-api.de/api/interpreter' \
  --data-urlencode 'data=[out:json];changesets[comment~"#qmp"];out;' \
  -o changesets.json
```

### 3. Extract Required Fields

```sh
jq -c '.elements[] | {user, num_changes, comment}' changesets.json > filtered.jsonl
```

### 4. Aggregate and Generate Markdown

```sh
ruby scripts/qmp_ranking.rb filtered.jsonl
```
- This will create `docs/index.md` containing the latest ranking.

### 5. Publish with GitHub Pages

- Commit and push `docs/index.md` to the main branch.
- GitHub Pages (with `/docs` folder) will automatically publish the website.

---

## 💎 Ruby Aggregation Script Example

```ruby name=scripts/qmp_ranking.rb
#!/usr/bin/env ruby
require 'json'

users = Hash.new(0)

ARGF.each do |line|
  cs = JSON.parse(line)
  next unless cs['comment']&.include?('#qmp')
  users[cs['user']] += cs['num_changes'] || 0
end

sorted = users.sort_by { |_, v| -v }

File.open('docs/index.md', 'w') do |f|
  f.puts "# 🏅 Quick Mapping Project Ranking"
  f.puts ""
  f.puts "| Rank | User | Changeset Size |"
  f.puts "|------|------|----------------|"
  sorted.each_with_index do |(user, size), idx|
    f.puts "| #{idx+1} | #{user} | #{size} |"
  end
end

puts "Ranking written to docs/index.md 🎉"
```

---

## 🔄 Example: Automatic Updates with GitHub Actions

```yaml name=.github/workflows/update.yml
name: Update QMP Ranking

on:
  schedule:
    - cron: '0 */12 * * *' # Run every 12 hours
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install dependencies
        run: sudo apt-get update && sudo apt-get install -y jq ruby

      - name: Download QMP changesets
        run: |
          curl -G 'https://overpass-api.de/api/interpreter' \
            --data-urlencode 'data=[out:json];changesets[comment~"#qmp"];out;' \
            -o changesets.json

      - name: Filter changesets
        run: jq -c '.elements[] | {user, num_changes, comment}' changesets.json > filtered.jsonl

      - name: Generate ranking
        run: ruby scripts/qmp_ranking.rb filtered.jsonl

      - name: Commit and push if changed
        run: |
          git config user.name github-actions
          git config user.email github-actions@github.com
          git add docs/index.md
          git commit -m "Update QMP Ranking" || echo "No changes to commit"
          git push
```

---

## 🤝 Contribution

We welcome contributions!  
- Please feel free to open issues or pull requests for improvements or suggestions.
- If you add new features or change the workflow, kindly update the README as well.

---

## 📄 License

**CC0 1.0 Universal (Public Domain Dedication)**  
This project is released under the [CC0 License](https://creativecommons.org/publicdomain/zero/1.0/).  
You are free to copy, modify, distribute and use the work, even for commercial purposes, without asking permission.

---

## 📚 References

- [Overpass API](https://wiki.openstreetmap.org/wiki/Overpass_API)
- [changesets-latest.osm.bz2](https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2)
- [GitHub Pages](https://pages.github.com/)
- [QMP Scoreboard Idea (#14)](https://github.com/UNopenGIS/qmp/issues/14)

---

Thank you for your interest and happy mapping! 🌟
