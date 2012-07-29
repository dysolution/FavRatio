class RemoveExtraneousFieldsFromTwitterUsers < ActiveRecord::Migration
  def up
    remove_column :twitter_users, :statuses_count
    remove_column :twitter_users, :friends_count
    remove_column :twitter_users, :favorites_count
    remove_column :twitter_users, :followers_count
  end

  def down
    add_column :twitter_users, :statuses_count, :integer
    add_column :twitter_users, :friends_count, :integer
    add_column :twitter_users, :favorites_count, :integer
    add_column :twitter_users, :followers_count, :integer
  end
end
