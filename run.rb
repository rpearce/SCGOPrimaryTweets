require './includes'
require './candidate_tweets'

cities = ['myrtle_beach', 'greenville', 'charleston', 'columbia']
# cities = ['myrtle_beach']

loop do
  cities.each do |city|
    tweets = CandidateTweets.new(city)
    queries = open('query.txt').map { |line| line.gsub(/\n/,'') }
    queries.each {|query| tweets.get_tweets(query); sleep 100}
  end
end
