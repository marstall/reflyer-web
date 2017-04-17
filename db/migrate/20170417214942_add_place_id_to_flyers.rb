class AddPlaceIdToFlyers < ActiveRecord::Migration
  def change
    remove_column :flyers, :venue_name
    add_column :flyers, :place_id, :integer
  end
end
