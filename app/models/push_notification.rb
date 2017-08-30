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
#

class PushNotification < ActiveRecord::Base

  RECIPIENT_TYPE_ALL='all'
  RECIPIENT_TYPE_SINGLE='single'
  
  validates_presence_of :recipient_type, :body
  validate :recipient_type_single_must_have_user_id
  
  expo_push_tokens=nil
  
  def recipient_type_single_must_have_user_id
    if recipient_type==RECIPIENT_TYPE_SINGLE && !user_id
      errors.add("must specify user_id for 'single' type push notification")
  end
  
  def PushNotification.create(recipient_type,recipient_identifier)
    push_notification = PushNotification.new
    push_notification.recipient_type = recipient_type
    case recipient_type
    when RECIPIENT_TYPE_SINGLE
      push_notification.user_id=recipient_identifier
    end
  end

  def send
    puts "fatal errors: #{errors.join(',')}" && return    unless valid?
    
    case recipient_type
    when RECIPIENT_TYPE_SINGLE
      send_to_single_user
    when RECIPIENT_TYPE_ALL
      send_to_all_users
    end
  end
  
  def send_to_single_user
    exponent = Exponent::Push::Client.new
    user = User.find(user_id)
    puts "can't find user" and return unless user
    @expo_push_tokens = [user.expo_push_token]
    actually_send_push_notifications
  end
  
  def actually_send_push_notifications
    messages = @expo_push_tokens.map{|expo_push_token|
      return {
        to: expo_push_token,
        body: body
      }
    }
    puts "input: #{messages.inspect}"
    result = exponent.publish messages
    puts "output: #{result}"
  end

end
