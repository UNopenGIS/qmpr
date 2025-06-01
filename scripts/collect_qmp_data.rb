#!/usr/bin/env ruby
# QMP Ranking Generator: planet/changesets-latest.osm.bz2 ストリーム抽出スクリプト
# - 標準入力から OSM changesets XML を受け取り、#qmp changeset のみ JSONL で出力
# - Nokogiri::XML::Reader による高速ストリームパース
# - BZ2_DECOMPRESS_CMD (bzcat/bz2cat/pbzcat) で展開したXMLをパイプで渡すこと
#
# Usage:
#   bzcat changesets-latest.osm.bz2 | ruby scripts/collect_qmp_data.rb > data/changesets.jsonl

require 'nokogiri'
require 'json'
require 'time'

# QMP開始日: 2025年5月1日以降のみ処理
QMP_START_DATE = Time.new(2025, 5, 1, 0, 0, 0, '+00:00')

# 日付フィルタ: QMP開始日以降のchangesetのみ処理
def should_process_changeset?(created_at)
  return false unless created_at
  
  begin
    changeset_date = Time.parse(created_at)
    changeset_date >= QMP_START_DATE
  rescue => e
    $stderr.puts "Warning: Failed to parse date #{created_at}: #{e}"
    false
  end
end

# ハッシュタグ検出（comment/hashtags両対応）
def has_qmp_hashtag?(tags)
  comment = tags['comment']&.downcase || ""
  hashtags = tags['hashtags']&.downcase || ""
  comment.include?('#qmp') || hashtags.include?('#qmp')
end

# XMLストリームパース
reader = Nokogiri::XML::Reader($stdin)
processed_count = 0
qmp_found_count = 0

reader.each do |node|
  next unless node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT && node.name == 'changeset'
  cs_doc = Nokogiri::XML(node.outer_xml)
  cs = cs_doc.at('changeset')
  
  # XMLパース失敗時のスキップ
  next unless cs
  
  # 進捗表示（1000件ごと）
  processed_count += 1
  if processed_count % 1000 == 0
    $stderr.print "Processed: #{processed_count} changesets, Found #qmp: #{qmp_found_count}\r"
    $stderr.flush
  end
  
  # 日付フィルタ: 2025年5月以降のchangesetのみ処理
  created_at = cs['created_at']
  next unless should_process_changeset?(created_at)
  
  tags = {}
  cs.xpath('tag').each do |tag|
    k = tag['k']
    v = tag['v']
    tags[k] = v
  end
  
  # #qmpハッシュタグ検出
  next unless has_qmp_hashtag?(tags)
  
  # #qmp発見時のカウンター増加
  qmp_found_count += 1
  
  out = {
    'id' => cs['id']&.to_i,
    'user' => cs['user'],
    'uid' => cs['uid']&.to_i,
    'created_at' => cs['created_at'],
    'closed_at' => cs['closed_at'],
    'open' => cs['open'] == 'true',
    'min_lat' => cs['min_lat'],
    'min_lon' => cs['min_lon'],
    'max_lat' => cs['max_lat'],
    'max_lon' => cs['max_lon'],
    'changes_count' => cs['changes_count']&.to_i || cs['num_changes']&.to_i || 0,
    'comment' => tags['comment'],
    'hashtags' => tags['hashtags']
  }
  puts out.to_json
end

# 最終統計を標準エラー出力に表示
$stderr.puts "\nProcessing completed!"
$stderr.puts "Total changesets processed: #{processed_count}"
$stderr.puts "QMP changesets found: #{qmp_found_count}"
