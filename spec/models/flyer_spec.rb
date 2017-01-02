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
