class TwitterUser < ActiveRecord::Base

	has_many :favs, foreign_key: 'faver_id'
	has_many :tweets, foreign_key: 'author_id'

  scope :crawlable, where(crawling_enabled: true)

  before_create :default_values
  
  def default_values
    self.crawl_interval    ||= 120
    self.latest_crawl_time ||= DateTime.now.utc
    self.next_crawl_time   ||= DateTime.now.utc
    self.crawling_enabled  ||= false
  end

  def self.crawl_all
    self.crawlable.each do |user|
      user.crawl
      end
  end

	def self.refresh_crawlable_users
		# only crawl people who are following @FavRatio
		follower_ids = Twitter.follower_ids("FavRatio").collection[0,3]
		follower_ids.each do |tu|
			unless self.find_by_twitter_uid tu
				new_twitter_user = TwitterUser.create(:twitter_uid => tu)
				new_twitter_user.refresh_from_twitter
			end
		end
	end

	def get_favs
		# get the latest 20 favs for this user
    Twitter.favorites(twitter_uid.to_i)
  end

  def crawl
    favs = get_favs
    favs_found = []
    favs.each do |favored_tweet|
      # create the user if necessary
      author = TwitterUser.find_or_create_by_twitter_uid(favored_tweet.user.id.to_s)

      # create the tweet if necessary
      tweet_attr = {
        :twitter_uid => favored_tweet.id,
        :text => favored_tweet.text,
        :twitter_user_id => author.id,
        :timestamp => favored_tweet.created_at
      }
      t = Tweet.create(tweet_attr)

      # create the fav if necessary
      new_fav = Fav.new(:faver_id => self.id, :tweet_id => t.id)
      favs_found << new_fav if new_fav.save
    end
    favs_found
  end


  def refresh_from_twitter
  	info_from_twitter = Twitter.user(twitter_uid.to_i)
    attr = {
      :followers_count   => info_from_twitter.followers_count,
      :favorites_count   => info_from_twitter.favourites_count,
      :friends_count     => info_from_twitter.friends_count,
      :avatar_url        => info_from_twitter.profile_image_url,
      :statuses_count    => info_from_twitter.statuses_count,
      :twitter_username  => info_from_twitter.screen_name
    }
    update_attributes(attr)
  end



end

# == Schema Information
#
# Table name: twitter_users
#
#  id                          :integer          not null, primary key
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
#  created_at                  :datetime         not null
#  ready_to_be_crawled         :boolean
#  crawling_enabled            :boolean
#  latest_crawl_time           :datetime
#  next_crawl_time             :datetime
#  updated_at                  :datetime         not null
#

