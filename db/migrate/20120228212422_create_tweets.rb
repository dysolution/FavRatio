class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :twitter_uid
      t.text :text
      t.integer :twitter_user_id
      t.datetime :timestamp
      t.boolean :is_atreply
      t.integer :fav_count
      t.float :fav_weight
      t.float :favs_per_follower
      t.string :hash

      t.timestamps
    end
  end
end
