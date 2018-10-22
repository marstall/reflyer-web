class ModifyBuzzOnFlyers < ActiveRecord::Migration
  def change
    change_column :flyers, :buzz, :text
  end
end
