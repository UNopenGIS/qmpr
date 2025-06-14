#!/usr/bin/env ruby
require 'json'
require 'time'
require 'csv'
require 'optparse'
require 'fileutils'

# QMP Ranking Generator
# Processes OpenStreetMap changesets with #qmp tag and generates rankings

class QMPRankingGenerator
  def initialize(options = {})
    # QMP開始日（2025年5月1日）以降のchangesetを対象
    @qmp_start_date = Time.new(2025, 5, 1, 0, 0, 0, '+00:00')
    @output_format = options[:format] || 'markdown'
    @output_file = options[:output]
    @users = Hash.new(0)
    @total_changesets = 0
    @filtered_changesets = 0
  end

  def process_file(filename)
    puts "Processing changesets from #{filename}..."
    puts "Processing QMP changesets from #{@qmp_start_date.strftime('%Y-%m-%d')} onwards"

    File.open(filename, 'r') do |file|
      file.each_line do |line|
        @total_changesets += 1
        process_changeset(JSON.parse(line.strip))
      end
    end

    puts "Processed #{@total_changesets} total changesets"
    puts "Found #{@filtered_changesets} QMP changesets since #{@qmp_start_date.strftime('%Y-%m-%d')}"
    puts "Found #{@users.size} unique contributors"
  end

  private

  def process_changeset(changeset)
    # QMPchangesetはすでにcollect_qmp_data.rbで#qmpタグと日付フィルタ済み
    # ここではそのままユーザー別集計のみ実行
    user = changeset['user']
    return unless user
    
    @filtered_changesets += 1
    
    size = changeset['changes_count'] || 0
    @users[user] += size.to_i
  end

  public

  def generate_ranking
    @sorted_users = @users.sort_by { |_, size| -size }

    case @output_format
    when 'json'
      generate_json
    when 'csv'
      generate_csv
    when 'markdown'
      generate_markdown
    else
      puts "Unknown format: #{@output_format}"
      exit 1
    end
  end

  def get_planet_file_timestamp
    planet_file = 'data/changesets-latest.osm.bz2'
    if File.exist?(planet_file)
      File.mtime(planet_file).strftime('%Y-%m-%d %H:%M:%S UTC')
    else
      'Not available'
    end
  end

  private

  def generate_json
    output = {
      meta: {
        generated_at: Time.now.iso8601,
        qmp_start_date: @qmp_start_date.strftime('%Y-%m-%d'),
        total_contributors: @users.size,
        total_changesets: @filtered_changesets
      },
      ranking: @sorted_users.map.with_index do |(user, size), idx|
        {
          rank: idx + 1,
          user: user,
          changeset_size: size
        }
      end
    }

    output_content = JSON.pretty_generate(output)
    write_output(output_content, @output_file || 'qmp_ranking.json')
  end

  def generate_csv
    output_file = @output_file || 'qmp_ranking.csv'
    
    CSV.open(output_file, 'w') do |csv|
      csv << ['rank', 'user', 'changeset_size']
      @sorted_users.each_with_index do |(user, size), idx|
        csv << [idx + 1, user, size]
      end
    end

    puts "CSV ranking written to #{output_file} 📊"
  end

  def generate_markdown
    output_file = @output_file || 'docs/index.md'
    now_str = Time.now.strftime('%Y-%m-%d %H:%M:%S UTC')
    planet_timestamp = get_planet_file_timestamp
    content = <<~MARKDOWN
      <!--
      ⚠️ このファイルは自動生成されています。手動で編集しないでください。
      DO NOT EDIT THIS FILE BY HAND. IT IS AUTO-GENERATED.
      -->

      # 🏅 Quick Mapping Project Ranking / QMP ランキング

      **Generated on / 生成日時:** #{now_str}  
      **Planet file timestamp / Planetファイル日時:** #{planet_timestamp}  
      **Period / 対象期間:** Since QMP start (2025-05-01) / QMP開始日以降（2025年5月1日〜）  
      **Total Contributors / 総貢献者数:** #{@users.size}  
      **Total QMP Changesets / 総QMPチェンジセット数:** #{@filtered_changesets}

      | Rank / 順位 | User / ユーザー | Changeset Size (Objects) / チェンジセットサイズ（編集オブジェクト数） |
      |------|------|----------------|
    MARKDOWN

    @sorted_users.each_with_index do |(user, size), idx|
      content += "| #{idx + 1} | #{user} | #{size} |\n"
    end

    content += <<~MARKDOWN

      ---

      **Note / 注意:**  
      The "Changeset Size" column shows the total number of edited objects (nodes, ways, relations) per user.  
      「チェンジセットサイズ」はユーザーごとの編集オブジェクト数（ノード・ウェイ・リレーションの合計）です。

      This ranking is automatically generated from [planet/changesets-latest.osm.bz2](https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2) using local Ruby scripts.  
      このランキングは [planet/changesets-latest.osm.bz2](https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2) をローカルでRubyスクリプトにより抽出し、定期的に自動生成されています。

      - Operation is recommended as a cron job on Raspberry Pi or Linux server.  
        運用はRaspberry PiやLinuxサーバーでのcronジョブ実行を推奨
      - All processing is local and Ruby-based.  
        すべてローカル処理・Rubyベース
      - GitHub Actions and CI/CD automation are not supported.  
        GitHub ActionsやCI/CDによる自動化はサポートされません

      ---

      *This ranking is automatically generated from OpenStreetMap changesets containing the #qmp tag.*  
      *このランキングは#qmpタグを含むOpenStreetMapチェンジセットから自動生成されています。*

      *Data collected locally from [planet/changesets-latest.osm.bz2](https://planet.openstreetmap.org/planet/changesets-latest.osm.bz2) using Ruby scripts.*  
      *データはplanetファイルをローカルでRubyスクリプトにより抽出しています*

      ## About QMP / QMPについて

      **English:**  
      The Quick Mapping Project (#qmp) encourages rapid, collaborative mapping contributions to OpenStreetMap.  
      Join the community and contribute to make our map data better!

      **日本語:**  
      Quick Mapping Project（#qmp）は、OpenStreetMapへの迅速で協力的なマッピング貢献を奨励します。  
      コミュニティに参加して、より良い地図データの作成に貢献しましょう！

      **Last updated / 最終更新:** #{now_str}
    MARKDOWN

    write_output(content, output_file)
  end

  def write_output(content, filename)
    # Ensure directory exists
    dir = File.dirname(filename)
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

    File.write(filename, content)
    puts "Ranking written to #{filename} 🎉"
  end
end

# Command line interface
if __FILE__ == $0
  options = {}
  
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options] input_file"
    
    opts.on("-f", "--format FORMAT", String, "Output format: markdown, json, csv (default: markdown)") do |f|
      options[:format] = f
    end
    
    opts.on("-o", "--output FILE", String, "Output file path") do |o|
      options[:output] = o
    end
    
    opts.on("-h", "--help", "Show this help") do
      puts opts
      exit
    end
  end.parse!

  if ARGV.empty?
    puts "Error: Please provide an input file"
    puts "Usage: #{$0} [options] input_file"
    exit 1
  end

  input_file = ARGV[0]
  unless File.exist?(input_file)
    puts "Error: Input file '#{input_file}' not found"
    exit 1
  end

  generator = QMPRankingGenerator.new(options)
  generator.process_file(input_file)
  generator.generate_ranking
end
