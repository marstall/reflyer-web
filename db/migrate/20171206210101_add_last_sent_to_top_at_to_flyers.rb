class AddLastSentToTopAtToFlyers < ActiveRecord::Migration
  def change
    add_column :flyers, :last_sent_to_top_at, :datetime
  end
end
