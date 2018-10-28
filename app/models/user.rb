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
#  admin                          :boolean
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable
  has_many :user_actions
  has_many :requests
end
