# == Schema Information
#
# Table name: places
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  source            :string(255)
#  source_id         :string(255)
#  latlng            :integer
#  city              :string(255)
#  state             :string(255)
#  country           :string(255)
#  formatted_address :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class FlyerSerializer < ActiveModel::Serializer
  attributes :id, :name, :source_id
end
