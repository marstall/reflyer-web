# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  metro_code                     :string(255)
#  expo_push_token                :string(255)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  device_id                      :string(255)
#  notifications_permission_state :string(255)
#  email                          :string(255)      default(""), not null
#  encrypted_password             :string(255)      default(""), not null
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :metro_code, :expo_push_token
end
