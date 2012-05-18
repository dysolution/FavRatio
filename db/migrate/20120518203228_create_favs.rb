class CreateFavs < ActiveRecord::Migration
  def change
    create_table :favs do |t|
      t.integer :tweet_id

      t.timestamps
    end
  end
end
