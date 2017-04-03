class AddVenueNameAndCategoryToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :venue_name, :string
    add_column :flyers, :category, :string
  end
end
