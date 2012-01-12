require 'rubygems'
require 'twitter'
require 'mongo'
require 'mongo_mapper'
require 'csv'
require './tweet'

def titleize(word)
  humanize(underscore(word)).gsub(/\b('?[a-z])/) { $1.capitalize }
end