class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.string :twitter_uid
      t.string :twitter_username
      t.string :avatar_url
      t.integer :crawl_interval
      t.integer :latest_crawl_fav_count
      t.datetime :last_refreshed_from_twitter
      t.integer :followers_count
      t.integer :favorites_count
      t.integer :friends_count
      t.integer :statuses_count
      t.datetime :created_at
      t.boolean :ready_to_be_crawled
      t.boolean :crawling_enabled
      t.datetime :latest_crawl_time
      t.datetime :next_crawl_time

      t.timestamps
    end
  end
end
