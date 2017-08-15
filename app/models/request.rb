# == Schema Information
#
# Table name: requests
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  resource        :string(255)
#  url             :string(255)
#  method          :string(255)
#  response_string :string(255)
#  response_code   :integer
#  headers         :string(255)
#  bytes           :integer
#  tts             :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Request < ActiveRecord::Base
end
