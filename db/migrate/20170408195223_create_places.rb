=begin
 "venue"=>"{\"id\":\"4c23ec8cc9bbef3b631fafac\",\"name\":\"Codman Commons\",
\"location\":{\"address\":\"Washington St\",\"crossStreet\":\"Talbot Ave\",
\"lat\":42.2902626498602,\"lng\":-71.071457862854,
\"labeledLatLngs\":[{\"label\":\"display\",\"lat\":42.2902626498602,
\"lng\":-71.071457862854}],\"distance\":667,
\"postalCode\":\"02124\",\"cc\":\"US\",\"city\":
\"Dorchester\",\"state\":\"MA\",\"country\":\"United States\",
\"formattedAddress\":[\"Washington St (Talbot Ave)\",\"Dorchester, MA 02124\",
\"United States\"]},
\"categories\":[{\"id\":\"4bf58dd8d48988d163941735\",\"name\":
\"Park\",\"pluralName\":\"Parks\",\"shortName\":\"Park\",
\"icon\":{\"prefix\":\"https://ss3.4sqi.net/img/categories_v2/parks_outdoors/park_\",
\"suffix\":\".png\"},\"primary\":true}],\"verified\":false,
\"stats\":{\"checkinsCount\":19,\"usersCount\":7,\"tipCount\":0},
\"beenHere\":{\"lastCheckinExpiredAt\":0},
\"specials\":{\"count\":0,\"items\":[]},\"referralId\":\"v-1491680643\",
\"venueChains\":[],\"hasPerk\":false}", "category"=>"theatre"}}
=end
#select name as nm,st_distance_sphere(@bos,latlng)/1000/1.6 from metros where st_distance_sphere(@bos,latlng)/1000/1.6<300 order by st_distance_sphere(@bos,latlng)/1000/1.6;

class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string    :name      
      t.string    :source    
      t.string    :source_id 
      t.column    :latlng, 'point'    
      t.string    :city
      t.string    :state
      t.string    :country
      t.string    :formatted_address
      t.timestamps
    end
  end
end
