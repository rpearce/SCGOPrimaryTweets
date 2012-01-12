class RunApplication
  require './includes'
  require './candidate_tweets'

  def initialize
    @cities = ['greenville', 'charleston', 'columbia', 'myrtle_beach']
    # cities = ['myrtle_beach']
  end

  def run
    loop do
      begin
        @cities.each do |city|
          tweets = CandidateTweets.new(city)
          queries = open('query.txt').map { |line| line.gsub(/\n/,'') }
          queries.each {|query| tweets.get_tweets(query); sleep 100}
        end
      rescue
        p 'Uh oh! Something went wrong.'
      end
    end
  end
end