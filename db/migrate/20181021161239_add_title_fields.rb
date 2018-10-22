class AddTitleFields < ActiveRecord::Migration
  def change
    add_column :flyers, :email_title, :string
    add_column :flyers, :web_title, :string
    remove_column :flyers, :title
  end
end
