require './includes'

class Tally
  include MongoMapper::Document

  key :created_at, Time
  key :gingrich_total, Integer
  key :huntsman_total, Integer
  key :perry_total, Integer
  key :paul_total, Integer
  key :romney_total, Integer
  key :santorum_total, Integer
end