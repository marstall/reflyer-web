class AddLatLongToFlyersAndPlaces < ActiveRecord::Migration
  def change
    add_column :flyers, :lat, :double
    add_column :flyers, :lng, :double
    add_column :places, :lat, :double
    add_column :places, :lng, :double
  end
end
