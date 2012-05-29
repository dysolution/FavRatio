# == Schema Information
#
# Table name: favs
#
#  id         :integer         not null, primary key
#  tweet_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  faver_id   :integer
#

class Fav < ActiveRecord::Base
  attr_accessible :tweet_id, :faver_id
  belongs_to :tweet

  validates :tweet_id, :presence => true
  validates :faver_id, :presence => true
  validates_uniqueness_of :tweet_id, :scope => :faver_id

end
