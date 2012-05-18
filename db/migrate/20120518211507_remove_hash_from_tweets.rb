class RemoveHashFromTweets < ActiveRecord::Migration
  def up
    remove_column :tweets, :hash
      end

  def down
    add_column :tweets, :hash, :string
  end
end
