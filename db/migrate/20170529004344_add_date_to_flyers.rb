class AddDateToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :start_date, :datetime
  end
end
