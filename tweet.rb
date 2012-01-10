require './includes'

class Tweet
  include MongoMapper::Document

  key :created_at, Time
  key :entities, Hash
  key :from_user, String
  key :from_user_id, Integer
  key :from_user_id_str, String
  key :from_user_name, String
  key :geo, String
  key :location, String
  key :id, Integer
  key :id_str, String
  key :iso_language_code, String
  key :metadata, Hash
  key :profile_image_url, String
  key :profile_image_url_https, String
  key :source, String
  key :text, String
  key :to_user, String
  key :to_user_id, Integer
  key :to_user_id_str, String
  key :to_user_name, String
  key :location_found_within, String
end