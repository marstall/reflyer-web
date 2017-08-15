class AddResourceToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :resource, :string, :after=>:user_id
  end
end
