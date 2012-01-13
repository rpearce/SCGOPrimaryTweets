require './includes'

class CandidateTweets
  CSV_FILE_PATH = File.join(File.dirname(__FILE__), "csv/raw_data_2012-01-12.csv")

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
      t = tweet.text
      santorum.push tweet if t.match(/(S|s)antorum/)
      perry.push tweet if t.match(/(P|p)erry/)
      paul.push tweet if t.match(/(P|p)aul/) || t.match(/(R|r)on/)
      romney.push tweet if t.match(/(R|r)omney/) || t.match(/(M|m)itt/)
      gingrich.push tweet if t.match(/(G|g)ingrich/) || t.match(/(N|n)ewt/)
      huntsman.push tweet if t.match(/(H|h)untsman/)
    end

    all = santorum + perry + paul + romney + gingrich + huntsman
    unique_tweets = all.uniq
    unique_tweets.each do |tweet|
      write_to_raw_data_csv(tweet)
    end

    p 'Santorum: ' + santorum.count.inspect
    p 'Perry: ' + perry.count.inspect
    p 'Paul: ' +  paul.count.inspect
    p 'Romney: ' + romney.count.inspect
    p 'Gingrich: ' + gingrich.count.inspect
    p 'Huntsman: ' + huntsman.count.inspect
    p "Total Count for #{city}: " + unique_tweets.count.inspect
    tweets = {:santorum_tweets => santorum, :perry_tweets => perry, :paul_tweets => paul, :romney_tweets => romney, :gingrich_tweets => gingrich, :huntsman_tweets => huntsman}
    tweets
  end

  def write_to_raw_data_csv(tweet)
    CSV.open(CSV_FILE_PATH, "a") do |csv|
      csv << %W[#{tweet.location_found_within} #{tweet.from_user} #{tweet.id} #{tweet.created_at} #{tweet.text}]
    end
  end
end