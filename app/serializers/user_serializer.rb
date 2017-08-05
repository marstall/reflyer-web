class UserSerializer < ActiveModel::Serializer
  attributes :id, :metro_code, :expo_push_token
end
