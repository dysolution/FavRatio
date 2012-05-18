class Tweet < ActiveRecord::Base
  has_many :favs
end
