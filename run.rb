require './includes'
require './candidate_tweets'

cities = ['columbia', 'charleston','myrtle_beach', 'greenville']
# cities = ['myrtle_beach']

loop do
  begin
    cities.each do |city|
      tweets = CandidateTweets.new(city)
      write_tally = (Time.now.to_s.match(/:\d\d/).to_s.gsub(':','') == '00') || (Time.now.to_s.match(/:\d\d/).to_s.gsub(':','') == '30')
      tweets.write_tally('2012-01-11 05:00:00') if
      queries = open('query.txt').map { |line| line.gsub(/\n/,'') }
      queries.each {|query| tweets.get_tweets(query); sleep 30}
    end
  rescue
    'Uh oh! Something went wrong.'
  end
end
