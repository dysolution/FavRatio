class Tweet < ActiveRecord::Base
  has_many :favs
  belongs_to :author, class_name: "TwitterUser"

  validates_length_of :text, :maximum => 140
  validates_presence_of :author_id, :text
  validates_uniqueness_of :twitter_uid

  def inspect
    "#{text}"
  end
end

# == Schema Information
#
# Table name: tweets
#
#  id                :integer          not null, primary key
#  twitter_uid       :string(255)
#  text              :text
#  author_id         :integer
#  timestamp         :datetime
#  is_atreply        :boolean
#  fav_count         :integer
#  fav_weight        :float
#  favs_per_follower :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

