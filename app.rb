require 'rubygems'
require 'twitter'
# require 'json'

class CandidateTweets

  def initialize(city)
    cities = {'charleston' => '32.7765656,-79.9309216', 'columbia' => '34.0007104,-81.0348144', 'greenville' => '34.8526176,-82.3940104', 'spartanburg' => '34.9495672,-81.9320482'}
    @city = city
    @city_coords = cities[city]
  end

  def get_tweets
    file = File.open("query.txt", 'r')
    query = file.readlines.to_s

    # Search for tweets in certain location(s) using search query
    # Can only read 100/page
    # Can only read 1500 max
    results = []
    num = 15
    page_num = 1
    num.times do
      results += Twitter.search(query, :geocode => @city_coords + ',20mi', :page => page_num, :rpp => 100)
      page_num += 1
    end

    results.each {|result| puts result.inspect; puts}

    p 'City: ' + @city.inspect
    p 'Query: ' + query.inspect
    p 'Result count: ' + results.count.inspect
  end
end