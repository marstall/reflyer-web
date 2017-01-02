FactoryGirl.define do
  sequence(:email_address) { |n| "person-#{n}@example.com" }
  sequence(:name) { |n| "person-#{n}"}

  factory :user do
    name
    email_address
  end
end
