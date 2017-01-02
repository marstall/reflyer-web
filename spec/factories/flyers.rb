FactoryGirl.define do
  factory :flyer do
    user { FactoryGirl.create :user }
    image { File.new("#{Rails.root}/spec/fixtures/khaki.jpg") }
  end
end
