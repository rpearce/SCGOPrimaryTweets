require 'rubygems'
require 'twitter'
require 'tweetstream'
require 'json'
require 'mongo'
require 'mongo_mapper'
require 'csv'
require 'date'
require './tweet'
require './streaming_tweet'
require './tally'

def titleize(word)
  humanize(underscore(word)).gsub(/\b('?[a-z])/) { $1.capitalize }
end