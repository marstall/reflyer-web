class AddLatlngToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :latlng, "point"
  end
end
