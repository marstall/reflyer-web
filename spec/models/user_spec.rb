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

require 'rails_helper'

RSpec.describe User, type: :model do
end
