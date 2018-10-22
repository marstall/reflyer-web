# == Schema Information
#
# Table name: user_actions
#
#  id             :integer          not null, primary key
#  action_type    :string(255)
#  action_subtype :string(255)
#  flyer_id       :integer
#  description    :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  data           :string(255)
#

class UserAction < ActiveRecord::Base
  belongs_to :user
  has_one :flyer
  
  def data_as_dates
    JSON.parse(data).map{|timestamp|
      Time.at(timestamp/1000).to_datetime
    }.join(", ")
  end
end
