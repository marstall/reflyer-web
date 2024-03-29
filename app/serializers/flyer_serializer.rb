# == Schema Information
#
# Table name: flyers
#
#  id                  :integer          not null, primary key
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#  image_url           :string(255)
#  flagged             :string(255)
#  status              :string(8)
#  image_file_name     :string(255)
#  image_content_type  :string(255)
#  image_file_size     :integer
#  image_updated_at    :datetime
#  image_fingerprint   :string(64)
#  body                :text(65535)
#  venue_name          :string(255)
#  category            :string(255)
#  latlng              :integer
#  place_id            :integer
#  lat                 :float(53)
#  lng                 :float(53)
#  start_date          :datetime
#  end_date            :datetime
#  buzz                :text(65535)
#  score               :integer          default(0), not null
#  date_type           :string(255)
#  last_sent_to_top_at :datetime
#  email_title         :string(255)
#  web_title           :string(255)
#  featured            :boolean          default(FALSE)
#  super_title         :string(255)
#  title               :string(255)
#  url                 :string(255)
#  webSummary          :string(255)
#  webHighlight        :string(255)
#

class FlyerSerializer < ActiveModel::Serializer
  attributes :id, :title,:web_title,:url,:webSummary,:webHighlight,:buzz,:body, :original_url, :medium_url, :thumb_url,:place,:category, :age, :iso8601_start_date,:iso8601_end_date,:score
  has_one :place
end
