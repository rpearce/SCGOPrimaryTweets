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

  candidates = [:gingrich, :paul, :romney, :santorum]
  daily_totals = {}
  candidates.each do |candidate|
    daily_totals[candidate] = charleston[:"#{candidate}_tweets"].count + columbia[:"#{candidate}_tweets"].count + greenville[:"#{candidate}_tweets"].count + myrtle_beach[:"#{candidate}_tweets"].count
  end

  tweet_totals = c.get_candidates_tweets_count

  haml :index, :locals => { :charleston => charleston, :columbia => columbia, :greenville => greenville, :myrtle_beach => myrtle_beach, :today_start => today_start, :today_end => today_end, :daily_totals => daily_totals, :tweet_totals => tweet_totals }
end

get '/custom' do
  custom_start = "2012-01-20 05:00:00"
  custom_end = "2012-01-21 02:00:00"

  c = CandidateTweets.new()

  charleston_custom = c.tweets_by_city_and_time_range('Charleston', custom_start, custom_end)
  columbia_custom = c.tweets_by_city_and_time_range('Columbia', custom_start, custom_end)
  greenville_custom = c.tweets_by_city_and_time_range('Greenville', custom_start, custom_end)
  myrtle_beach_custom = c.tweets_by_city_and_time_range('Myrtle Beach', custom_start, custom_end)

  candidates = [:gingrich, :paul, :romney, :santorum]
  custom_totals = {}
  candidates.each do |candidate|
    custom_totals[candidate] = charleston_custom[:"#{candidate}_tweets"].count + columbia_custom[:"#{candidate}_tweets"].count + greenville_custom[:"#{candidate}_tweets"].count + myrtle_beach_custom[:"#{candidate}_tweets"].count
  end

  tweet_totals = c.get_candidates_tweets_count

  haml :custom, :locals => { :charleston_custom => charleston_custom, :columbia_custom => columbia_custom, :greenville_custom => greenville_custom, :myrtle_beach_custom => myrtle_beach_custom, :custom_start => custom_start, :custom_end => custom_end, :custom_totals => custom_totals, :tweet_totals => tweet_totals }
end