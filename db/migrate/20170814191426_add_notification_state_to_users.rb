class AddNotificationStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifications_permission_state, :string
  end
end
