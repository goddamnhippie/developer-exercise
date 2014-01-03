require 'youtube_it'

query   = ARGV.join(' ')
client  = YouTubeIt::Client.new dev_key: ENV['YOUTUBE_KEY']
results = client.videos_by query: query

puts "Searched: #{ query }"

results.videos[0..2].each { |v| puts v.player_url }