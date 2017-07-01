class AddTitleAndBuzzToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :title, :string
    add_column :flyers, :buzz, :string
  end
end
