json.extract! user_action, :id, :created_at, :updated_at
json.url user_action_url(user_action, format: :json)