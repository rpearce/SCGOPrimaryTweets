require './includes'
require './candidate_tweets'
require 'sinatra'

disable :protection

get '/' do
  today_start = (Date.today + 1).to_s + " 01:00:00"
  today_end = (Date.today + 1).to_s + " 03:00:00"

  c = CandidateTweets.new()

  charleston = c.tweets_by_city_and_time_range('Charleston', today_start, today_end)
  columbia = c.tweets_by_city_and_time_range('Columbia', today_start, today_end)
  greenville = c.tweets_by_city_and_time_range('Greenville', today_start, today_end)
  myrtle_beach = c.tweets_by_city_and_time_range('Myrtle Beach', today_start, today_end)

  candidates = [:gingrich, :paul, :romney, :santorum]
  daily_totals = {}
  candidates.each do |candidate|
    daily_totals[candidate] = charleston[:"#{candidate}_tweets"].count + columbia[:"#{candidate}_tweets"].count + greenville[:"#{candidate}_tweets"].count + myrtle_beach[:"#{candidate}_tweets"].count
  end

  # daily_percents = {}
  # daily_totals_count = daily_totals
  # candidates.each do |candidate|
  #   daily_percents[candidate] =
  # end

  tweet_totals = c.get_candidates_tweets_count

  haml :index, :locals => { :charleston => charleston, :columbia => columbia, :greenville => greenville, :myrtle_beach => myrtle_beach, :today_start => today_start, :today_end => today_end, :daily_totals => daily_totals, :tweet_totals => tweet_totals}
end