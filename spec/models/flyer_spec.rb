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

require 'rails_helper'

RSpec.describe Flyer, type: :model do
  it "should upload an attachment" do
    flyer = FactoryGirl.create :flyer
    flyer.image = File.new("spec/fixtures/khaki.jpg")
    flyer.save!
    puts "flyer.image.url:#{flyer.image.url}"
    expect(flyer.image.url).not_to be_nil
  end
end
