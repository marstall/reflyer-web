class AddScoreToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :score, :Integer
  end
end
