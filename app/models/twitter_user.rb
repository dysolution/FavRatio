class TwitterUser < ActiveRecord::Base

  require 'user_crawler'
  require 'user_refresher'

  FAVRATIO_TWITTER_USER_ID = '228903682'

	has_many :favs, foreign_key: 'faver_id'
	has_many :tweets, foreign_key: 'author_id'

  validates_uniqueness_of :twitter_uid

  scope :crawlable, where(crawling_enabled: true)

  before_create :default_values

  def default_values
    now = DateTime.now
    self.crawl_interval    ||= 120
    self.latest_crawl_time ||= now
    self.next_crawl_time   ||= now
    self.crawling_enabled  ||= false
    true # throws RecordNotSaved if above returns false
  end

  def self.crawl_all
    self.crawlable.map(&:crawl)
  end

  def self.crawl_all!
    # Crawl them all, no matter what.
    self.crawlable.map(&:crawl!)
  end

  def self.refresh_crawlable_users
    # TODO: clean this up
    # only crawl people who are following @FavRatio
    follower_ids = Twitter.follower_ids("FavRatio").collection[0,3]
    follower_ids.each do |twitter_uid|
      user = self.find_by_twitter_uid twitter_uid
      unless user
        user = TwitterUser.create(:twitter_uid => tu)
      end
      user.refresh_from_twitter
      user.crawling_enabled = true
    end
  end

  def to_s
    "#{twitter_username}"
  end

  def crawl
    return false if twitter_uid.nil? or
      not ready_to_be_crawled?
    run_crawl
  end

  def crawl!
    # Crawl even if an interval hasn't yet passed.
    run_crawl
  end

  def favs_are_stale
    self.next_crawl_time < Time.now
  end

  def prepare_for_next_crawl
    set_latest_crawl_time
    set_next_crawl_time
  end

  def refresh_from_twitter
    refresher = UserRefresher.new(self)
    refresher.refresh
  end

  private

  def run_crawl
    crawler = UserCrawler.new(self)
    crawler.crawl
    prepare_for_next_crawl
    crawler.stats
  end

  def set_latest_crawl_time
    self.latest_crawl_time = Time.now
    save
  end

  def set_next_crawl_time
    self.next_crawl_time = crawl_interval.minutes.from_now
    save
  end

  def ready_to_be_crawled?
    !!twitter_uid and favs_are_stale and crawling_enabled
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
#  created_at                  :datetime         not null
#  crawling_enabled            :boolean
#  latest_crawl_time           :datetime
#  next_crawl_time             :datetime
#  updated_at                  :datetime         not null
#

