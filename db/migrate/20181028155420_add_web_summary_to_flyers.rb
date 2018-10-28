class AddWebSummaryToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :webSummary, :string
  end
end
