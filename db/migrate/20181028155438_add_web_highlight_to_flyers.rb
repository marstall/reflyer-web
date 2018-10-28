class AddWebHighlightToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :webHighlight, :string
  end
end
