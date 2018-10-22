json.extract! user, :id, :metro_code, :expo_push_token, :created_at, :updated_at
json.url user_url(user, format: :json)