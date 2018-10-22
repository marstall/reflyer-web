class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.string :url
      t.string :response_string
      t.integer :http_code
      t.string :headers
      t.integer :bytes
      t.integer :tts

      t.timestamps null: false
    end
  end
end
