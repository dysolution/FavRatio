class AddFaverIdToFavs < ActiveRecord::Migration
  def change
    add_column :favs, :faver_id, :integer
  end
end
