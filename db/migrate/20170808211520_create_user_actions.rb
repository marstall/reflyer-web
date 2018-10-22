class CreateUserActions < ActiveRecord::Migration
  def change
    create_table :user_actions do |t|
      t.string  :action_type
      t.string  :action_subtype
      t.integer :flyer_id
      t.string  :description
      t.timestamps null: false
    end
  end
end
