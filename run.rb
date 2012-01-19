require './includes'
require './candidate_tweets'

cities = ['myrtle_beach', 'charleston', 'columbia', 'greenville']
# cities = ['myrtle_beach']

loop do
  begin
    cities.each do |city|
      tweets = CandidateTweets.new(city)
      tweets.write_tally('2012-01-11 05:00:00')
      queries = open('query3.txt').map { |line| line.gsub(/\n/,'') }
      queries.each {|query| tweets.get_tweets(query); sleep 30}
    end
  rescue
    p 'Uh oh! Something went wrong.'
  end
end
