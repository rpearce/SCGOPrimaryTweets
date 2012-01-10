require './includes'
require './app'

cities = ['charleston', 'columbia', 'greenville', 'spartanburg']

loop do
  cities.each do |city|
    tweets = CandidateTweets.new(city)
    tweets.get_tweets
    sleep 10
  end
end
