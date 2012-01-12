require './includes'
require './candidate_tweets'

cities = ['greenville', 'columbia', 'charleston', 'myrtle_beach']
# cities = ['myrtle_beach']

loop do
  begin
    cities.each do |city|
      tweets = CandidateTweets.new(city)
      queries = open('query.txt').map { |line| line.gsub(/\n/,'') }
      queries.each {|query| tweets.get_tweets(query); sleep 100}
    end
  rescue
    'Uh oh! Something went wrong.'
  end
end
