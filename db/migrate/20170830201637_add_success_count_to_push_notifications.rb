class AddSuccessCountToPushNotifications < ActiveRecord::Migration
  def change
    add_column :push_notifications, :success_count, :integer
  end
end
