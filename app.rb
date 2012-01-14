require './includes'
require './candidate_tweets'
require 'sinatra'

disable :protection

get '/' do
  today_start = Date.today.to_s + " 05:00:00"
  today_end = (Date.today + 1).to_s + " 04:59:59"

  c = CandidateTweets.new()

  charleston = c.tweets_by_city_and_time_range('Charleston', today_start, today_end)
  columbia = c.tweets_by_city_and_time_range('Columbia', today_start, today_end)
  greenville = c.tweets_by_city_and_time_range('Greenville', today_start, today_end)
  myrtle_beach = c.tweets_by_city_and_time_range('Myrtle Beach', today_start, today_end)

  tweet_totals = c.get_candidates_tweets_count

  haml :index, :locals => { :charleston => charleston, :columbia => columbia, :greenville => greenville, :myrtle_beach => myrtle_beach, :today_start => today_start, :today_end => today_end, :tweet_totals => tweet_totals}
end