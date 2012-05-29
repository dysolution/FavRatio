# == Schema Information
#
# Table name: twitter_users
#
#  id                          :integer         not null, primary key
#  twitter_uid                 :string(255)
#  twitter_username            :string(255)
#  avatar_url                  :string(255)
#  crawl_interval              :integer
#  latest_crawl_fav_count      :integer
#  last_refreshed_from_twitter :datetime
#  followers_count             :integer
#  favorites_count             :integer
#  friends_count               :integer
#  statuses_count              :integer
#  created_at                  :datetime        not null
#  ready_to_be_crawled         :boolean
#  crawling_enabled            :boolean
#  latest_crawl_time           :datetime
#  next_crawl_time             :datetime
#  updated_at                  :datetime        not null
#

require 'test_helper'

class TwitterUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
