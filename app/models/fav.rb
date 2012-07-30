class Fav < ActiveRecord::Base
  attr_accessible :tweet_id, :faver_id
  belongs_to :tweet
  belongs_to :faver, class_name: "TwitterUser"

  validates_presence_of :tweet_id, :faver_id
  validates_uniqueness_of :faver_id, :scope => :tweet_id


  def inspect
    "#{tweet_id} faved by #{faver.twitter_username}"
  end

end

# == Schema Information
#
# Table name: favs
#
#  id         :integer          not null, primary key
#  tweet_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faver_id   :integer
#

