class RemoveReadyToBeCrawledFromTwitterUsers < ActiveRecord::Migration
  def up
    remove_column :twitter_users, :ready_to_be_crawled
  end

  def down
    add_column :twitter_users, :ready_to_be_crawled, :boolean
  end
end
