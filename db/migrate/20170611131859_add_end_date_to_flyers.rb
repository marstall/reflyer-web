class AddEndDateToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :end_date, :datetime
  end
end
