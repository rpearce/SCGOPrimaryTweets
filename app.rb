require './includes'

class CandidateTweets
  def initialize(city)
    cities = {'charleston' => '32.7765656,-79.9309216', 'columbia' => '34.0007104,-81.0348144', 'greenville' => '34.8526176,-82.3940104', 'spartanburg' => '34.9495672,-81.9320482'}
    @city = city
    @city_coords = cities[city]

    MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com', 10072)
    MongoMapper.database = 'SCGOPrimary'
    MongoMapper.database.authenticate('robertwaltonpearce', 'testdb')
    Tweet.ensure_index(:id, :unique => true)
  end

  def get_tweets
    queries = open('query.txt').map { |line| line.gsub(/\n/,'') }
    results = []
    queries.each {|query| results += self.search_tweets(query)}

    results.each do |result|
      puts result.inspect
      tweet = Tweet.create({
        :created_at => result.attrs['created_at'],
        :entities => result.attrs['entities'],
        :from_user => result.attrs['from_user'],
        :from_user_id => result.attrs['from_user_id'],
        :from_user_id_str => result.attrs['from_user_id_str'],
        :from_user_name => result.attrs['from_user_name'],
        :geo => result.attrs['geo'],
        :location => result.attrs['location'],
        :id => result.attrs['id'],
        :id_str => result.attrs['id_str'],
        :iso_language_code => result.attrs['iso_language_code'],
        :metadata => result.attrs['metadata'],
        :profile_image_url => result.attrs['profile_image_url'],
        :profile_image_url_https => result.attrs['profile_image_url_https'],
        :source => result.attrs['source'],
        :text => result.attrs['text'],
        :to_user => result.attrs['to_user'],
        :to_user_id => result.attrs['to_user_id'],
        :to_user_id_str => result.attrs['to_user_id_str'],
        :to_user_name => result.attrs['to_user_name'],
        :location_found_within => result.attrs['location_found_within']
      })
    end
  end

  def search_tweets(query)
    results = []
    num = 15
    page_num = 1
    num.times do
      results += Twitter.search(query, :geocode => @city_coords + ',50mi', :page => page_num, :rpp => 100, :include_entities => 1)
      page_num += 1
    end
    results
    # p 'City: ' + @city.inspect
    # p 'Query: ' + query.inspect
    # p 'Result count: ' + results.count.inspect
  end
end