json.user do
  json.id @user.id
  json.expo_push_token @user.expo_push_token
  json.metro_code @user.metro_code
end

json.flyers @flyers do |flyer|
  json.(flyer,
    :id, :title,:buzz,:body, :original_url, :medium_url, 
    :thumb_url,:place,:category, :age, :iso8601_start_date,
    :iso8601_end_date, :score)
    json.(flyer.place,
      :id, :name, :city, :state, :formatted_address, :source_id, :latlng, :lat, :lng )
end
  