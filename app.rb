require './includes'
require './candidate_tweets'
require 'sinatra'

get '/' do
  today_start = "2012-01-12 11:00:00"
  today_end = "2012-01-13 04:59:59"
  c = CandidateTweets.new()
  charleston = c.tweets_by_city_and_time_range('Charleston', today_start, today_end)
  columbia = c.tweets_by_city_and_time_range('Columbia', today_start, today_end)
  greenville = c.tweets_by_city_and_time_range('Greenville', today_start, today_end)
  myrtle_beach = c.tweets_by_city_and_time_range('Myrtle Beach', today_start, today_end)

  haml :index, :locals => { :charleston => charleston, :columbia => columbia, :greenville => greenville, :myrtle_beach => myrtle_beach, :today_start => today_start, :today_end => today_end}
end