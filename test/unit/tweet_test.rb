# == Schema Information
#
# Table name: tweets
#
#  id                :integer         not null, primary key
#  twitter_uid       :string(255)
#  text              :text
#  twitter_user_id   :integer
#  timestamp         :datetime
#  is_atreply        :boolean
#  fav_count         :integer
#  fav_weight        :float
#  favs_per_follower :float
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
