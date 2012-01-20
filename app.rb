require './includes'
require './candidate_tweets'
require 'sinatra'

disable :protection

get '/' do
  today_start = Date.today.to_s + " 05:00:00"
  today_end = (Date.today + 1).to_s + " 04:59:59"

  debate_start =  "2012-01-20 01:00:00"
  debate_end = "2012-01-20 03:00:00"

  c = CandidateTweets.new()

  charleston = c.tweets_by_city_and_time_range('Charleston', today_start, today_end)
  columbia = c.tweets_by_city_and_time_range('Columbia', today_start, today_end)
  greenville = c.tweets_by_city_and_time_range('Greenville', today_start, today_end)
  myrtle_beach = c.tweets_by_city_and_time_range('Myrtle Beach', today_start, today_end)

  charleston_debate = c.tweets_by_city_and_time_range('Charleston', debate_start, debate_end)
  columbia_debate = c.tweets_by_city_and_time_range('Columbia', debate_start, debate_end)
  greenville_debate = c.tweets_by_city_and_time_range('Greenville', debate_start, debate_end)
  myrtle_beach_debate = c.tweets_by_city_and_time_range('Myrtle Beach', debate_start, debate_end)

  candidates = [:gingrich, :paul, :romney, :santorum]
  daily_totals = {}
  debate_totals = {}
  candidates.each do |candidate|
    daily_totals[candidate] = charleston[:"#{candidate}_tweets"].count + columbia[:"#{candidate}_tweets"].count + greenville[:"#{candidate}_tweets"].count + myrtle_beach[:"#{candidate}_tweets"].count
    debate_totals[candidate] = charleston_debate[:"#{candidate}_tweets"].count + columbia_debate[:"#{candidate}_tweets"].count + greenville_debate[:"#{candidate}_tweets"].count + myrtle_beach_debate[:"#{candidate}_tweets"].count
  end

  tweet_totals = c.get_candidates_tweets_count

  haml :index, :locals => { :charleston => charleston, :columbia => columbia, :greenville => greenville, :myrtle_beach => myrtle_beach, :charleston_debate => charleston_debate, :columbia_debate => columbia_debate, :greenville_debate => greenville_debate, :myrtle_beach_debate => myrtle_beach_debate, :today_start => today_start, :today_end => today_end, :debate_start => debate_start, :debate_end => debate_end, :daily_totals => daily_totals, :debate_totals => debate_totals, :tweet_totals => tweet_totals }
end