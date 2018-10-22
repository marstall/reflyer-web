class AddSuperTitleToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :super_title, :string
  end
end
