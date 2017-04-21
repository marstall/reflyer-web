class AddPlaceIdToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :place_id, :integer
  end
end
