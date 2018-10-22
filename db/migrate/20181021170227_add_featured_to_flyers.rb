class AddFeaturedToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :featured, :boolean, default: false
  end
end
