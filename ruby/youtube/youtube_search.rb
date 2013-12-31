require 'youtube_it'

DEVELOPER_KEY = ENV['YOUTUBE_KEY']

client = YouTubeIt::Client.new dev_key: DEVELOPER_KEY
results = client.videos_by query: ARGV[0]

results.videos[0..2].each { |v| puts v.player_url }