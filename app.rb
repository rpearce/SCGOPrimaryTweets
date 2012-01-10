require './includes'

class CandidateTweets
  def initialize(city)
    cities = {'charleston' => '32.7765656,-79.9309216', 'columbia' => '34.0007104,-81.0348144', 'greenville' => '34.8526176,-82.3940104', 'spartanburg' => '34.9495672,-81.9320482'}
    @city = city
    @city_coords = cities[city]

    MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com', 10072)
    MongoMapper.database = 'SCGOPrimary'
    MongoMapper.database.authenticate(ENV['MONGO_USERNAME'], ENV['MONGO_PASSWORD'])
  end

  def get_tweets
    queries = open('query.txt').map { |line| line.gsub(/\n/,'') }
    queries.each {|query| self.search_tweets(query)}
  end

  def search_tweets(query)
    results = []
    num = 15
    page_num = 1
    num.times do
      results += Twitter.search(query, :geocode => @city_coords + ',50mi', :page => page_num, :rpp => 100)
      page_num += 1
    end

    results.each do |result|
      puts result.inspect
      puts result.attrs['from_user'].inspect
      puts
      # tweet = Tweet.create({
      #
      # })
    end

    p 'City: ' + @city.inspect
    p 'Query: ' + query.inspect
    p 'Result count: ' + results.count.inspect
  end
end