require './includes'
require './candidate_tweets'


begin
    # query = File.open('streaming_query.txt', 'rb') { |file| file.read }
    # puts query.inspect
    c = CandidateTweets.new(nil, query)
rescue
  p 'Uh oh! Something went wrong.'
end
