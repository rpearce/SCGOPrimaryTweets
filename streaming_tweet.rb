require './includes'

class StreamingTweet
  include MongoMapper::Document

  # key :created_at, Time
  # key :id, Integer
  # key :geo, String
  # key :retweet_count, Integer
  # key :favorited, Boolean
  key :text, String
  # key :in_reply_to_status_id_str, String
  # key :in_reply_to_screen_name, String
  # key :in_reply_to_user_id_str, String
  # key :retweeted, Boolean
  # key :in_reply_to_status_id, Integer
  # key :source, String
  # key :id_str, String
  # key :entities, Hash
  # key :place, String
  # key :truncated, Boolean
  # key :coordinates, String
  # key :user, Hash
  # key :in_reply_to_user_id, Integer
end