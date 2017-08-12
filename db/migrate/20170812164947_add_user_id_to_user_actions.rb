class AddUserIdToUserActions < ActiveRecord::Migration
  def change
    add_column :user_actions, :user_id, :integer
  end
end
