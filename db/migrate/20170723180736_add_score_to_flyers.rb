class AddScoreToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :score, :Integer, default:0, null:false
  end
end
