class CreatePushNotifications < ActiveRecord::Migration
  def change
    create_table :push_notifications do |t|
      t.string :title
      t.text :body
      t.datetime :pushed_at
      t.string :recipient_type
      t.integer :place_id
      t.string :category
      t.integer :user_id
      t.string :response_code
      t.text :response_json
      t.integer :error_count

      t.timestamps null: false
    end
  end
end
