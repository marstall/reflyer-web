class AddDataToUserActions < ActiveRecord::Migration
  def change
    add_column :user_actions, :data, :string
  end
end
