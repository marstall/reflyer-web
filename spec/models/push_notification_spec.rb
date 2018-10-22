# == Schema Information
#
# Table name: push_notifications
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  body           :text(65535)
#  pushed_at      :datetime
#  recipient_type :string(255)
#  place_id       :integer
#  category       :string(255)
#  user_id        :integer
#  response_code  :string(255)
#  response_json  :text(65535)
#  error_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  success_count  :integer
#

require 'spec_helper'

RSpec.describe PushNotification, type: :model do
  it "sends a push to a single person" do 
    pn = PushNotification.create("single",128)
    pn.title = "Flyer of the Week: THE HUNGER"
    pn.body = "Cult movie! David Bowie! Catherine Deneuve! 1983! THIS SATURDAY at the Brattle. --CM"
    pn.send_push
  end
  it "sends a push to everyone" do 
    pn = PushNotification.create("all")
    pn.title = "Flyer of the Week: THE HUNGER"
    pn.body = "Cult movie! David Bowie! Catherine Deneuve! 1983! THIS SATURDAY at the Brattle. --CM"
    pn.send_push
  end
end
