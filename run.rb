require './includes'
require './candidate_tweets'

cities = ['charleston', 'columbia', 'greenville', 'spartanburg']

loop do
  cities.each do |city|
    tweets = CandidateTweets.new(city)
    tweets.get_tweets
    sleep 30
  end
end
