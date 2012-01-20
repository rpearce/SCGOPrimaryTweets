require './includes'

class CandidateTweets
  CSV_FILE_PATH = File.join(File.dirname(__FILE__), "csv/raw_data_2012-01-13.csv")

  def initialize(city=nil)
    cities = {'charleston' => '32.7765656,-79.9309216', 'columbia' => '34.0007104,-81.0348144', 'greenville' => '34.8526176,-82.3940104', 'myrtle_beach' => '33.71748624018193,-78.892822265625'}
    @city = city
    @city_coords = cities[city]

    MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com', 10072)
    MongoMapper.database = 'SCGOPrimary'
    MongoMapper.database.authenticate('robertwaltonpearce', 'testdb')
    Tweet.ensure_index(:id, :unique => true)
    Tweet.ensure_index(:created_at)
    Tally.ensure_index(:created_at)
    # StreamingTweet.ensure_index(:id, :unique => true)
    # StreamingTweet.ensure_index(:created_at)

    TweetStream.configure do |config|
      config.username    = 'SCPrimaryTrack'
      config.password    = 'RandomPassword123'
      config.auth_method = :basic
      # config.parser      = :yajl
    end
  end

  def get_tweets(query)
    results = []
    results += search_tweets(query)
    post_tweets(results)
  end

  def get_streaming_tweets
    # TweetStream::Client.new.filter({:track => ['gingrich', 'newtgingrich', 'Newt2012', 'Rep.Gingrich', 'Mitt', 'Romney', 'GovernorRomney', 'MittRomney', 'Mitt2012', 'Santorum', 'RickSantorum', 'WePickRick', 'RickPerry', 'GovernorPerry', 'GovPerry', 'Gov.Perry', 'Perry', 'Perry2012', 'RonPaul', 'RepPaul', 'Rep.Paul', 'RepresentativePaul']}).locations(-80.2979299,32.524896,-79.3579419,33.192843) do |tweet|
    TweetStream::Client.new.filter({"locations" => [-80.277979,32.530074,-79.3657943,33.1407154]}) do |tweet|
      p tweet.inspect
      p tweet['location'].inspect
      # StreamingTweet.create({:id => tweet.id, :text => tweet.text})
    end
  end

  def search_tweets(query)
    results = []
    num = 15
    page_num = 1
    num.times do
      results += Twitter.search(query, :geocode => @city_coords + ',50mi', :page => page_num, :rpp => 100, :include_entities => 1, :since_id => 160061124102995968)
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
    paul = []
    romney = []
    gingrich = []
    start_time = start_time.to_time
    end_time = end_time.to_time
    all_tweets_found = Tweet.where(:location_found_within => city, :created_at => {'$gt' => start_time, '$lt' => end_time}).sort(:created_at.asc)
    all_tweets_found.each do |tweet|
      t = tweet.text
      santorum.push tweet if t.match(/(S|s)antorum/)
      paul.push tweet if t.match(/(P|p)aul/) || t.match(/(R|r)on/)
      romney.push tweet if t.match(/(R|r)omney/) || t.match(/(M|m)itt/)
      gingrich.push tweet if t.match(/(G|g)ingrich/) || t.match(/(N|n)ewt/)
    end

    all = santorum + paul + romney + gingrich
    unique_tweets = all.uniq
    # CSV left commented until I want to write to the CSV.
    # unique_tweets.each do |tweet|
    #   write_to_raw_data_csv(tweet)
    # end

    tweets = {:santorum_tweets => santorum, :paul_tweets => paul, :romney_tweets => romney, :gingrich_tweets => gingrich, :unique_tweets => unique_tweets}
    tweets
  end

  def get_candidates_tweets_count
    tally = Tally.last(:order => :created_at.asc)
    tweet_totals = {:santorum_total => tally[:santorum_total], :paul_total => tally[:paul_total], :romney_total => tally[:romney_total], :gingrich_total => tally[:gingrich_total]}
    tweet_totals
  end

  def write_tally(start_time)
    santorum = []
    paul = []
    romney = []
    gingrich = []
    start_time = start_time.to_time
    tweets = Tweet.where(:created_at => {'$gt' => start_time})
    tweets.each do |tweet|
      t = tweet.text
      santorum.push tweet if t.match(/(S|s)antorum/)
      paul.push tweet if t.match(/(P|p)aul/) || t.match(/(R|r)on/)
      romney.push tweet if t.match(/(R|r)omney/) || t.match(/(M|m)itt/)
      gingrich.push tweet if t.match(/(G|g)ingrich/) || t.match(/(N|n)ewt/)
    end

    Tally.create({
      :created_at => Time.now,
      :gingrich_total => gingrich.length,
      :paul_total => paul.length,
      :romney_total => romney.length,
      :santorum_total => santorum.length
    })

  end

  def write_to_raw_data_csv(tweet)
    CSV.open(CSV_FILE_PATH, "a") do |csv|
      csv << %W[#{tweet.location_found_within} #{tweet.from_user} #{tweet.id} #{tweet.created_at} #{tweet.text}]
    end
  end
end