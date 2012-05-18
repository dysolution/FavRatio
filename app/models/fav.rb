class Fav < ActiveRecord::Base
  attr_accessible :tweet_id
  belongs_to :tweet
end
