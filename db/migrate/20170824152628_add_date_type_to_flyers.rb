class AddDateTypeToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :date_type, :string
  end
end
