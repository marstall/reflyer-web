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
#

class UserActionSerializer < ActiveModel::Serializer
  attributes :id, :action_type,:action_subtype, :description, :flyer_id
end
