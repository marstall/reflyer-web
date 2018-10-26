class AddTitleToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :title, :string
  end
end
