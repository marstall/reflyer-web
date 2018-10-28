class AddUrlToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :url, :string
  end
end
