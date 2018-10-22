# == Schema Information
#
# Table name: push_notifications
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  body           :text(65535)
#  pushed_at      :datetime
#  recipient_type :string(255)
#  place_id       :integer
#  category       :string(255)
#  user_id        :integer
#  response_code  :string(255)
#  response_json  :text(65535)
#  error_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  success_count  :integer
#

class PushNotificationSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :pushed_at, :recipient_type, :place_id, :category, :user_id, :response_code, :response_json, :error_count
end
