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

class Place < ActiveRecord::Base

  def set_latlng(location_hash)
    puts "location_hash: #{location_hash}"
    lng = location_hash["lng"]
    lat = location_hash["lat"]
    latlng = "st_geomfromtext('place(#{lng} #{lat})')"
  end
end
