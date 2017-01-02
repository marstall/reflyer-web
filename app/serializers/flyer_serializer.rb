class FlyerSerializer < ActiveModel::Serializer
  attributes :id, :original_url, :medium_url, :thumb_url
end
