class Tweet < ActiveRecord::Base
  has_many :favs
  belongs_to :author, class_name: "TwitterUser"
  validates :text, presence: true,
            length: { maximum: 140 }
  validates :author_id, presence: true
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

