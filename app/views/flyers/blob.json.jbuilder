json.user do
  json.id @user.id
  json.expo_push_token @user.expo_push_token
  json.metro_code @user.metro_code
  json.device_id @user.device_id
  json.notifications_permission_state @user.notifications_permission_state  
  json.user_actions @user.user_actions do |user_action|
    json.flyer_id user_action.flyer_id
    json.action_type user_action.action_type
    json.action_subtype user_action.action_subtype
  end
end

json.flyers @flyers do |flyer|
  json.(flyer,
    :title,:id,:buzz,:body, :original_url, :medium_url,
    :thumb_url,:place,:category, :age, :iso8601_start_date,
    :iso8601_end_date, :place_id, :score, :num_user_actions)
    json.(flyer.place,
      :name, :city, :state, :formatted_address, :source_id, :latlng, :lat, :lng )
end
  