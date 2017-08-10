# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  metro_code      :string(255)
#  expo_push_token :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
end
