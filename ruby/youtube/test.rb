require 'minitest/autorun'
require_relative 'simple_youtube'

class SimpleYoutubeTest < MiniTest::Test
  def setup
    @query = "google"
  end

  def test_returns_three_results_by_default
    results = SimpleYoutube.search @query

    assert_equal 3, results.size
  end

  def test_can_return_more_results
    max_results = 6

    results = SimpleYoutube.search @query, max: max_results

    assert_equal max_results, results.size
  end

  def test_all_results_are_urls
    results = SimpleYoutube.search @query

    assert results.all? { |r| r =~ /^#{ URI::regexp }$/ }
  end
end