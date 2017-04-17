# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  email_address     :string(255)
#  password          :string(255)
#  registered_on     :datetime
#  last_logged_in_on :datetime
#  privs             :string(58)
#  last_visited_on   :datetime
#  last_user_agent   :string(255)
#  referer_domain    :string(128)
#  referer_path      :string(255)
#

FactoryGirl.define do
  sequence(:email_address) { |n| "person-#{n}@example.com" }
  sequence(:name) { |n| "person-#{n}"}

  factory :user do
    name
    email_address
  end
end
