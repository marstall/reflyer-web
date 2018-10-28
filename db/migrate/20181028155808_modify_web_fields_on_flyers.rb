class ModifyWebFieldsOnFlyers < ActiveRecord::Migration
  def change
    remove_column :flyers, :webHighlight
    remove_column :flyers, :webSummary
    add_column :flyers, :webHighlight, :text
    add_column :flyers, :webSummary, :text
  end
end
