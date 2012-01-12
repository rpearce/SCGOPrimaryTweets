require './includes'

class CandidateTweets
  def initialize(city=nil)
    cities = {'charleston' => '32.7765656,-79.9309216', 'columbia' => '34.0007104,-81.0348144', 'greenville' => '34.8526176,-82.3940104', 'myrtle_beach' => '33.71748624018193,-78.892822265625'}
    @city = city
    @city_coords = cities[city]

    MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com', 10072)
    MongoMapper.database = 'SCGOPrimary'
    MongoMapper.database.authenticate('robertwaltonpearce', 'testdb')
    Tweet.ensure_index(:id, :unique => true)
  end

  def get_tweets(query)
    results = []
    results += search_tweets(query)
    post_tweets(results)
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
  end

  def post_tweets(results)
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
        :location_found_within => @city.titleize
      })
    end
  end

  def tweets_by_city_and_time_range(city, start_time, end_time)
    santorum = []
    perry = []
    paul = []
    romney = []
    gingrich = []
    huntsman = []
    start_time = start_time.to_time
    end_time = end_time.to_time
    all_tweets_found = Tweet.where(:location_found_within => city, :created_at => {'$gt' => start_time, '$lt' => end_time}).sort(:created_at.asc)
    all_tweets_found.each do |tweet|
      if tweet.text.match('Santorum') || tweet.text.match('santorum')
        santorum.push tweet
      elsif tweet.text.match('Perry') || tweet.text.match('perry')
        perry.push tweet
      elsif tweet.text.match('Paul') || tweet.text.match('paul')
        paul.push tweet
      elsif tweet.text.match('Romney') || tweet.text.match('romney')
        romney.push tweet
      elsif tweet.text.match('Gingrich') || tweet.text.match('gingrich')
        gingrich.push tweet
      elsif tweet.text.match('Huntsman') || tweet.text.match('huntsman')
        huntsman.push tweet
      else
        ''
      end
      p 'Location found within: ' + tweet.location_found_within.inspect
      p 'Username: ' + tweet.from_user.inspect
      p 'Tweet Id: ' + tweet.id.inspect
      p 'Created at: ' + tweet.created_at.inspect
    end
    p 'Santorum: ' + santorum.count.inspect
    p 'Perry: ' + perry.count.inspect
    p 'Paul: ' +  paul.count.inspect
    p 'Romney: ' + romney.count.inspect
    p 'Gingrich: ' + gingrich.count.inspect
    p 'Huntsman: ' + huntsman.count.inspect
    p "Total Count for #{city}: " + all_tweets_found.count.inspect
  end

  # def retrieve_tweets(city)
  #   santorum = []
  #   perry = []
  #   paul = []
  #   romney = []
  #   gingrich = []
  #   huntsman = []
  #   all_tweets_for_city = Tweet.where(:location_found_within => city).all
  #   all_tweets_for_city.each do |tweet|
  #     if tweet.text.match('Santorum') || tweet.text.match('santorum')
  #       santorum.push tweet
  #     elsif tweet.text.match('Perry') || tweet.text.match('perry')
  #       perry.push tweet
  #     elsif tweet.text.match('Paul') || tweet.text.match('paul')
  #       paul.push tweet
  #     elsif tweet.text.match('Romney') || tweet.text.match('romney')
  #       romney.push tweet
  #     elsif tweet.text.match('Gingrich') || tweet.text.match('gingrich')
  #       gingrich.push tweet
  #     elsif tweet.text.match('Huntsman') || tweet.text.match('huntsman')
  #       huntsman.push tweet
  #     else
  #       ''
  #     end
  #   end
  #   p 'Santorum: ' + santorum.count.inspect
  #   p 'Perry: ' + perry.count.inspect
  #   p 'Paul: ' +  paul.count.inspect
  #   p 'Romney: ' + romney.count.inspect
  #   p 'Gingrich: ' + gingrich.count.inspect
  #   p 'Huntsman: ' + huntsman.count.inspect
  # end
end