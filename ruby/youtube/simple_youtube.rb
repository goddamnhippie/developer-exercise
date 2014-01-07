require 'open-uri'
require 'nokogiri'

module SimpleYoutube
  BASE_URL = "https://gdata.youtube.com/feeds/api/videos"

  def self.search query, options={ key: ENV['YOUTUBE_DEV_KEY'] }
    key = options[:key]
    max = options[:max] || 3
    doc = Nokogiri::XML open("#{ BASE_URL }?&max-results=#{ max }&key=#{ key }&q=#{ URI.encode query }")

    doc.css('entry link[rel=alternate]').map { |e| e.attr 'href' }
  end
end