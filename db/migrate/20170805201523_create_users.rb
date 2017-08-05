class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :metro_code
      t.string :expo_push_token

      t.timestamps null: false
    end
  end
end
