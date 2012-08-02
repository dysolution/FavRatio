class AddIndexToTweet < ActiveRecord::Migration
  def change
    add_index :tweets, :twitter_uid, unique: true
  end
end
