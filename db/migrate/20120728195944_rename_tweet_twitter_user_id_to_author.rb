class RenameTweetTwitterUserIdToAuthor < ActiveRecord::Migration
  def change
    rename_column :tweets, :twitter_user_id, :author_id
  end
end
