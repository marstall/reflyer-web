# == Schema Information
#
# Table name: flyers
#
#  id                 :integer          not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  user_id            :integer
#  image_url          :string(255)
#  flagged            :string(255)
#  status             :string(8)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  image_fingerprint  :string(64)
#  body               :text(65535)
#  category           :string(255)
#  ltlng              :integer
#  latlng             :integer
#  place_id           :integer
#

FactoryGirl.define do
  factory :flyer do
    user { FactoryGirl.create :user }
    image { File.new("#{Rails.root}/spec/fixtures/khaki.jpg") }
  end
end
